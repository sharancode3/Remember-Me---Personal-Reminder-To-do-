import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import '../../data/models/task_occurrence_model.dart';
import '../logging/app_logger.dart';
import 'reminder_scheduler.dart';

class AndroidReminderScheduler implements ReminderScheduler {
  AndroidReminderScheduler([MethodChannel? channel])
      : _channel = channel ?? const MethodChannel('remember_me/daily');

  final MethodChannel _channel;
  static final _logger = AppLogger.create('AndroidReminderScheduler');

  @override
  Future<void> scheduleOccurrence(
    TaskOccurrence occurrence,
    String title, {
    bool isAlarmStyle = false,
    int nagMinutes = 0,
    int nagMax = 0,
  }) async {
    if (kIsWeb || defaultTargetPlatform != TargetPlatform.android) return;
    try {
      await _channel.invokeMethod<void>('scheduleAlarm', {
        'occurrenceId': occurrence.id,
        'title': title,
        'triggerAt': occurrence.scheduledAt.millisecondsSinceEpoch,
        'isAlarmStyle': isAlarmStyle,
        'nagMinutes': nagMinutes,
        'nagMax': nagMax,
      });
      _logger.info('Scheduled alarm for occurrence #${occurrence.id} ($title) at ${occurrence.scheduledAt}');
    } catch (e, st) {
      _logger.severe('Failed to schedule alarm for occurrence #${occurrence.id}', e, st);
    }
  }

  @override
  Future<void> cancelOccurrence(int occurrenceId) async {
    if (kIsWeb || defaultTargetPlatform != TargetPlatform.android) return;
    try {
      await _channel.invokeMethod<void>('cancelAlarm', {
        'occurrenceId': occurrenceId,
      });
      _logger.info('Cancelled alarm for occurrence #$occurrenceId');
    } catch (e, st) {
      _logger.severe('Failed to cancel alarm for occurrence #$occurrenceId', e, st);
    }
  }

  @override
  Future<void> reconcile(
    List<TaskOccurrence> desired, {
    Map<int, String>? titles,
    Map<int, bool>? alarmStyles,
    Map<int, int>? nagMinutes,
  }) async {
    if (kIsWeb || defaultTargetPlatform != TargetPlatform.android) return;
    try {
      final list = desired.map((occ) => {
        'occurrenceId': occ.id,
        'title': titles?[occ.taskId] ?? 'Reminder',
        'triggerAt': occ.scheduledAt.millisecondsSinceEpoch,
        'isAlarmStyle': alarmStyles?[occ.taskId] ?? false,
        'nagMinutes': nagMinutes?[occ.taskId] ?? 0,
        'nagMax': (nagMinutes?[occ.taskId] ?? 0) > 0 ? 5 : 0,
        'nagCount': 0,
      }).toList();
      await _channel.invokeMethod<void>('reconcileAlarms', {'desired': list});
      _logger.info('Reconciled ${desired.length} occurrences with native scheduler');
    } catch (e, st) {
      _logger.severe('Failed to reconcile alarms', e, st);
    }
  }

  @override
  Future<List<Map<String, dynamic>>> drainOutbox() async {
    if (kIsWeb || defaultTargetPlatform != TargetPlatform.android) return [];
    try {
      final list = await _channel.invokeListMethod<dynamic>('drainNotificationOutbox');
      if (list == null) return [];
      return list.map((item) => Map<String, dynamic>.from(item as Map)).toList();
    } catch (e, st) {
      _logger.severe('Failed to drain notification outbox', e, st);
      return [];
    }
  }

  @override
  Future<void> acknowledgeOutbox(List<String> uuids) async {
    if (kIsWeb || defaultTargetPlatform != TargetPlatform.android || uuids.isEmpty) return;
    try {
      await _channel.invokeMethod<void>('acknowledgeOutboxActions', {
        'uuids': uuids,
      });
      _logger.info('Acknowledged ${uuids.length} outbox actions');
    } catch (e, st) {
      _logger.severe('Failed to acknowledge outbox actions', e, st);
    }
  }

  @override
  Future<void> testReminderIn10s() async {
    if (kIsWeb || defaultTargetPlatform != TargetPlatform.android) return;
    try {
      await _channel.invokeMethod<void>('testReminder');
      _logger.info('Triggered test reminder in 10s');
    } catch (e, st) {
      _logger.severe('Failed to trigger test reminder', e, st);
    }
  }

  @override
  Future<Map<String, bool>> getReliabilityStatus() async {
    if (kIsWeb || defaultTargetPlatform != TargetPlatform.android) {
      return {
        'notificationsGranted': true,
        'exactAlarmsGranted': true,
        'batteryOptimizationsIgnored': true,
      };
    }
    try {
      final result = await _channel.invokeMapMethod<String, dynamic>('getReliabilityStatus');
      if (result == null) {
        return {
          'notificationsGranted': false,
          'exactAlarmsGranted': false,
          'batteryOptimizationsIgnored': false,
        };
      }
      return {
        'notificationsGranted': result['notificationsGranted'] == true,
        'exactAlarmsGranted': result['exactAlarmsGranted'] == true,
        'batteryOptimizationsIgnored': result['batteryOptimizationsIgnored'] == true,
      };
    } catch (e, st) {
      _logger.severe('Failed to get reliability status', e, st);
      return {
        'notificationsGranted': false,
        'exactAlarmsGranted': false,
        'batteryOptimizationsIgnored': false,
      };
    }
  }

  @override
  Future<void> openExactAlarmSettings() async {
    if (kIsWeb || defaultTargetPlatform != TargetPlatform.android) return;
    try {
      await _channel.invokeMethod<void>('openExactAlarmSettings');
    } catch (e) {
      _logger.severe('Failed to open exact alarm settings', e);
    }
  }

  @override
  Future<void> openBatteryOptSettings() async {
    if (kIsWeb || defaultTargetPlatform != TargetPlatform.android) return;
    try {
      await _channel.invokeMethod<void>('openBatteryOptSettings');
    } catch (e) {
      _logger.severe('Failed to open battery optimization settings', e);
    }
  }

  @override
  Future<void> openNotificationSettings() async {
    if (kIsWeb || defaultTargetPlatform != TargetPlatform.android) return;
    try {
      await _channel.invokeMethod<void>('openNotificationSettings');
    } catch (e) {
      _logger.severe('Failed to open notification settings', e);
    }
  }

  @override
  Future<void> setReminderSound(String? soundUri) async {
    if (kIsWeb || defaultTargetPlatform != TargetPlatform.android) return;
    try {
      await _channel.invokeMethod<void>('recreateReminderChannelWithSound', {
        'soundUri': soundUri,
      });
      _logger.info('Updated reminder channel sound: $soundUri');
    } catch (e, st) {
      _logger.severe('Failed to update reminder sound', e, st);
    }
  }
}
