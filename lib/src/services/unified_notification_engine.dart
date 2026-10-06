import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import '../data/models/task_model.dart';
import 'context_engine.dart';
import 'observation_store.dart';

/// Categories of unified notifications
enum NotificationCategory {
  scheduledReminder,
  startReminder,
  leaveNow,
  focusProgress,
  journeyProgress,
  goalProgress,
  recoveryPrompt,
  contextAlert,
}

/// Unified Actionable Notification Payload
@immutable
class UnifiedNotificationPayload {
  const UnifiedNotificationPayload({
    required this.id,
    required this.title,
    required this.body,
    required this.category,
    required this.scheduledTime,
    this.suggestedActionTitle,
    this.taskId,
    this.payloadData = const {},
  });

  final int id;
  final String title;
  final String body;
  final NotificationCategory category;
  final DateTime scheduledTime;
  final String? suggestedActionTitle;
  final int? taskId;
  final Map<String, dynamic> payloadData;
}

/// Unified Notification Engine (Phase 10: Sections 54 & 55)
/// Coordinates all notification types, tracks user responses, and optimizes for action over spam.
class UnifiedNotificationEngine {
  UnifiedNotificationEngine({
    required ObservationStore observationStore,
  }) : _obsStore = observationStore;

  final ObservationStore _obsStore;
  final FlutterLocalNotificationsPlugin _plugin = FlutterLocalNotificationsPlugin();
  final StreamController<UnifiedNotificationPayload> _actionedStream = StreamController.broadcast();

  Stream<UnifiedNotificationPayload> get onNotificationActioned => _actionedStream.stream;

  Future<void> initialize() async {
    if (kIsWeb) return;

    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    const ios = DarwinInitializationSettings();
    await _plugin.initialize(
      const InitializationSettings(android: android, iOS: ios),
      onDidReceiveNotificationResponse: (response) {
        final id = response.id;
        if (id == null) return;
        // Record observation that user acted on notification
        _obsStore.record(
          BehavioralObservation(
            id: 'obs_notif_act_${id}_${DateTime.now().millisecondsSinceEpoch}',
            type: ObservationType.taskStarted,
            timestamp: DateTime.now(),
            taskId: id,
            reason: 'User triggered action via notification response',
          ),
        );
      },
    );
  }

  /// Schedules an actionable task start reminder with learned lead-time
  Future<void> scheduleActionableReminder(
    TaskModel task, {
    int leadMinutes = 10,
    String? reason,
  }) async {
    if (kIsWeb) return;

    final triggerTime = task.startAt.subtract(Duration(minutes: leadMinutes));
    if (triggerTime.isBefore(DateTime.now())) return;

    final notificationBody = reason != null
        ? '${task.title} starting in ${leadMinutes}m. ($reason)'
        : '${task.title} starting in ${leadMinutes}m.';

    await _plugin.zonedSchedule(
      task.id,
      'REMEMBER ME',
      notificationBody,
      tz.TZDateTime.from(triggerTime, tz.local),
      NotificationDetails(
        android: AndroidNotificationDetails(
          'remember_me_actionable',
          'Actionable Reminders',
          channelDescription: 'Intelligent, actionable task start reminders',
          importance: Importance.high,
          priority: Priority.high,
          styleInformation: BigTextStyleInformation(notificationBody),
        ),
        iOS: const DarwinNotificationDetails(),
      ),
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    );
  }

  /// Sends immediate Context / Opportunity Alert (e.g. Near store, Step Goal, Rain coming)
  Future<void> showContextOpportunityAlert(PlanningSignal signal) async {
    if (kIsWeb) return;

    await _plugin.show(
      signal.type.index + 900000,
      signal.title,
      signal.description,
      NotificationDetails(
        android: AndroidNotificationDetails(
          'remember_me_context',
          'Planning & Opportunity Alerts',
          channelDescription: 'Contextual schedule opportunities',
          importance: Importance.defaultImportance,
          priority: Priority.defaultPriority,
          styleInformation: BigTextStyleInformation(signal.description),
        ),
        iOS: const DarwinNotificationDetails(),
      ),
    );
  }

  /// Sends Leave-Now Alert with learned travel delay buffer
  Future<void> showLeaveNowAlert({
    required String destination,
    required int estimatedTravelMinutes,
    required int bufferMinutes,
  }) async {
    if (kIsWeb) return;

    final totalLead = estimatedTravelMinutes + bufferMinutes;
    await _plugin.show(
      999001,
      'LEAVE NOW FOR $destination',
      'Travel takes ~$estimatedTravelMinutes min + ${bufferMinutes}m buffer. Leave now to arrive on time.',
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'remember_me_leave_now',
          'Leave Now Alerts',
          channelDescription: 'Proactive departure alerts',
          importance: Importance.high,
          priority: Priority.high,
        ),
        iOS: DarwinNotificationDetails(),
      ),
    );
  }

  Future<void> cancel(int id) async {
    if (kIsWeb) return;
    await _plugin.cancel(id);
  }
}
