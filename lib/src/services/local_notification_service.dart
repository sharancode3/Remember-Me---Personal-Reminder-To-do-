import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;

import '../data/models/task_model.dart';
import 'reminder_recurrence.dart';

class NotificationActionEvent {
  const NotificationActionEvent({
    required this.taskId,
    required this.actionId,
    this.date,
  });

  final int taskId;
  final String actionId;
  final DateTime? date;
}

class LocalNotificationService {
  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();
  final StreamController<NotificationActionEvent> _actions =
      StreamController.broadcast();

  NotificationActionEvent? _launchAction;
  bool _ready = false;
  bool get _supported =>
      !kIsWeb &&
      (defaultTargetPlatform == TargetPlatform.android ||
          defaultTargetPlatform == TargetPlatform.iOS);

  Stream<NotificationActionEvent> get actionEvents async* {
    if (_launchAction != null) {
      yield _launchAction!;
      _launchAction = null;
    }
    yield* _actions.stream;
  }

  Future<void> initialize() async {
    if (!_supported) return;

    const android = AndroidInitializationSettings('@drawable/ic_stat_remember');
    const ios = DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );
    await _plugin.initialize(
      const InitializationSettings(android: android, iOS: ios),
      onDidReceiveNotificationResponse: (response) {
        final parts = (response.payload ?? '').split('|');
        final id = int.tryParse(parts.first) ?? response.id;
        if (id == null) return;
        final actionId = (response.actionId ?? '').trim();
        if (actionId.isEmpty) return;
        _actions.add(
          NotificationActionEvent(
            taskId: id,
            actionId: actionId,
            date: parts.length > 1 ? DateTime.tryParse(parts[1]) : null,
          ),
        );
      },
    );
    _ready = true;

    final launch = await _plugin.getNotificationAppLaunchDetails();
    await cancelDailySummary();
    final response = launch?.notificationResponse;
    if (launch?.didNotificationLaunchApp == true &&
        response != null &&
        (response.actionId ?? '').isNotEmpty) {
      final parts = (response.payload ?? '').split('|');
      final id = int.tryParse(parts.first) ?? response.id;
      if (id != null) {
        _launchAction = NotificationActionEvent(
          taskId: id,
          actionId: response.actionId!,
          date: parts.length > 1 ? DateTime.tryParse(parts[1]) : null,
        );
      }
    }
  }

  Future<void> requestPermissions({bool precise = true}) async {
    if (!_supported) return;

    final granted = await _plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.requestNotificationsPermission();
    if (granted == false) {
      throw StateError(
        'Notifications are disabled. Allow them in phone settings to receive reminders.',
      );
    }
    if (precise) {
      await _plugin
          .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin
          >()
          ?.requestExactAlarmsPermission();
    }
    final iosGranted = await _plugin
        .resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin
        >()
        ?.requestPermissions(alert: true, badge: true, sound: true);
    if (iosGranted == false) {
      throw StateError(
        'Notifications are disabled. Allow them in phone settings to receive reminders.',
      );
    }
  }

  Future<AndroidScheduleMode> _scheduleMode() async {
    final android = _plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();
    final exact = await android?.canScheduleExactNotifications();
    return exact == false
        ? AndroidScheduleMode.inexactAllowWhileIdle
        : AndroidScheduleMode.exactAllowWhileIdle;
  }

  Future<void> cancelRecurring(int id) async {
    if (!_supported || !_ready) return;
    if (defaultTargetPlatform == TargetPlatform.android) {
      await const MethodChannel(
        'remember_me/daily',
      ).invokeMethod<void>('cancelRepeat', {'id': id});
    }
    final base = 0x40000000 + id * 64;
    final pending = await _plugin.pendingNotificationRequests();
    for (final item in pending.where((n) => n.id > base && n.id < base + 64)) {
      await _plugin.cancel(item.id);
    }
  }

  Future<void> scheduleRecurring(TaskModel task) async {
    if (!_supported || !_ready) return;
    if (defaultTargetPlatform == TargetPlatform.android) {
      await const MethodChannel(
        'remember_me/daily',
      ).invokeMethod<void>('scheduleRepeat', {
        'id': task.id,
        'title': task.title,
        'anchor': task.startAt.millisecondsSinceEpoch,
        'rule': task.recurrenceRule,
      });
      return;
    }
    final rule = ReminderRecurrence.decode(task.recurrenceRule);
    await cancelRecurring(task.id);
    final slots = rule.kind == RepeatKind.daily ? [1] : rule.days;
    for (final slot in slots) {
      final single = ReminderRecurrence(kind: rule.kind, days: [slot]);
      final next = single.nextAfter(DateTime.now(), task.startAt);
      if (next == null) continue;
      await _plugin.zonedSchedule(
        0x40000000 + task.id * 64 + slot,
        task.title,
        rule.label,
        tz.TZDateTime.from(next, tz.local),
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'remember_me_daily_reminders',
            'Reminders',
            importance: Importance.high,
            priority: Priority.high,
            actions: [
              AndroidNotificationAction(
                'mark_done',
                'Done',
                showsUserInterface: true,
                cancelNotification: true,
              ),
              AndroidNotificationAction(
                'snooze_10',
                'Snooze 10m',
                showsUserInterface: true,
                cancelNotification: true,
              ),
            ],
          ),
          iOS: DarwinNotificationDetails(),
        ),
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        androidScheduleMode: await _scheduleMode(),
        payload: task.id.toString(),
        matchDateTimeComponents: switch (rule.kind) {
          RepeatKind.daily => DateTimeComponents.time,
          RepeatKind.weekly => DateTimeComponents.dayOfWeekAndTime,
          RepeatKind.monthly => DateTimeComponents.dayOfMonthAndTime,
          RepeatKind.none => null,
        },
      );
    }
  }

  Future<void> setOccurrenceSkipped(
    int rootId,
    DateTime date,
    bool skipped,
  ) async {
    if (!_supported ||
        !_ready ||
        defaultTargetPlatform != TargetPlatform.android) {
      return;
    }
    final day =
        '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
    await const MethodChannel('remember_me/daily').invokeMethod<void>(
      'skipRepeat',
      {'id': rootId, 'day': day, 'value': skipped},
    );
    if (skipped) await cancelTaskReminder(rootId);
  }

  Future<void> scheduleTaskNudge(
    TaskModel task, {
    int offsetMinutes = 10,
  }) async {
    if (!_supported) return;
    if (offsetMinutes < 0) {
      await cancelTaskReminder(task.id);
      return;
    }

    final triggerAt = task.startAt.subtract(Duration(minutes: offsetMinutes));
    if (triggerAt.isBefore(DateTime.now())) {
      await cancelTaskReminder(task.id);
      return;
    }

    final notificationId = task.id.toInt();
    await _plugin.zonedSchedule(
      notificationId,
      task.title,
      'Starts at ${_label(task.startAt)}',
      tz.TZDateTime.from(triggerAt, tz.UTC),
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'remember_me_daily_reminders',
          'Reminders',
          channelDescription: 'Reminders at your chosen time',
          importance: Importance.high,
          priority: Priority.high,
          category: AndroidNotificationCategory.reminder,
          actions: [
            AndroidNotificationAction(
              'mark_done',
              'Mark Done',
              showsUserInterface: true,
              cancelNotification: true,
            ),
            AndroidNotificationAction(
              'snooze_10',
              'Snooze 10m',
              showsUserInterface: true,
              cancelNotification: true,
            ),
          ],
        ),
        iOS: DarwinNotificationDetails(),
      ),
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      androidScheduleMode: await _scheduleMode(),
      payload: task.id.toString(),
    );
  }

  Future<void> scheduleSnooze(TaskModel task, {int minutes = 5}) async {
    if (!_supported) return;
    final id = task.recurrenceRule == 'occurrence'
        ? task.templateId!
        : task.id.toInt();
    final time = DateTime.now().add(Duration(minutes: minutes));
    await _plugin.zonedSchedule(
      id,
      task.title,
      'Snoozed for $minutes minutes',
      tz.TZDateTime.from(time, tz.UTC),
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'remember_me_daily_reminders',
          'Reminders',
          channelDescription: 'Task reminders before start time',
          importance: Importance.high,
          priority: Priority.high,
          category: AndroidNotificationCategory.reminder,
          actions: [
            AndroidNotificationAction(
              'mark_done',
              'Mark Done',
              showsUserInterface: true,
              cancelNotification: true,
            ),
            AndroidNotificationAction(
              'snooze_10',
              'Snooze 10m',
              showsUserInterface: true,
              cancelNotification: true,
            ),
          ],
        ),
        iOS: DarwinNotificationDetails(),
      ),
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      androidScheduleMode: await _scheduleMode(),
      payload: task.recurrenceRule == 'occurrence'
          ? '$id|${task.startAt.toIso8601String()}'
          : id.toString(),
    );
  }

  Future<void> cancelTaskReminder(int taskId) async {
    if (!_supported) return;
    await _plugin.cancel(taskId);
    await _plugin.cancel(taskId + 900000);
  }

  Future<void> scheduleDailySummary({
    required int hour,
    required int minute,
    required String body,
  }) async {
    if (kIsWeb) return;
    final now = DateTime.now();
    var next = DateTime(now.year, now.month, now.day, hour, minute);
    if (!next.isAfter(now)) {
      next = next.add(const Duration(days: 1));
    }

    await _plugin.zonedSchedule(
      700001,
      'Daily summary',
      body,
      tz.TZDateTime.from(next, tz.local),
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'remember_me_summary',
          'Daily Summary',
          channelDescription: 'Daily productivity summaries',
          importance: Importance.defaultImportance,
          priority: Priority.defaultPriority,
        ),
        iOS: DarwinNotificationDetails(),
      ),
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  Future<void> cancelDailySummary() async {
    if (kIsWeb) return;
    await _plugin.cancel(700001);
  }

  Future<void> showOverdueNudge(TaskModel task) async {
    if (kIsWeb) return;
    await _plugin.show(
      task.id + 800000,
      'Task still pending',
      "Task '${task.title}' is still pending.",
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'remember_me_overdue',
          'Overdue Nudges',
          channelDescription: 'Gentle nudges for overdue tasks',
          importance: Importance.defaultImportance,
          priority: Priority.defaultPriority,
        ),
        iOS: DarwinNotificationDetails(),
      ),
    );
  }

  String _label(DateTime time) {
    final hour = time.hour == 0
        ? 12
        : (time.hour > 12 ? time.hour - 12 : time.hour);
    final minute = time.minute.toString().padLeft(2, '0');
    final suffix = time.hour >= 12 ? 'PM' : 'AM';
    return '$hour:$minute $suffix';
  }
}
