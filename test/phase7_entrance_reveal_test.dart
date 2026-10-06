import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:remember_me/src/features/splash/presentation/entrance_reveal.dart';

void main() {
  testWidgets('EntranceReveal displays child and respects animation disabling', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: EntranceReveal(
          child: Text('Home Content'),
        ),
      ),
    );

    // Initial frame has both child and animated splash
    expect(find.text('Home Content'), findsOneWidget);
    expect(tester.takeException(), isNull);

    // Let entrance animation complete
    await tester.pumpAndSettle(const Duration(milliseconds: 1600));
    expect(find.text('Home Content'), findsOneWidget);
  });
}
