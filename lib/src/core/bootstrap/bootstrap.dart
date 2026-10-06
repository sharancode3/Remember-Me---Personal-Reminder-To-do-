import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as zones;
import '../../services/daily_trail_service.dart';

import '../../data/local/isar_service.dart';
import '../../data/repositories/in_memory_planner_repository.dart';
import '../../services/local_notification_service.dart';
import '../../presentation/providers/providers.dart';

Future<ProviderContainer> bootstrap() async {
  tz.initializeTimeZones();
  if (!kIsWeb && defaultTargetPlatform == TargetPlatform.android) {
    try {
      final name = await DailyTrailService.channel.invokeMethod<String>(
        'timeZone',
      );
      if (name != null) zones.setLocalLocation(zones.getLocation(name));
    } catch (_) {
      /* Android alarms use the native zone; one-off alarms use UTC. */
    }
  }

  final notifications = LocalNotificationService();
  await notifications.initialize();

  if (kIsWeb) {
    return ProviderContainer(
      overrides: [
        localNotificationServiceProvider.overrideWithValue(notifications),
        plannerRepositoryProvider.overrideWithValue(
          InMemoryPlannerRepository(),
        ),
      ],
    );
  }

  final isar = await IsarService.open();
  return ProviderContainer(
    overrides: [
      isarServiceProvider.overrideWithValue(isar),
      localNotificationServiceProvider.overrideWithValue(notifications),
    ],
  );
}
