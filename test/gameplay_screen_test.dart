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
    expect(find.widgetWithText(ElevatedButton, 'Vote'), findsOneWidget);
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

    await tester.tap(find.widgetWithText(ElevatedButton, 'Vote'));
    await tester.pumpAndSettle();

    expect(find.byType(AlertDialog), findsOneWidget);
    expect(find.text('Alice'), findsOneWidget);
    expect(find.text('Bob'), findsOneWidget);
    expect(find.text('Chloe'), findsOneWidget);

    await tester.tap(find.widgetWithText(CheckboxListTile, 'Bob'));
    await tester.pumpAndSettle();

    await tester.tap(find.widgetWithText(ElevatedButton, 'Confirm'));
    await tester.pumpAndSettle();

    expect(find.widgetWithText(ElevatedButton, 'Vote (Bob)'), findsOneWidget);
  });

  testWidgets('allows skipping who would question without selecting player',
      (tester) async {
    await tester.pumpWidget(
      buildTestApp(
        const GameplayScreen(
          playerNames: ['Alice', 'Bob', 'Chloe'],
          mode: GameMode.whoWould,
          theme: PartyTheme.friendsNight,
        ),
      ),
    );

    expect(find.text('Who would survive the longest on a desert island?'),
        findsOneWidget);

    await tester.tap(find.widgetWithText(ElevatedButton, 'Next'));
    await tester.pumpAndSettle();

    expect(find.text('Who would accidentally start a fire while cooking?'),
        findsOneWidget);
  });

  testWidgets('reveals final scores after the last question', (tester) async {
    await tester.pumpWidget(
      buildTestApp(
        const GameplayScreen(
          playerNames: ['Alice', 'Bob'],
          mode: GameMode.neverHaveIEver,
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

  testWidgets('can add and remove participants during gameplay', (tester) async {
    await tester.pumpWidget(
      buildTestApp(
        const GameplayScreen(
          playerNames: ['Alice', 'Bob'],
          mode: GameMode.neverHaveIEver,
          theme: PartyTheme.friendsNight,
        ),
      ),
    );

    await tester.tap(find.byIcon(Icons.more_vert));
    await tester.pumpAndSettle();

    expect(find.text('Manage participants'), findsOneWidget);
    expect(find.text('Alice'), findsOneWidget);
    expect(find.text('Bob'), findsOneWidget);

    await tester.enterText(find.byType(TextField), 'Chloe');
    await tester.tap(find.widgetWithText(ElevatedButton, 'Add player'));
    await tester.pumpAndSettle();
    expect(find.text('Chloe'), findsOneWidget);

    await tester.tap(find.byKey(const ValueKey('remove-participant-Bob')));
    await tester.pumpAndSettle();
    expect(find.text('Bob'), findsNothing);

    await tester.tap(find.widgetWithText(ElevatedButton, 'Confirm'));
    await tester.pumpAndSettle();

    await tester.tap(find.widgetWithText(ElevatedButton, 'Vote (0/1)'));
    await tester.pumpAndSettle();
    expect(find.text('Chloe'), findsOneWidget);
    expect(find.text('Bob'), findsNothing);
  });
}
