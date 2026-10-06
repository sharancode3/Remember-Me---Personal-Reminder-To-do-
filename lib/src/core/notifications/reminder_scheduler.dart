import '../../data/models/task_occurrence_model.dart';

abstract class ReminderScheduler {
  Future<void> scheduleOccurrence(
    TaskOccurrence occurrence,
    String title, {
    bool isAlarmStyle = false,
    int nagMinutes = 0,
    int nagMax = 0,
  });

  Future<void> cancelOccurrence(int occurrenceId);

  Future<void> reconcile(
    List<TaskOccurrence> desired, {
    Map<int, String>? titles,
    Map<int, bool>? alarmStyles,
    Map<int, int>? nagMinutes,
  });

  Future<List<Map<String, dynamic>>> drainOutbox();

  Future<void> acknowledgeOutbox(List<String> uuids);

  Future<void> testReminderIn10s();

  Future<Map<String, bool>> getReliabilityStatus();

  Future<void> openExactAlarmSettings();

  Future<void> openBatteryOptSettings();

  Future<void> openNotificationSettings();

  Future<void> setReminderSound(String? soundUri);
}

class InMemoryReminderScheduler implements ReminderScheduler {
  final Map<int, TaskOccurrence> scheduled = {};

  @override
  Future<void> scheduleOccurrence(
    TaskOccurrence occurrence,
    String title, {
    bool isAlarmStyle = false,
    int nagMinutes = 0,
    int nagMax = 0,
  }) async {
    scheduled[occurrence.id] = occurrence;
  }

  @override
  Future<void> cancelOccurrence(int occurrenceId) async {
    scheduled.remove(occurrenceId);
  }

  @override
  Future<void> reconcile(
    List<TaskOccurrence> desired, {
    Map<int, String>? titles,
    Map<int, bool>? alarmStyles,
    Map<int, int>? nagMinutes,
  }) async {
    scheduled.clear();
    for (final occ in desired) {
      scheduled[occ.id] = occ;
    }
  }

  @override
  Future<List<Map<String, dynamic>>> drainOutbox() async => [];

  @override
  Future<void> acknowledgeOutbox(List<String> uuids) async {}

  @override
  Future<void> testReminderIn10s() async {}

  @override
  Future<Map<String, bool>> getReliabilityStatus() async => {
    'notificationsGranted': true,
    'exactAlarmsGranted': true,
    'batteryOptimizationsIgnored': true,
  };

  @override
  Future<void> openExactAlarmSettings() async {}

  @override
  Future<void> openBatteryOptSettings() async {}

  @override
  Future<void> openNotificationSettings() async {}

  @override
  Future<void> setReminderSound(String? soundUri) async {}
}
