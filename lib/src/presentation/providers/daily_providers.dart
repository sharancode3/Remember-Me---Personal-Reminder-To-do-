import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/platform/native_daily_bridge.dart';
import '../../data/models/task_model.dart';
import '../../data/repositories/daily_repository.dart';
import '../../services/daily_trail_service.dart';
import 'providers.dart';

export '../../data/repositories/daily_repository.dart'
    show dayOnly, formatDateKey, EditRecurrenceScope;

final nativeDailyBridgeProvider = Provider<NativeDailyBridge>((ref) {
  return NativeDailyBridge.instance;
});

final dailyRepositoryProvider = Provider<DailyRepository>((ref) {
  final repository = DailyRepository(
    kIsWeb ? null : ref.watch(isarServiceProvider),
    ref.watch(reminderSchedulerProvider),
    ref.watch(localNotificationServiceProvider),
    ref.watch(nativeDailyBridgeProvider),
  );
  ref.onDispose(repository.dispose);
  return repository;
});

final dailyTrailProvider = ChangeNotifierProvider<DailyTrailService>(
  (ref) => DailyTrailService(),
);

final dailyDateProvider = StateProvider<DateTime>(
  (ref) => dayOnly(DateTime.now()),
);

final dailyTasksProvider = StreamProvider<List<TaskModel>>(
  (ref) =>
      ref.watch(dailyRepositoryProvider).watchDay(ref.watch(dailyDateProvider)),
);

final dailyMonthProvider = StateProvider<DateTime>(
  (ref) => DateTime(DateTime.now().year, DateTime.now().month),
);

final dailyCountsProvider = FutureProvider<Map<DateTime, int>>((ref) {
  ref.watch(dailyTasksProvider);
  return ref
      .watch(dailyRepositoryProvider)
      .monthCounts(ref.watch(dailyMonthProvider));
});

final dailyFocusMinutesProvider = FutureProvider<int>((ref) async {
  final day = ref.watch(dailyDateProvider);
  final repository = ref.watch(dailyRepositoryProvider);
  if (!kIsWeb && defaultTargetPlatform == TargetPlatform.android) {
    final bridge = ref.watch(nativeDailyBridgeProvider);
    final nativeMinutes = await bridge.focusMinutes(
      start: day.millisecondsSinceEpoch,
      end: DateTime(day.year, day.month, day.day + 1).millisecondsSinceEpoch,
    );
    return nativeMinutes + await repository.focusMinutes(day);
  }
  return repository.focusMinutes(day);
});
