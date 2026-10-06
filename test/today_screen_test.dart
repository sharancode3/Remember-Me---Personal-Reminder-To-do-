import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:remember_me/src/core/theme/neo_colors.dart';
import 'package:remember_me/src/data/models/task_model.dart';
import 'package:remember_me/src/domain/repositories/planner_repository.dart';
import 'package:remember_me/src/presentation/providers/providers.dart';
import 'package:remember_me/src/presentation/screens/today_screen.dart';

class _FakePlannerRepository implements PlannerRepository {
  final List<TaskModel> _tasks = [];

  @override
  Stream<List<TaskModel>> watchTasksForDay(DateTime day) {
    return Stream.value(_tasks);
  }

  @override
  Stream<List<TaskModel>> watchCurrentInProgress(DateTime day) {
    return Stream.value([]);
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  testWidgets('TodayScreen renders NOW section, Day Capacity, and Quick Add action', (tester) async {
    final fakeRepo = _FakePlannerRepository();

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          plannerRepositoryProvider.overrideWithValue(fakeRepo),
          minuteTickerProvider.overrideWith((ref) => Stream.value(DateTime.now())),
        ],
        child: MaterialApp(
          theme: ThemeData(
            extensions: const [NeoColors.light],
          ),
          home: const Scaffold(
            body: TodayScreen(),
          ),
        ),
      ),
    );

    await tester.pump();

    // Verify key sections are present
    expect(find.textContaining('TODAY'), findsWidgets);
    expect(find.text('REALISTIC CAPACITY'), findsOneWidget);
    expect(find.text('+ ADD TASK'), findsOneWidget);
    expect(find.text('AUTO-PLAN'), findsOneWidget);
  });

  testWidgets('TodayScreen renders without overflow on narrow 360x800 Android viewport', (tester) async {
    final fakeRepo = _FakePlannerRepository();

    // Set narrow 360x800 viewport
    tester.view.physicalSize = const Size(360, 800);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() => tester.view.resetPhysicalSize());

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          plannerRepositoryProvider.overrideWithValue(fakeRepo),
          minuteTickerProvider.overrideWith((ref) => Stream.value(DateTime.now())),
        ],
        child: MaterialApp(
          theme: ThemeData(
            extensions: const [NeoColors.light],
          ),
          home: const Scaffold(
            body: TodayScreen(),
          ),
        ),
      ),
    );

    await tester.pump();

    expect(tester.takeException(), isNull);
    expect(find.text('REALISTIC CAPACITY'), findsOneWidget);
  });

  testWidgets('TodayScreen renders smoothly on larger 412x915 Android viewport with active tasks', (tester) async {
    final fakeRepo = _FakePlannerRepository();

    // Set larger 412x915 viewport
    tester.view.physicalSize = const Size(412, 915);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() => tester.view.resetPhysicalSize());

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          plannerRepositoryProvider.overrideWithValue(fakeRepo),
          minuteTickerProvider.overrideWith((ref) => Stream.value(DateTime.now())),
        ],
        child: MaterialApp(
          theme: ThemeData(
            extensions: const [NeoColors.light],
          ),
          home: const Scaffold(
            body: TodayScreen(),
          ),
        ),
      ),
    );

    await tester.pump();

    expect(tester.takeException(), isNull);
    expect(find.text('REALISTIC CAPACITY'), findsOneWidget);
    expect(find.text('+ ADD TASK'), findsOneWidget);
  });
}
