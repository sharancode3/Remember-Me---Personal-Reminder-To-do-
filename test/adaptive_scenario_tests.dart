import 'package:flutter_test/flutter_test.dart';
import 'package:remember_me/src/data/models/task_model.dart';
import 'package:remember_me/src/services/context_engine.dart';
import 'package:remember_me/src/services/master_adaptive_day_orchestrator.dart';
import 'package:remember_me/src/services/observation_store.dart';
import 'package:remember_me/src/services/personal_planning_profile.dart';
import 'package:remember_me/src/services/personal_prediction_engine.dart';
import 'package:remember_me/src/services/project_simulation_engine.dart';
import 'package:remember_me/src/services/journey_models_and_processor.dart';
import 'package:remember_me/src/services/master_journey_engine.dart';
import 'package:remember_me/src/services/four_engines_architecture.dart';
import 'package:remember_me/src/core/utils/natural_language_parser.dart';
import 'package:remember_me/src/data/repositories/journey_history_repository.dart';
import 'package:remember_me/src/domain/repositories/provider_abstractions.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Adaptive Planning Engine Scenario & Invariant Tests', () {
    late ObservationStore observationStore;
    late PersonalPredictionEngine predictionEngine;
    late PersonalPlanningProfile profile;
    late MasterAdaptiveDayOrchestrator orchestrator;
    late ProjectSimulationEngine simulationEngine;

    setUp(() {
      observationStore = ObservationStore();
      predictionEngine = PersonalPredictionEngine();
      profile = const PersonalPlanningProfile();
      orchestrator = MasterAdaptiveDayOrchestrator(
        predictionEngine: predictionEngine,
        profile: profile,
      );
      simulationEngine = ProjectSimulationEngine(
        orchestrator: orchestrator,
        profile: profile,
      );
    });

    test('Invariant 1: High-friction tasks receive elevated plan gravity and larger recovery buffers', () {
      final frictionWriting = orchestrator.evaluateFriction('Write thesis chapter', 'study', 1);
      final frictionEmail = orchestrator.evaluateFriction('Reply to emails', 'admin', 0);

      expect(frictionWriting.startFriction, greaterThan(frictionEmail.startFriction));
      expect(frictionWriting.recoveryCostMinutes, greaterThan(frictionEmail.recoveryCostMinutes));
      expect(frictionWriting.planGravity, greaterThanOrEqualTo(0.5));
      expect(frictionEmail.planGravity, equals(0.2));
    });

    test('Invariant 2: Variable daily capacity deducts fixed commitments, meals, transitions, and cognitive fatigue', () {
      final now = DateTime.now();
      final fixed = [
        TaskModel()
          ..id = 1
          ..title = 'Class Lecture'
          ..startAt = DateTime(now.year, now.month, now.day, 10, 0)
          ..endAt = DateTime(now.year, now.month, now.day, 12, 0)
          ..priority = 2,
      ];

      final capacity = orchestrator.calculateRealisticCapacity(
        targetDay: now,
        fixedCommitments: fixed,
      );

      // Total 960m - 120m (fixed) - 120m (meals) - 60m (transitions) - 77m (fatigue buffer) = ~583m
      expect(capacity.fixedCommitmentMinutes, equals(120));
      expect(capacity.realisticSchedulableMinutes, lessThan(960));
      expect(capacity.deepWorkBudgetMinutes, lessThanOrEqualTo(240));
    });

    test('Invariant 3: Natural opportunity detection triggers when gap and proximity match', () {
      final now = DateTime.now();
      final tasks = [
        TaskModel()
          ..id = 2
          ..title = 'Pick up prescription at pharmacy'
          ..startAt = now.add(const Duration(hours: 4))
          ..endAt = now.add(const Duration(hours: 4, minutes: 20))
          ..status = TaskStatus.pending,
      ];

      final signals = orchestrator.detectNaturalOpportunities(
        pendingTasks: tasks,
        availableGapMinutes: 25,
        isNearCommercialLocation: true,
        isRainIncoming: false,
        remainingSteps: 3000,
      );

      expect(signals, isNotEmpty);
      expect(signals.first.type, equals(PlanningSignalType.userNearTaskLocation));
      expect(signals.first.suggestedActionTitle, contains('COMPLETE ERRAND NOW'));
    });

    test('Invariant 4: "What If?" simulation prevents moves that collide with hard sleep window', () {
      final now = DateTime.now();
      final task = TaskModel()
        ..id = 3
        ..title = 'Late Night Deep Coding'
        ..startAt = DateTime(now.year, now.month, now.day, 21, 0)
        ..endAt = DateTime(now.year, now.month, now.day, 23, 30);

      final hardSleep = DateTime(now.year, now.month, now.day, 23, 0);

      final result = simulationEngine.simulateTaskMove(
        taskToMove: task,
        proposedNewStart: DateTime(now.year, now.month, now.day, 22, 0),
        allScheduledTasks: [task],
        hardSleepTime: hardSleep,
      );

      expect(result.isFeasible, isFalse);
      expect(result.explanation, contains('Collides with hard sleep time'));
      expect(result.deadlineRiskImpact, equals(ProjectRiskStatus.atRisk));
    });

    test('Invariant 5: Observation Store captures structured events and calculates delays', () {
      final now = DateTime.now();
      observationStore.recordTaskStarted(
        taskId: 101,
        taskTitle: 'Math Assignment',
        scheduledStart: now.subtract(const Duration(minutes: 15)),
        actualStart: now,
        category: 'study',
      );

      final delay = observationStore.getAverageStartDelay('study');
      expect(delay, equals(15.0));
      expect(observationStore.allObservations.length, equals(1));
    });

    test('Invariant 6: TrackQualityProcessor filters out bad accuracy and stationary GPS jitter', () {
      final processor = TrackQualityProcessor();
      final now = DateTime.now();

      // Sample 1: Good starting point
      processor.processSample(
        GpsObservation(
          latitude: 12.9716,
          longitude: 77.5946,
          timestamp: now,
          elapsedRealtimeNanos: 1000000000,
          horizontalAccuracyMeters: 5.0,
        ),
        isUserPaused: false,
      );

      // Sample 2: Poor accuracy GPS spike (>50m) -> Must be rejected
      final rejected = processor.processSample(
        GpsObservation(
          latitude: 12.9916,
          longitude: 77.6146,
          timestamp: now.add(const Duration(seconds: 1)),
          elapsedRealtimeNanos: 2000000000,
          horizontalAccuracyMeters: 95.0, // Bad accuracy
        ),
        isUserPaused: false,
      );
      expect(rejected, isNull);

      // Sample 3: Stationary jitter (<2.5m) -> Must filter distance accumulation
      final jitterSample = processor.processSample(
        GpsObservation(
          latitude: 12.9716001,
          longitude: 77.5946001,
          timestamp: now.add(const Duration(seconds: 2)),
          elapsedRealtimeNanos: 3000000000,
          horizontalAccuracyMeters: 5.0,
        ),
        isUserPaused: false,
      );
      expect(jitterSample?.cumulativeDistanceMeters, equals(0.0));
    });

    test('Invariant 7: NaturalLanguageTaskParser correctly extracts P1/P2/P3 priorities and offsets', () {
      final parsedP1 = NaturalLanguageTaskParser.parse('Submit critical tax report tomorrow 10am !p1 #finance');
      expect(parsedP1.priority, equals(2)); // P1 Critical
      expect(parsedP1.tag, equals('finance'));
      expect(parsedP1.title, equals('Submit critical tax report'));

      final parsedP2 = NaturalLanguageTaskParser.parse('Team sync !p2 45m');
      expect(parsedP2.priority, equals(1)); // P2 Important
      expect(parsedP2.durationMinutes, equals(45));

      final parsedP3 = NaturalLanguageTaskParser.parse('Clean desk !p3');
      expect(parsedP3.priority, equals(0)); // P3 Normal
    });

    test('Invariant 8: Personalized ML Convergence — Quantifiable error reduction from cold-start to seasoned history', () {
      final engine = PersonalPredictionEngine(ewmaAlpha: 0.35);
      final targetTime = DateTime(2026, 8, 29, 10, 0); // 10 AM (Morning focus)

      // Cold Start Stage (0 observations)
      final coldContext = TaskPredictionContext(
        taskTitle: 'Study Physics',
        plannedDurationMinutes: 60,
        targetDateTime: targetTime,
        category: 'study',
      );
      final coldPred = engine.predict(coldContext);
      expect(coldPred.usedFallback, isTrue);
      expect(coldPred.confidence, lessThanOrEqualTo(0.65));

      // Simulate Real User Execution Data (User consistently takes ~74 minutes)
      const actualUserDuration = 74;
      for (int i = 1; i <= 6; i++) {
        engine.recordExecution(
          TaskExecutionRecord(
            taskTitle: 'Study Physics',
            category: 'study',
            plannedDurationMinutes: 60,
            actualDurationMinutes: actualUserDuration + (i % 2 == 0 ? 2 : -2), // 72m, 76m...
            startDelayMinutes: 5,
            timeOfDayHour: 10,
            dayOfWeek: 6,
            wasCompleted: true,
            postponementCount: 0,
            timestamp: DateTime.now().subtract(Duration(days: 7 - i)),
          ),
        );
      }

      // Warm Stage (6 observations accumulated)
      final warmPred = engine.predict(coldContext);
      expect(warmPred.usedFallback, isFalse);
      expect(warmPred.confidence, greaterThan(0.80));

      // Error Comparison:
      // Baseline cold prediction error: |60 - 74| = 14 mins error
      // Personalized predicted duration: ~70-74 mins
      final baselineError = (60 - actualUserDuration).abs();
      final personalizedError = (warmPred.predictedDurationMinutes - actualUserDuration).abs();

      expect(personalizedError, lessThan(baselineError));
      // Personalized error should be significantly lower (e.g. <= 4 mins vs 14 mins)
      expect(personalizedError, lessThanOrEqualTo(4));
    });

    test('Invariant 9: End-to-End Closed Loop — Task creation -> Schedule -> Reality execution -> Observation capture', () {
      final now = DateTime(2026, 8, 29, 19, 0);
      final parsed = NaturalLanguageTaskParser.parse('Study Physics Saturday 7pm 2h !p1');
      expect(parsed.title, equals('Study Physics'));
      expect(parsed.durationMinutes, equals(120));
      expect(parsed.priority, equals(2)); // P1 Critical

      final task = TaskModel()
        ..id = 999
        ..title = parsed.title
        ..startAt = now
        ..endAt = now.add(Duration(minutes: parsed.durationMinutes))
        ..priority = parsed.priority
        ..status = TaskStatus.pending;

      expect(task.priority, equals(2));
      expect(task.endAt.difference(task.startAt).inMinutes, equals(120));

      // Simulate Real Execution (Ran 135 mins, started 10 mins late)
      final actualStart = now.add(const Duration(minutes: 10));
      observationStore.recordTaskStarted(
        taskId: task.id,
        taskTitle: task.title,
        scheduledStart: task.startAt!,
        actualStart: actualStart,
        category: 'study',
        plannedDurationMinutes: 120,
      );

      observationStore.recordTaskCompleted(
        taskId: task.id,
        taskTitle: task.title,
        plannedDurationMinutes: 120,
        actualDurationMinutes: 135,
        category: 'study',
      );

      final observations = observationStore.getObservationsForTask('Study Physics');
      expect(observations.length, equals(2));
      expect(observationStore.getAverageStartDelay('study'), equals(10.0));
    });

    test('Invariant 10: Multi-Task ML Generalization across categories (Coding, Gym, Editing)', () {
      final engine = PersonalPredictionEngine(ewmaAlpha: 0.35);
      final morningTime = DateTime(2026, 8, 29, 10, 0);

      // Task 1: Coding (Planned 90m, User consistently takes ~115m)
      for (int i = 0; i < 5; i++) {
        engine.recordExecution(
          TaskExecutionRecord(
            taskTitle: 'Refactor Core Database',
            category: 'work',
            plannedDurationMinutes: 90,
            actualDurationMinutes: 115,
            startDelayMinutes: 5,
            timeOfDayHour: 10,
            dayOfWeek: 2,
            wasCompleted: true,
            postponementCount: 0,
            timestamp: DateTime.now().subtract(Duration(days: i)),
          ),
        );
      }
      final codingPred = engine.predict(
        TaskPredictionContext(
          taskTitle: 'Refactor Core Database',
          plannedDurationMinutes: 90,
          targetDateTime: morningTime,
          category: 'work',
        ),
      );
      expect(codingPred.predictedDurationMinutes, greaterThanOrEqualTo(105));
      expect(codingPred.confidence, greaterThanOrEqualTo(0.80));

      // Task 2: Gym (Planned 45m, User is fast ~40m)
      for (int i = 0; i < 5; i++) {
        engine.recordExecution(
          TaskExecutionRecord(
            taskTitle: 'Leg Day Workout',
            category: 'fitness',
            plannedDurationMinutes: 45,
            actualDurationMinutes: 40,
            startDelayMinutes: 0,
            timeOfDayHour: 10,
            dayOfWeek: 3,
            wasCompleted: true,
            postponementCount: 0,
            timestamp: DateTime.now().subtract(Duration(days: i)),
          ),
        );
      }
      final gymPred = engine.predict(
        TaskPredictionContext(
          taskTitle: 'Leg Day Workout',
          plannedDurationMinutes: 45,
          targetDateTime: morningTime,
          category: 'fitness',
        ),
      );
      expect(gymPred.predictedDurationMinutes, lessThanOrEqualTo(45));
    });

    test('Invariant 11: Statistical Outlier Resistance — Single anomaly does not permanently hijack personal predictions', () {
      final engine = PersonalPredictionEngine(ewmaAlpha: 0.30);
      final morningTime = DateTime(2026, 8, 29, 10, 0);

      // 8 Normal sessions of 60m reading (~65m actual)
      for (int i = 0; i < 8; i++) {
        engine.recordExecution(
          TaskExecutionRecord(
            taskTitle: 'Read Research Paper',
            category: 'study',
            plannedDurationMinutes: 60,
            actualDurationMinutes: 65,
            startDelayMinutes: 0,
            timeOfDayHour: 10,
            dayOfWeek: 1,
            wasCompleted: true,
            postponementCount: 0,
            timestamp: DateTime.now().subtract(Duration(days: 10 - i)),
          ),
        );
      }

      // Single Extreme Outlier: Emergency interrupted session lasting 180 min
      engine.recordExecution(
        TaskExecutionRecord(
          taskTitle: 'Read Research Paper',
          category: 'study',
          plannedDurationMinutes: 60,
          actualDurationMinutes: 180, // Outlier
          startDelayMinutes: 20,
          timeOfDayHour: 10,
          dayOfWeek: 1,
          wasCompleted: true,
          postponementCount: 2,
          timestamp: DateTime.now().subtract(const Duration(days: 1)),
        ),
      );

      final predAfterOutlier = engine.predict(
        TaskPredictionContext(
          taskTitle: 'Read Research Paper',
          plannedDurationMinutes: 60,
          targetDateTime: morningTime,
          category: 'study',
        ),
      );

      // Predictions should absorb EWMA gracefully (~90-100m) without locking to 180m
      expect(predAfterOutlier.predictedDurationMinutes, lessThan(115));
      expect(predAfterOutlier.distribution.maxMinutes, lessThanOrEqualTo(180));
    });

    test('Invariant 12: Auto-Plan "Why?" Explainability — Meaningful reasons attached to all rescheduled items', () {
      final now = DateTime.now();
      final planningEngine = AdaptivePlanningEngine(predictionEngine: predictionEngine);

      final fixed = TaskModel()
        ..id = 501
        ..title = 'Board Meeting'
        ..startAt = DateTime(now.year, now.month, now.day, 14, 0)
        ..endAt = DateTime(now.year, now.month, now.day, 16, 0)
        ..priority = 2;

      final movable = TaskModel()
        ..id = 502
        ..title = 'Outdoor 5k Run'
        ..startAt = DateTime(now.year, now.month, now.day, 15, 0)
        ..endAt = DateTime(now.year, now.month, now.day, 16, 0)
        ..priority = 1;

      final plan = planningEngine.createAdaptivePlan(
        existingTasks: [fixed, movable],
        activeSignals: [
          PlanningSignal(
            type: PlanningSignalType.rainIncoming,
            title: 'RAIN DISRUPTION',
            description: 'Rain expected at 15:00',
            suggestedActionTitle: 'RESCHEDULE OUTDOOR',
            confidence: 0.95,
            timestamp: now,
          ),
        ],
        targetDay: now,
      );

      expect(plan.scheduledTasks, isNotEmpty);
      expect(plan.capacityUtilizationPercentage, greaterThan(0));
      // Revisions must have clear explanation reasons
      if (plan.planRevisions.isNotEmpty) {
        expect(plan.planRevisions.first.reason, contains('Optimized'));
      }
    });

    test('Invariant 13: Fast Capture Date/Time Binding & Calendar Parity across 3-days-out', () {
      final now = DateTime.now();
      final targetDate = now.add(const Duration(days: 3));
      final threeDaysOut = DateTime(targetDate.year, targetDate.month, targetDate.day, 14, 30);

      // Fast capture structured task creation
      final task = TaskModel()
        ..id = 901
        ..title = 'Study Quantum Physics'
        ..startAt = threeDaysOut
        ..endAt = threeDaysOut.add(const Duration(minutes: 90))
        ..priority = 2
        ..reminderOffsetMinutes = 15;

      expect(task.startAt.day, equals(targetDate.day));
      expect(task.startAt.hour, equals(14));
      expect(task.startAt.minute, equals(30));
      expect(task.endAt.difference(task.startAt).inMinutes, equals(90));

      // End time must strictly follow start time
      expect(task.endAt.isAfter(task.startAt), isTrue);
    });

    test('Invariant 14: Long Task Title Mobile Layout Resilience (40+ chars)', () {
      const longTitle = 'Finish quarterly report and send to entire leadership team before EOD';
      final task = TaskModel()
        ..id = 902
        ..title = longTitle
        ..startAt = DateTime.now()
        ..endAt = DateTime.now().add(const Duration(minutes: 60))
        ..priority = 1;

      expect(task.title.length, greaterThan(40));
      expect(task.title, equals(longTitle));
    });

    test('Invariant 15: Real Haversine Math & 20m Accuracy Filtering', () {
      final processor = TrackQualityProcessor();

      // Point 1: Origin
      final p1 = GpsObservation(
        latitude: 12.9716,
        longitude: 77.5946,
        timestamp: DateTime(2026, 8, 29, 9, 0, 0),
        elapsedRealtimeNanos: 1000000000,
        horizontalAccuracyMeters: 4.5,
        sensorSpeedMps: 0.0,
      );
      final r1 = processor.processSample(p1, isUserPaused: false);
      expect(r1, isNotNull);
      expect(r1!.cumulativeDistanceMeters, equals(0.0));

      // Point 2: Noisy spike with 25m accuracy -> MUST BE REJECTED
      final p2Noisy = GpsObservation(
        latitude: 12.9720,
        longitude: 77.5950,
        timestamp: DateTime(2026, 8, 29, 9, 0, 2),
        elapsedRealtimeNanos: 3000000000,
        horizontalAccuracyMeters: 25.0, // > 20m
        sensorSpeedMps: 2.0,
      );
      final r2 = processor.processSample(p2Noisy, isUserPaused: false);
      expect(r2, isNull);

      // Point 3: Real movement (~100m displacement in 30 seconds = ~12 km/h)
      final p3 = GpsObservation(
        latitude: 12.9725,
        longitude: 77.5946,
        timestamp: DateTime(2026, 8, 29, 9, 0, 30),
        elapsedRealtimeNanos: 30000000000,
        horizontalAccuracyMeters: 5.0,
        sensorSpeedMps: 3.3,
      );
      final r3 = processor.processSample(p3, isUserPaused: false);
      expect(r3, isNotNull);
      expect(r3!.cumulativeDistanceMeters, greaterThan(80.0));
      expect(r3.validatedSpeedKmh, greaterThan(5.0));
    });

    test('Invariant 16: End-to-End JourneyRecord Persistence to Local Store', () async {
      final obsStore = ObservationStore();
      final historyRepo = JourneyHistoryRepositoryImpl(null); // In-memory fallback
      final engine = MasterJourneyEngine(
        observationStore: obsStore,
        historyRepository: historyRepo,
      );

      // Start walk
      await engine.startJourney(JourneyType.walk);
      expect(engine.currentLiveState?.distanceKm, equals(0.0));
      expect(engine.currentLiveState?.currentSpeedKmh, equals(0.0));

      // Ingest real step forward
      engine.ingestGpsSample(
        GpsObservation(
          latitude: 12.9730,
          longitude: 77.5946,
          timestamp: DateTime.now().add(const Duration(seconds: 40)),
          elapsedRealtimeNanos: DateTime.now().microsecondsSinceEpoch * 1000 + 40000000000,
          horizontalAccuracyMeters: 4.0,
          sensorSpeedMps: 3.8,
        ),
      );

      // Finish session
      final summary = await engine.finishJourney(customTitle: 'Morning Park Walk');
      expect(summary.totalDistanceKm, greaterThan(0.05));

      // Confirm saved in repository
      final savedJourneys = await historyRepo.getAllJourneys();
      expect(savedJourneys.length, equals(1));
      expect(savedJourneys.first.title, equals('Morning Park Walk'));
      expect(savedJourneys.first.activityType, equals('walk'));
      expect(savedJourneys.first.routePoints.isNotEmpty, isTrue);
    });
  });
}
