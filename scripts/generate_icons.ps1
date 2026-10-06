Add-Type -AssemblyName System.Drawing
$srcPath = "C:\Users\tms10\.gemini\antigravity-ide\brain\adf62a94-36a5-410b-8330-2b0aadd3bffb\cracked_alarm_icon_1787965219719.jpg"
$src = [System.Drawing.Image]::FromFile($srcPath)

$configs = @(
    @{ Dir = "mipmap-mdpi"; Size = 48 },
    @{ Dir = "mipmap-hdpi"; Size = 72 },
    @{ Dir = "mipmap-xhdpi"; Size = 96 },
    @{ Dir = "mipmap-xxhdpi"; Size = 144 },
    @{ Dir = "mipmap-xxxhdpi"; Size = 192 }
)

foreach ($cfg in $configs) {
    $dirName = $cfg.Dir
    $sz = $cfg.Size
    $targetFile = "c:\SHARAN PROJECTS\z7.Remember me-NIR\android\app\src\main\res\$dirName\ic_launcher.png"
    
    $dest = New-Object System.Drawing.Bitmap($sz, $sz)
    $g = [System.Drawing.Graphics]::FromImage($dest)
    $g.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
    $g.DrawImage($src, 0, 0, $sz, $sz)
    $g.Dispose()
    
    $dest.Save($targetFile, [System.Drawing.Imaging.ImageFormat]::Png)
    $dest.Dispose()
    Write-Host "Generated $targetFile ($sz x $sz)"
}

$src.Dispose()
