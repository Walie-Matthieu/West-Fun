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
    expect(find.widgetWithText(ElevatedButton, 'Vote (0/2)'), findsOneWidget);
    expect(find.widgetWithText(ElevatedButton, 'Next'), findsOneWidget);
    expect(find.text('Friends night'), findsOneWidget);
    expect(find.text('Who would survive the longest on a desert island?'),
        findsOneWidget);
  });

  testWidgets('updates vote count from vote dialog', (tester) async {
    await tester.pumpWidget(
      buildTestApp(
        const GameplayScreen(
          playerNames: ['Alice', 'Bob', 'Chloe'],
          mode: GameMode.whoWould,
          theme: PartyTheme.friendsNight,
        ),
      ),
    );

    await tester.tap(find.widgetWithText(ElevatedButton, 'Vote (0/2)'));
    await tester.pumpAndSettle();

    expect(find.text('How many agree?'), findsOneWidget);
    expect(find.text('0 / 2 other players'), findsOneWidget);

    await tester.drag(find.byType(Slider), const Offset(300, 0));
    await tester.pumpAndSettle();

    await tester.tap(find.widgetWithText(ElevatedButton, 'Confirm'));
    await tester.pumpAndSettle();

    expect(find.widgetWithText(ElevatedButton, 'Vote (2/2)'), findsOneWidget);
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
