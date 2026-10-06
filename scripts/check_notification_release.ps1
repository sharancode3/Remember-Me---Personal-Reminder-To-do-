param(
    [string]$ApkPath = (Join-Path $PSScriptRoot '../build/app/outputs/flutter-apk/app-release.apk'),
    [string]$DexDumpPath
)

$ErrorActionPreference = 'Stop'
Add-Type -AssemblyName System.IO.Compression.FileSystem

if (-not $DexDumpPath) {
    $sdkRoot = $env:ANDROID_HOME
    if (-not $sdkRoot) { $sdkRoot = $env:ANDROID_SDK_ROOT }
    if (-not $sdkRoot) { $sdkRoot = Join-Path $env:LOCALAPPDATA 'Android/sdk' }
    $DexDumpPath = Get-ChildItem (Join-Path $sdkRoot 'build-tools/*/dexdump.exe') |
        Sort-Object { [version]$_.Directory.Name } -Descending |
        Select-Object -First 1 -ExpandProperty FullName
}
if (-not $DexDumpPath -or -not (Test-Path -LiteralPath $DexDumpPath)) {
    throw 'Android dexdump was not found. Pass -DexDumpPath explicitly.'
}

# Check the shipped DEX, not source rules: R8 can discard reflection metadata.
$signatures = @{}
$apk = [System.IO.Compression.ZipFile]::OpenRead((Resolve-Path -LiteralPath $ApkPath).Path)
try {
    foreach ($entry in $apk.Entries) {
        if ($entry.FullName -notmatch '^classes\d*\.dex$') { continue }
        $temporaryDex = [System.IO.Path]::GetTempFileName()
        try {
            [System.IO.Compression.ZipFileExtensions]::ExtractToFile($entry, $temporaryDex, $true)
            $dump = (& $DexDumpPath -a $temporaryDex) -join "`n"
            if ($LASTEXITCODE -ne 0) { throw "dexdump failed for $($entry.FullName)." }
            $classes = [regex]::Matches($dump,
                '(?ms)^\s*Class #(\d+) annotations:\n(?<annotations>.*?)^\s*Class #\1\s+-\n\s*Class descriptor\s*: ''(?<name>[^'']+)''')
            foreach ($class in $classes) {
                $annotations = $class.Groups['annotations'].Value
                $signature = [regex]::Match($annotations,
                    '(?s)Annotations on class\s+(?:(?!Annotations on (?:method|field)).)*?Ldalvik/annotation/Signature; value=\{(?<value>.*?)\}')
                if ($signature.Success) {
                    $signatures[$class.Groups['name'].Value] = $signature.Groups['value'].Value
                }
            }
        }
        finally {
            Remove-Item -LiteralPath $temporaryDex
        }
    }
}
finally {
    $apk.Dispose()
}

$required = @{
    'Lcom/google/gson/reflect/TypeToken;' = @('<T:', 'Ljava/lang/Object;')
    'Lcom/dexterous/flutterlocalnotifications/FlutterLocalNotificationsPlugin$1;' = @(
        'Lcom/google/gson/reflect/TypeToken<', 'Ljava/util/ArrayList<',
        'Lcom/dexterous/flutterlocalnotifications/models/NotificationDetails;')
    'Lcom/dexterous/flutterlocalnotifications/ScheduledNotificationReceiver$1;' = @(
        'Lcom/google/gson/reflect/TypeToken<',
        'Lcom/dexterous/flutterlocalnotifications/models/NotificationDetails;')
}
foreach ($name in $required.Keys) {
    foreach ($fragment in $required[$name]) {
        if (-not $signatures.ContainsKey($name) -or -not $signatures[$name].Contains($fragment)) {
            throw "Notification reflection metadata is missing from $name. Check the Gson R8 keep rules."
        }
    }
}
Write-Output 'PASS: Gson and both notification readers retain generic signatures in the APK.'
