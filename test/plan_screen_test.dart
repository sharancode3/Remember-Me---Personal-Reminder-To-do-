import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:remember_me/src/core/theme/neo_colors.dart';
import 'package:remember_me/src/data/models/task_model.dart';
import 'package:remember_me/src/domain/repositories/planner_repository.dart';
import 'package:remember_me/src/presentation/providers/providers.dart';
import 'package:remember_me/src/presentation/screens/plan_screen.dart';

class _FakePlanRepo implements PlannerRepository {
  @override
  Stream<List<TaskModel>> watchTasksForDay(DateTime day) {
    return Stream.value([]);
  }

  @override
  Future<Map<DateTime, double>> getWeekDayCompletion(DateTime anchor) async {
    return {};
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  testWidgets('PlanScreen renders DAY, WEEK, MONTH lenses and routine inserts', (tester) async {
    final fakeRepo = _FakePlanRepo();

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
            body: PlanScreen(),
          ),
        ),
      ),
    );

    await tester.pump();

    // Verify Lens Segments
    expect(find.text('DAY'), findsOneWidget);
    expect(find.text('WEEK'), findsOneWidget);
    expect(find.text('MONTH'), findsOneWidget);

    // Verify Routine Inserts
    expect(find.text('MORNING RITUAL'), findsOneWidget);
    expect(find.text('DEEP WORK SPRINT'), findsOneWidget);
    expect(find.text('WORKOUT & GYM'), findsOneWidget);

    // Switch to WEEK lens
    await tester.tap(find.text('WEEK'));
    await tester.pump();

    // Switch to MONTH lens
    await tester.tap(find.text('MONTH'));
    await tester.pump();
  });

  testWidgets('PlanScreen renders without overflow on narrow 360x800 Android viewport', (tester) async {
    final fakeRepo = _FakePlanRepo();

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
            body: PlanScreen(),
          ),
        ),
      ),
    );

    await tester.pump();
    expect(tester.takeException(), isNull);
    expect(find.text('DAY'), findsOneWidget);

    await tester.tap(find.text('WEEK'));
    await tester.pump();
    expect(tester.takeException(), isNull);

    await tester.tap(find.text('MONTH'));
    await tester.pump();
    expect(tester.takeException(), isNull);
  });
}
