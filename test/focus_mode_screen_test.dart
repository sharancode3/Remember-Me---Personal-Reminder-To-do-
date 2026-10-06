import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:remember_me/src/core/theme/neo_colors.dart';
import 'package:remember_me/src/presentation/providers/providers.dart';
import 'package:remember_me/src/presentation/screens/focus_mode_screen.dart';

void main() {
  testWidgets('FocusModeScreen renders mechanical countdown and action controls', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          focusModeProvider.overrideWith((ref) => FocusModeState(
                enabled: true,
                activeTaskId: 123,
                deepFocus: true,
                startedAt: DateTime.now(),
              )),
        ],
        child: MaterialApp(
          theme: ThemeData(
            extensions: const [NeoColors.light],
          ),
          home: const FocusModeScreen(),
        ),
      ),
    );

    await tester.pump();

    // Verify key elements
    expect(find.text('FOCUS MODE'), findsOneWidget);
    expect(find.text('REMAINING TIME'), findsOneWidget);
    expect(find.text('PAUSE'), findsOneWidget);
    expect(find.text('+5 MIN'), findsOneWidget);
    expect(find.text('FINISH ✓'), findsOneWidget);
  });

  testWidgets('FocusModeScreen renders without overflow on narrow 360x800 Android viewport', (tester) async {
    tester.view.physicalSize = const Size(360, 800);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() => tester.view.resetPhysicalSize());

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          focusModeProvider.overrideWith((ref) => FocusModeState(
                enabled: true,
                activeTaskId: 123,
                deepFocus: true,
                startedAt: DateTime.now(),
              )),
        ],
        child: MaterialApp(
          theme: ThemeData(
            extensions: const [NeoColors.light],
          ),
          home: const FocusModeScreen(),
        ),
      ),
    );

    await tester.pump();

    expect(tester.takeException(), isNull);
    expect(find.text('FOCUS MODE'), findsOneWidget);
  });
}
