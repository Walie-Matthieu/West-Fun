import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:west_fun/models/game_models.dart';
import 'package:west_fun/screens/gameplay_screen.dart';

void main() {
  Widget buildTestApp(Widget home) {
    return MaterialApp(
      locale: const Locale('en'),
      supportedLocales: const [Locale('fr'), Locale('en')],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      home: home,
    );
  }

  testWidgets('keeps scores hidden during gameplay', (tester) async {
    await tester.pumpWidget(
      buildTestApp(
        const GameplayScreen(
          playerNames: ['Alice', 'Bob', 'Chloe'],
          mode: GameMode.whoWould,
          theme: PartyTheme.friendsNight,
        ),
      ),
    );

    expect(find.text('Scoreboard'), findsNothing);
    expect(find.text('Final scores'), findsNothing);
    expect(find.text('Active player'), findsOneWidget);
    expect(find.text('Questions left'), findsOneWidget);
    expect(find.text('Scores will be revealed at the end of the game.'),
        findsOneWidget);
    expect(find.text('Who would survive the longest on a desert island?'),
        findsOneWidget);
  });

  testWidgets('reveals final scores after the last question', (tester) async {
    await tester.pumpWidget(
      buildTestApp(
        const GameplayScreen(
          playerNames: ['Alice', 'Bob'],
          mode: GameMode.whoWould,
          theme: PartyTheme.friendsNight,
        ),
      ),
    );

    final nextButton = find.widgetWithText(ElevatedButton, 'Next');

    for (var turn = 0; turn < 6; turn++) {
      await tester.ensureVisible(nextButton);
      await tester.tap(nextButton);
      await tester.pumpAndSettle();
    }

    expect(find.text('Final scores'), findsOneWidget);
    expect(find.text('Winner: Alice'), findsOneWidget);
    expect(find.text('Scoreboard'), findsNothing);
  });
}
