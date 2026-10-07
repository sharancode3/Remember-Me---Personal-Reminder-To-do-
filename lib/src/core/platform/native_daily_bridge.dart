import 'dart:convert';
import 'package:flutter/services.dart';

/// Type-safe platform bridge replacing raw magic strings for native Android communication.
class NativeDailyBridge {
  NativeDailyBridge({MethodChannel? channel})
    : _channel = channel ?? const MethodChannel('remember_me/daily');

  static final NativeDailyBridge instance = NativeDailyBridge();

  final MethodChannel _channel;

  MethodChannel get rawChannel => _channel;

  // --- Alarms & Reminders ---

  Future<void> scheduleAlarm({
    required int id,
    required String title,
    required int triggerAtMillis,
    required bool isAlarmStyle,
    int nagMinutes = 0,
  }) async {
    await _channel.invokeMethod<void>('scheduleAlarm', {
      'id': id,
      'title': title,
      'triggerAtMillis': triggerAtMillis,
      'isAlarmStyle': isAlarmStyle,
      'nagMinutes': nagMinutes,
    });
  }

  Future<void> cancelAlarm(int id) async {
    await _channel.invokeMethod<void>('cancelAlarm', {'id': id});
  }

  Future<void> reconcileAlarms(List<Map<String, dynamic>> desired) async {
    await _channel.invokeMethod<void>('reconcileAlarms', {'desired': desired});
  }

  Future<List<Map<String, dynamic>>> drainOutbox() async {
    final result = await _channel.invokeMethod<String>('drainOutbox');
    if (result == null || result.isEmpty) return [];
    try {
      final decoded = jsonDecode(result);
      if (decoded is List) {
        return decoded
            .whereType<Map<Object?, Object?>>()
            .map((e) => Map<String, dynamic>.from(e))
            .toList();
      }
    } catch (_) {}
    return [];
  }

  Future<void> acknowledgeOutboxActions(List<String> uuids) async {
    await _channel.invokeMethod<void>('acknowledgeOutboxActions', {
      'uuids': uuids,
    });
  }

  Future<void> testReminder() async {
    await _channel.invokeMethod<void>('testReminder');
  }

  Future<void> openExactAlarmSettings() async {
    await _channel.invokeMethod<void>('openExactAlarmSettings');
  }

  Future<void> openBatteryOptSettings() async {
    await _channel.invokeMethod<void>('openBatteryOptSettings');
  }

  Future<void> openNotificationSettings() async {
    await _channel.invokeMethod<void>('openNotificationSettings');
  }

  Future<void> recreateReminderChannelWithSound(String? soundUri) async {
    await _channel.invokeMethod<void>('recreateReminderChannelWithSound', {
      'soundUri': soundUri,
    });
  }

  // --- Trail Recording ---

  Future<bool> isTrackingEnabled() async {
    return await _channel.invokeMethod<bool>('trackingEnabled') ?? false;
  }

  Future<bool> isGoogleConfigured() async {
    return await _channel.invokeMethod<bool>('googleConfigured') ?? false;
  }

  Future<void> startTracking() async {
    await _channel.invokeMethod<void>('startTracking');
  }

  Future<void> stopTracking() async {
    await _channel.invokeMethod<void>('stopTracking');
  }

  Future<String> readTrail(String dayString) async {
    return await _channel.invokeMethod<String>('readTrail', {
          'day': dayString,
        }) ??
        '[]';
  }

  Future<void> deleteTrail(String dayString) async {
    await _channel.invokeMethod<void>('deleteTrail', {'day': dayString});
  }

  Future<Map<String, dynamic>?> trackingStatus() async {
    return await _channel.invokeMapMethod<String, dynamic>('trackingStatus');
  }

  Future<void> shareTrail({
    required String text,
    required String filename,
    Uint8List? bytes,
  }) async {
    await _channel.invokeMethod<void>('shareTrail', {
      'text': text,
      'filename': filename,
      'bytes': bytes,
    });
  }

  // --- Places & Geofencing ---

  Future<String> getPlaces() async {
    return await _channel.invokeMethod<String>('getPlaces') ?? '[]';
  }

  Future<void> savePlaces(String jsonString) async {
    await _channel.invokeMethod<void>('savePlaces', {'data': jsonString});
  }

  Future<void> syncTasksByPlace(Map<String, List<String>> tasksByPlace) async {
    await _channel.invokeMethod<void>('syncTasksByPlace', {
      'tasksByPlace': jsonEncode(tasksByPlace),
    });
  }

  Future<void> openAttribution() async {
    await _channel.invokeMethod<void>('openAttribution');
  }

  // --- Theme & Settings ---

  Future<String?> readTheme() async {
    return await _channel.invokeMethod<String>('readTheme');
  }

  Future<void> writeTheme(String themeName) async {
    await _channel.invokeMethod<void>('writeTheme', {'value': themeName});
  }

  Future<String?> getTimeZone() async {
    return await _channel.invokeMethod<String>('timeZone');
  }

  Future<void> openUrl(String url) async {
    await _channel.invokeMethod<void>('openUrl', {'url': url});
  }

  // --- App Widget & Navigation ---

  Future<void> updateWidget(String jsonString) async {
    await _channel.invokeMethod<void>('updateWidget', {'data': jsonString});
  }

  Future<bool> pinWidget() async {
    return await _channel.invokeMethod<bool>('pinWidget') ?? false;
  }

  Future<String?> consumeNavigation() async {
    return await _channel.invokeMethod<String>('consumeNavigation');
  }

  Future<Map<String, dynamic>?> consumeRepeatAction() async {
    return await _channel.invokeMapMethod<String, dynamic>(
      'consumeRepeatAction',
    );
  }

  // --- Focus Guard ---

  Future<bool> isFocusGuardEnabled() async {
    return await _channel.invokeMethod<bool>('focusGuardEnabled') ?? false;
  }

  Future<void> openFocusPermission() async {
    await _channel.invokeMethod<void>('openFocusPermission');
  }

  Future<List<Map<String, dynamic>>> getInstalledApps() async {
    final list = await _channel.invokeListMethod<Map<Object?, Object?>>(
      'installedApps',
    );
    return (list ?? []).map((m) => Map<String, dynamic>.from(m)).toList();
  }

  Future<List<String>> getAllowedApps() async {
    final list = await _channel.invokeListMethod<String>('allowedApps');
    return list ?? [];
  }

  Future<void> saveAllowedApps(List<String> packages) async {
    await _channel.invokeMethod<void>('saveAllowedApps', {
      'packages': packages,
    });
  }

  Future<void> launchAllowedApp(String package) async {
    await _channel.invokeMethod<void>('launchAllowedApp', {'package': package});
  }

  Future<void> startFocus({
    required int start,
    required int end,
    required bool pin,
    required bool block,
  }) async {
    await _channel.invokeMethod<void>('startFocus', {
      'start': start,
      'end': end,
      'pin': pin,
      'block': block,
    });
  }

  Future<Map<String, dynamic>> readFocus() async {
    final map = await _channel.invokeMapMethod<String, dynamic>('readFocus');
    return map ?? {};
  }

  Future<void> stopFocus() async {
    await _channel.invokeMethod<void>('stopFocus');
  }

  Future<int> focusMinutes({required int start, required int end}) async {
    return await _channel.invokeMethod<int>('focusMinutes', {
          'start': start,
          'end': end,
        }) ??
        0;
  }
}
