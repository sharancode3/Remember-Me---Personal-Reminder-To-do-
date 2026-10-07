import 'dart:io';
import 'dart:convert';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:remember_me/src/core/theme/daily_theme.dart';
import 'package:remember_me/src/data/models/task_model.dart';
import 'package:remember_me/src/data/repositories/daily_repository.dart';
import 'package:remember_me/src/presentation/providers/providers.dart';
import 'package:remember_me/src/presentation/screens/daily_home_screen.dart';
import 'package:remember_me/src/services/daily_trail_service.dart';
import 'package:remember_me/src/services/local_notification_service.dart';
import 'package:remember_me/src/core/notifications/reminder_scheduler.dart';

class _SilentNotifications extends LocalNotificationService {
  @override
  Future<void> scheduleTaskNudge(
    TaskModel task, {
    int offsetMinutes = 10,
  }) async {}
  @override
  Future<void> cancelTaskReminder(int taskId) async {}
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  final capture = Platform.environment['REMEMBER_ME_CAPTURE'] == 'true';
  for (final screen in [
    'today',
    'calendar',
    'focus',
    'trail',
    'desktop',
    'editor',
    'rose',
  ]) {
    testWidgets('Visual capture: $screen', (tester) async {
      final fontDirectory = Platform.environment['REMEMBER_ME_FONT_DIR']!;
      await tester.runAsync(() async {
        final loader = FontLoader('Roboto');
        for (final name in ['regular', 'medium', 'bold']) {
          loader.addFont(
            File(
              '$fontDirectory/roboto-$name.ttf',
            ).readAsBytes().then(ByteData.sublistView),
          );
        }
        await loader.load();
        final icons = FontLoader('MaterialIcons')
          ..addFont(
            File(
              '$fontDirectory/materialicons-regular.otf',
            ).readAsBytes().then(ByteData.sublistView),
          );
        await icons.load();
      });
      tester.view.physicalSize = screen == 'desktop'
          ? const Size(1100, 850)
          : const Size(360, 800);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(DailyTrailService.channel, (call) async {
            switch (call.method) {
              case 'consumeNavigation':
              case 'consumeRepeatAction':
                return null;
              case 'readTheme':
                return 'mint';
              case 'getPlaces':
                return '[]';
              case 'googleConfigured':
                return false;
              case 'trackingEnabled':
                return false;
              case 'readTrail':
                return screen == 'trail'
                    ? jsonEncode(
                        List.generate(
                          25,
                          (i) => {
                            'lat':
                                12.974 +
                                (i < 9
                                        ? i
                                        : i < 17
                                        ? 8
                                        : 24 - i) *
                                    .00045,
                            'lng':
                                77.591 +
                                (i < 9
                                        ? 0
                                        : i < 17
                                        ? i - 8
                                        : 8) *
                                    .00045,
                            'time': DateTime.now()
                                .subtract(Duration(minutes: 25 - i))
                                .millisecondsSinceEpoch,
                            'accuracy': 5.0,
                            'speed': 1.4,
                            'gap': false,
                          },
                        ),
                      )
                    : '[]';
              case 'focusMinutes':
                return 25;
              default:
                return <String, dynamic>{};
            }
          });
      final notifications = _SilentNotifications();
      final repository = DailyRepository(
        null,
        InMemoryReminderScheduler(),
        notifications,
      );
      final day = dayOnly(DateTime.now());
      for (final item in [
        ('Pick up groceries', 18, false),
        ('Call Mum', 20, false),
        ('Water the plants', 0, true),
      ]) {
        final task = TaskModel()
          ..title = item.$1
          ..startAt = DateTime(day.year, day.month, day.day, item.$2)
          ..endAt = DateTime(day.year, day.month, day.day, item.$2, 1)
          ..reminderOffsetMinutes = item.$3 ? -1 : 0;
        if (item.$3) task.status = TaskStatus.completed;
        await repository.save(task);
      }
      final key = GlobalKey();
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            dailyRepositoryProvider.overrideWithValue(repository),
            localNotificationServiceProvider.overrideWithValue(notifications),
          ],
          child: RepaintBoundary(
            key: key,
            child: MaterialApp(
              debugShowCheckedModeBanner: false,
              theme: DailyTheme.build(
                screen == 'rose' ? DailyStyle.rose : DailyStyle.mint,
              ),
              home: const DailyHomeScreen(),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      if (['calendar', 'focus', 'trail'].contains(screen)) {
        await tester.tap(
          find
              .text(
                screen == 'calendar'
                    ? 'Calendar'
                    : screen == 'focus'
                    ? 'Focus'
                    : 'Trail',
              )
              .last,
        );
        await tester.pumpAndSettle();
      }
      if (screen == 'editor') {
        await tester.tap(find.byTooltip('Add reminder or to-do'));
        await tester.pumpAndSettle();
        await tester.enterText(find.byType(TextField).first, 'Evening walk');
        await tester.tap(find.byIcon(Icons.access_time_rounded));
        await tester.pumpAndSettle();
      }
      expect(tester.takeException(), isNull);
      final boundary =
          key.currentContext!.findRenderObject()! as RenderRepaintBoundary;
      await tester.runAsync(() async {
        final image = await boundary.toImage();
        final data = await image.toByteData(format: ui.ImageByteFormat.png);
        image.dispose();
        final directory = Directory('docs/screenshots')
          ..createSync(recursive: true);
        await File(
          '${directory.path}/$screen.png',
        ).writeAsBytes(data!.buffer.asUint8List());
      });
      await tester.pumpWidget(const SizedBox());
      repository.dispose();
    }, skip: !capture);
  }
}
