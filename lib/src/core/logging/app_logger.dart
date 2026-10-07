import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:logging/logging.dart';
import 'package:path_provider/path_provider.dart';

/// Structured ring-buffered diagnostic logger for Remember Me.
class AppLogger {
  AppLogger._();

  static final Logger _root = Logger('RememberMe');
  static File? _logFile;
  static const int maxFileSizeBytes = 2 * 1024 * 1024; // 2 MB ring buffer

  static Logger get root => _root;

  static Logger create(String name) => Logger(name);

  static Future<void> init() async {
    Logger.root.level = kDebugMode ? Level.ALL : Level.INFO;

    if (!kIsWeb) {
      try {
        final dir = await getApplicationDocumentsDirectory();
        final logDir = Directory('${dir.path}/logs');
        if (!await logDir.exists()) {
          await logDir.create(recursive: true);
        }
        _logFile = File('${logDir.path}/app_diagnostics.log');
      } catch (e) {
        debugPrint('Failed to initialize diagnostic log file: $e');
      }
    }

    Logger.root.onRecord.listen((record) {
      final formatted =
          '${record.time.toIso8601String()} [${record.level.name.padRight(7)}] [${record.loggerName}]: ${record.message}';

      if (kDebugMode) {
        debugPrint(formatted);
        if (record.error != null) debugPrint('Error: ${record.error}');
        if (record.stackTrace != null) debugPrint('${record.stackTrace}');
      }

      _appendToFile(
        formatted,
        error: record.error,
        stackTrace: record.stackTrace,
      );
    });
  }

  static void _appendToFile(
    String line, {
    Object? error,
    StackTrace? stackTrace,
  }) {
    if (_logFile == null) return;
    unawaited(() async {
      try {
        final file = _logFile!;
        var entry = '$line\n';
        if (error != null) entry += '  Error: $error\n';
        if (stackTrace != null) entry += '  StackTrace: $stackTrace\n';

        await file.writeAsString(entry, mode: FileMode.append, flush: false);

        if (await file.length() > maxFileSizeBytes) {
          await _trimRingBuffer(file);
        }
      } catch (_) {
        // Silent fallback in production to avoid crashing on log write failures
      }
    }());
  }

  static Future<void> _trimRingBuffer(File file) async {
    try {
      final lines = await file.readAsLines();
      if (lines.length > 1000) {
        // Keep the last 1000 lines (roughly 100-200 KB)
        final preserved = lines.sublist(lines.length - 1000).join('\n');
        await file.writeAsString('$preserved\n', mode: FileMode.write);
      }
    } catch (_) {}
  }

  static Future<String> readRecentLogs({int maxLines = 300}) async {
    if (_logFile == null || !await _logFile!.exists()) {
      return 'No logs captured yet.';
    }
    try {
      final lines = await _logFile!.readAsLines();
      if (lines.length <= maxLines) return lines.join('\n');
      return lines.sublist(lines.length - maxLines).join('\n');
    } catch (e) {
      return 'Error reading logs: $e';
    }
  }

  static Future<File?> getLogFile() async {
    if (_logFile != null && await _logFile!.exists()) {
      return _logFile;
    }
    return null;
  }

  static Future<void> clearLogs() async {
    if (_logFile != null && await _logFile!.exists()) {
      await _logFile!.writeAsString('', mode: FileMode.write);
    }
  }
}
