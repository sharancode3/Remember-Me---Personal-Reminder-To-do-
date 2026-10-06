import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:remember_me/main.dart';
import 'package:remember_me/src/services/local_notification_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setUp(AndroidFlutterLocalNotificationsPlugin.registerWith);
  const notifications = MethodChannel(
    'dexterous.com/flutter/local_notifications',
  );

  test('Fresh notification startup does not ask for permissions', () async {
    final calls = <String>[];
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(notifications, (call) async {
          calls.add(call.method);
          return switch (call.method) {
            'initialize' => true,
            'getNotificationAppLaunchDetails' => {
              'notificationLaunchedApp': false,
            },
            _ => null,
          };
        });
    addTearDown(
      () => TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(notifications, null),
    );
    await LocalNotificationService().initialize();
    expect(calls, ['initialize', 'getNotificationAppLaunchDetails', 'cancel']);
  });

  test(
    'Notification startup can retry after a native initialization failure',
    () async {
      var attempts = 0;
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(notifications, (call) async {
            if (call.method == 'initialize') {
              attempts++;
              if (attempts == 1) {
                throw PlatformException(code: 'temporary_failure');
              }
              return true;
            }
            if (call.method == 'getNotificationAppLaunchDetails') {
              return {'notificationLaunchedApp': false};
            }
            return null;
          });
      addTearDown(
        () => TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
            .setMockMethodCallHandler(notifications, null),
      );
      final service = LocalNotificationService();
      await expectLater(
        service.initialize(),
        throwsA(isA<PlatformException>()),
      );
      await service.initialize();
      expect(attempts, 2);
    },
  );

  testWidgets('Startup failure has readable recovery and collapsed details', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(360, 640);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(
      StartupErrorApp(message: 'native failure', onRetry: () async {}),
    );
    expect(find.text("Couldn't open Remember Me"), findsOneWidget);
    expect(find.text('Try again'), findsOneWidget);
    expect(find.text('native failure'), findsNothing);
    await tester.tap(find.text('Error details'));
    await tester.pumpAndSettle();
    expect(find.text('native failure'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('Retry runs once and becomes available after finishing', (
    tester,
  ) async {
    final pending = Completer<void>();
    var attempts = 0;
    await tester.pumpWidget(
      StartupErrorApp(
        message: 'native failure',
        onRetry: () {
          attempts++;
          return pending.future;
        },
      ),
    );
    await tester.tap(find.text('Try again'));
    await tester.pump();
    expect(attempts, 1);
    expect(find.text('Opening...'), findsOneWidget);
    expect(
      tester.widget<FilledButton>(find.byType(FilledButton)).onPressed,
      isNull,
    );
    pending.complete();
    await tester.pumpAndSettle();
    expect(find.text('Try again'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
