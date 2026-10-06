import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:remember_me/src/core/theme/neo_colors.dart';
import 'package:remember_me/src/core/widgets/neo_app_bar.dart';
import 'package:remember_me/src/core/widgets/neo_bandaid_alarm_logo.dart';
import 'package:remember_me/src/core/widgets/neo_button.dart';
import 'package:remember_me/src/core/widgets/neo_card.dart';

void main() {
  testWidgets('NeoButton renders with bold uppercase text and responds to clicks', (tester) async {
    var clicked = false;
    await tester.pumpWidget(
      MaterialApp(
        theme: ThemeData(
          extensions: const [NeoColors.light],
        ),
        home: Scaffold(
          body: NeoButton(
            text: 'START NOW',
            onPressed: () => clicked = true,
          ),
        ),
      ),
    );

    expect(find.text('START NOW'), findsOneWidget);
    await tester.tap(find.text('START NOW'));
    expect(clicked, isTrue);
  });

  testWidgets('NeoCard renders with 0px sharp corners and custom rotation', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: ThemeData(
          extensions: const [NeoColors.light],
        ),
        home: const Scaffold(
          body: NeoCard(
            rotation: -0.02,
            child: Text('Sticker Card'),
          ),
        ),
      ),
    );

    expect(find.text('Sticker Card'), findsOneWidget);
  });

  testWidgets('NeoAppBar renders with Bandaid Alarm Logo, Notification Bell, and Profile Avatar', (tester) async {
    var infoOpened = false;
    var notificationsOpened = false;
    var profileOpened = false;

    await tester.pumpWidget(
      MaterialApp(
        theme: ThemeData(
          extensions: const [NeoColors.light],
        ),
        home: Scaffold(
          appBar: NeoAppBar(
            title: 'TODAY',
            notificationCount: 3,
            onInfoPressed: () => infoOpened = true,
            onNotificationsPressed: () => notificationsOpened = true,
            onMenuPressed: () => profileOpened = true,
          ),
          body: const SizedBox(),
        ),
      ),
    );

    expect(find.text('TODAY'), findsOneWidget);
    expect(find.byType(NeoBandaidAlarmLogo), findsOneWidget);
    expect(find.byIcon(Icons.notifications_outlined), findsOneWidget);
    expect(find.text('3'), findsOneWidget); // Badge
    expect(find.byIcon(Icons.person_rounded), findsOneWidget);

    // Tap Logo -> Info
    await tester.tap(find.byType(NeoBandaidAlarmLogo));
    expect(infoOpened, isTrue);

    // Tap Notification Bell
    await tester.tap(find.byIcon(Icons.notifications_outlined));
    expect(notificationsOpened, isTrue);

    // Tap Profile Avatar
    await tester.tap(find.byIcon(Icons.person_rounded));
    expect(profileOpened, isTrue);
  });
}
