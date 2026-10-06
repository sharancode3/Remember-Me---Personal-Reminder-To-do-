import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/local/isar_service.dart';
import '../../services/backup_service.dart';
import '../../services/local_notification_service.dart';
import '../../core/notifications/reminder_scheduler.dart';
export 'daily_providers.dart';

final isarServiceProvider = Provider<IsarService>((ref) {
  throw UnimplementedError('Overridden during bootstrap');
});

final localNotificationServiceProvider = Provider<LocalNotificationService>((ref) {
  throw UnimplementedError('Overridden during bootstrap');
});

final reminderSchedulerProvider = Provider<ReminderScheduler>((ref) {
  throw UnimplementedError('Overridden during bootstrap');
});

final backupServiceProvider = Provider<BackupService>((ref) {
  final isar = ref.watch(isarServiceProvider);
  return BackupService(isar);
});
