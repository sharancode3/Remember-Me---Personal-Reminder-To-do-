import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:remember_me/src/core/theme/daily_theme.dart';
import 'package:remember_me/src/services/reminder_recurrence.dart';
import 'package:remember_me/src/data/models/task_model.dart';
import 'package:remember_me/src/data/repositories/daily_repository.dart';
import 'package:remember_me/src/presentation/providers/providers.dart';
import 'package:remember_me/src/presentation/screens/daily_home_screen.dart';
import 'package:remember_me/src/services/daily_trail_service.dart';
import 'package:remember_me/src/services/local_notification_service.dart';
import 'package:remember_me/src/core/notifications/reminder_scheduler.dart';

class _Notifications extends LocalNotificationService {
  final scheduled = <int, DateTime>{};
  @override
  Future<void> requestPermissions({bool precise = true}) async {}
  @override
  Future<void> scheduleTaskNudge(
    TaskModel task, {
    int offsetMinutes = 10,
  }) async {
    scheduled[task.id] = task.startAt.subtract(
      Duration(minutes: offsetMinutes),
    );
  }

  @override
  Future<void> cancelTaskReminder(int taskId) async {
    scheduled.remove(taskId);
  }
}

TaskModel _task(
  DateTime time, {
  String title = 'Call home',
  bool reminder = true,
}) => TaskModel()
  ..title = title
  ..startAt = time
  ..endAt = time.add(const Duration(minutes: 1))
  ..reminderOffsetMinutes = reminder ? 0 : -1;

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late _Notifications notifications;
  late DailyRepository repository;
  late List<String> nativeActions;
  late List<String> allowedApps;
  String? savedPlaces;
  setUp(() {
    nativeActions = [];
    allowedApps = [];
    savedPlaces = null;
    notifications = _Notifications();
    repository = DailyRepository(
      null,
      InMemoryReminderScheduler(),
      notifications,
    );
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(DailyTrailService.channel, (call) async {
          nativeActions.add(call.method);
          switch (call.method) {
            case 'consumeNavigation':
            case 'consumeRepeatAction':
              return null;
            case 'readTheme':
              return 'mint';
            case 'googleConfigured':
              return false;
            case 'getPlaces':
              return '[]';
            case 'focusGuardEnabled':
              return true;
            case 'installedApps':
              return [
                {'name': 'Podcasts', 'package': 'test.podcasts'},
                {'name': 'Social', 'package': 'test.social'},
              ];
            case 'allowedApps':
              return allowedApps;
            case 'saveAllowedApps':
              allowedApps = (call.arguments['packages'] as List).cast<String>();
              return null;
            case 'savePlaces':
              savedPlaces = call.arguments['data'] as String;
              return null;
            case 'trackingEnabled':
              return false;
            case 'readTrail':
              return '[]';
            case 'focusMinutes':
              return 0;
            default:
              return <String, dynamic>{};
          }
        });
  });
  tearDown(() {
    repository.dispose();
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(DailyTrailService.channel, null);
  });

  test(
    'Reminder keeps chosen time even at night and overlapping another',
    () async {
      final time = DateTime(2030, 1, 1, 2, 30);
      final first = _task(time);
      final second = _task(time, title: 'Drink water');
      await repository.save(first);
      await repository.save(second);
      expect(first.startAt, time);
      expect(second.startAt, time);
      expect(notifications.scheduled.values.toList(), [time, time]);
      expect(first.id, isNot(second.id));
    },
  );

  test(
    'Complete cancels reminder; reopen reschedules; delete hides task',
    () async {
      final task = _task(DateTime(2030, 1, 1, 15));
      await repository.save(task);
      await repository.toggle(task);
      expect(task.status, TaskStatus.completed);
      expect(notifications.scheduled, isEmpty);
      await repository.toggle(task);
      expect(task.status, TaskStatus.pending);
      expect(notifications.scheduled[task.id], task.startAt);
      await repository.remove(task);
      expect(await repository.watchDay(task.startAt).first, isEmpty);
      expect(notifications.scheduled, isEmpty);
    },
  );

  test('Day boundaries keep past tasks on their original day', () async {
    final before = _task(DateTime(2026, 10, 1, 23, 59), reminder: false);
    final after = _task(DateTime(2026, 10, 2), reminder: false);
    await repository.save(before);
    await repository.save(after);
    expect(await repository.watchDay(before.startAt).first, [before]);
    expect(await repository.watchDay(after.startAt).first, [after]);
    expect(notifications.scheduled, isEmpty);
    expect(before.status, TaskStatus.pending);
  });

  test('Focus crossing midnight is split between days', () async {
    await repository.recordFocus(
      DateTime(2026, 10, 1, 23, 50),
      DateTime(2026, 10, 2, 0, 20),
      false,
    );
    expect(await repository.focusMinutes(DateTime(2026, 10, 1)), 10);
    expect(await repository.focusMinutes(DateTime(2026, 10, 2)), 20);
    expect(await repository.focusMinutes(DateTime(2026, 10, 3)), 0);
  });

  Future<void> render(
    WidgetTester tester, {
    Size size = const Size(360, 800),
  }) async {
    tester.view.physicalSize = size;
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          dailyRepositoryProvider.overrideWithValue(repository),
          localNotificationServiceProvider.overrideWithValue(notifications),
        ],
        child: Consumer(
          builder: (context, ref, _) => MaterialApp(
            theme: DailyTheme.build(ref.watch(dailyStyleProvider)),
            home: const DailyHomeScreen(),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('Create a daily to-do and complete it at 360px', (tester) async {
    await render(tester);
    await tester.tap(find.byTooltip('Add reminder or to-do'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('To-do').last);
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField).first, 'Buy milk');
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();
    expect(find.text('Buy milk'), findsOneWidget);
    await tester.tap(find.byType(Checkbox));
    await tester.pumpAndSettle();
    expect(find.text('1 / 1'), findsOneWidget);
    expect(tester.takeException(), isNull);
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('Calendar shows selected day and history without overflow', (
    tester,
  ) async {
    await render(tester, size: const Size(320, 740));
    await tester.tap(find.text('Calendar').last);
    await tester.pumpAndSettle();
    expect(find.text('Calendar'), findsNWidgets(2));
    expect(find.byTooltip('Previous month'), findsOneWidget);
    expect(tester.takeException(), isNull);
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('Focus hides navigation until emergency exit saves session', (
    tester,
  ) async {
    await render(tester);
    await tester.tap(find.text('Focus').last);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Start focus'));
    await tester.pump(const Duration(milliseconds: 200));
    expect(find.byType(NavigationBar), findsNothing);
    expect(find.text('One thing at a time.'), findsOneWidget);
    await tester.tap(find.text('End session'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('End session').last);
    await tester.pumpAndSettle();
    expect(find.byType(NavigationBar), findsOneWidget);
    expect(tester.takeException(), isNull);
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('Trail has honest empty state and no fabricated location', (
    tester,
  ) async {
    await render(tester, size: const Size(412, 915));
    await tester.tap(find.text('Trail'));
    await tester.pumpAndSettle();
    expect(find.text('No trail for this day'), findsOneWidget);
    expect(find.text('0.00'), findsOneWidget);
    expect(find.byTooltip('Start daily recording'), findsOneWidget);
    expect(tester.takeException(), isNull);
    await tester.pumpWidget(const SizedBox());
  });
  testWidgets('Weekly to-do can be created using selected days', (
    tester,
  ) async {
    await render(tester);
    await tester.tap(find.byTooltip('Add reminder or to-do'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('To-do').last);
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField).first, 'Weekly laundry');
    await tester.ensureVisible(
      find.byType(DropdownButtonFormField<RepeatKind>),
    );
    await tester.tap(find.byType(DropdownButtonFormField<RepeatKind>));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Days of the week').last);
    await tester.pumpAndSettle();
    expect(find.byType(FilterChip), findsNWidgets(7));
    await tester.ensureVisible(find.text('Save'));
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();
    final task = (await repository.watchDay(DateTime.now()).first).single;
    expect(task.recurrenceRule, 'occurrence');
    expect(find.text('Repeating'), findsOneWidget);
    expect(tester.takeException(), isNull);
    await tester.pumpWidget(const SizedBox());
  });
  testWidgets('Focus allowlist is saved before blocking starts', (
    tester,
  ) async {
    await render(tester);
    await tester.tap(find.text('Focus').last);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Block distracting apps'));
    await tester.pumpAndSettle();
    await tester.scrollUntilVisible(find.text('Allowed apps'), 100);
    await tester.drag(find.byType(ListView).last, const Offset(0, -150));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Allowed apps'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Podcasts'));
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();
    expect(allowedApps, ['test.podcasts']);
    await tester.tap(find.text('Start focus'));
    await tester.pump(const Duration(milliseconds: 200));
    expect(nativeActions, contains('startFocus'));
    expect(find.byType(NavigationBar), findsNothing);
    await tester.tap(find.text('End session'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('End session').last);
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
    await tester.pumpWidget(const SizedBox());
  });
  testWidgets(
    'Saved place can carry an arrival reminder without silent recording',
    (tester) async {
      await render(tester);
      await tester.tap(find.text('Trail'));
      await tester.pumpAndSettle();
      await tester.tap(find.byTooltip('Pin map center'));
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextField).first, 'Home');
      await tester.tap(find.text('Notify on arrival'));
      await tester.pumpAndSettle();
      expect(
        find.text('Arrival alerts are paused while daily recording is off.'),
        findsOneWidget,
      );
      await tester.enterText(find.byType(TextField).last, 'Pick up keys');
      await tester.ensureVisible(find.text('Save place'));
      await tester.tap(find.text('Save place'));
      await tester.pumpAndSettle();
      expect(savedPlaces, contains('Pick up keys'));
      expect(nativeActions, isNot(contains('startTracking')));
      await tester.tap(find.byTooltip('Saved places'));
      await tester.pumpAndSettle();
      expect(find.text('Home'), findsOneWidget);
      expect(tester.takeException(), isNull);
      await tester.pumpWidget(const SizedBox());
    },
  );
  testWidgets('Theme swatches switch appearance', (tester) async {
    await render(tester);
    await tester.tap(find.byTooltip('Settings'));
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('rose theme'));
    await tester.pumpAndSettle();
    final context = tester.element(find.text('Settings'));
    expect(
      Theme.of(context).colorScheme.primary,
      DailyTheme.accent(DailyStyle.rose),
    );
    expect(nativeActions, contains('writeTheme'));
    expect(tester.takeException(), isNull);
    await tester.pumpWidget(const SizedBox());
  });
}
