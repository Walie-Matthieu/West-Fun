import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:west_fun/models/game_models.dart';
import 'package:west_fun/screens/mode_selection_screen.dart';
import 'package:west_fun/screens/theme_selection_screen.dart';

Widget buildTestApp(Widget home) {
  return MaterialApp(
    locale: const Locale('en'),
    supportedLocales: const [Locale('fr'), Locale('en')],
    localizationsDelegates: const [
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate,
    ],
    home: home,
  );
}

void main() {
  testWidgets('can add player from themes before starting a game', (tester) async {
    await tester.pumpWidget(
      buildTestApp(
        const ThemeSelectionScreen(playerNames: ['Alice', 'Bob']),
      ),
    );

    await tester.tap(find.byIcon(Icons.person_add));
    await tester.pumpAndSettle();
    expect(find.text('Current players'), findsOneWidget);
    expect(find.text('• Alice'), findsOneWidget);
    expect(find.text('• Bob'), findsOneWidget);
    await tester.enterText(find.byType(TextField).last, 'Chloe');
    await tester.tap(find.widgetWithText(ElevatedButton, 'Add player'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Friends night'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Never have I ever...'));
    await tester.pumpAndSettle();

    expect(find.widgetWithText(ElevatedButton, 'Vote (0/2)'), findsOneWidget);
  });

  testWidgets('can add player from game mode before starting a game', (tester) async {
    await tester.pumpWidget(
      buildTestApp(
        const ModeSelectionScreen(
          playerNames: ['Alice', 'Bob'],
          theme: PartyTheme.friendsNight,
        ),
      ),
    );

    await tester.tap(find.byIcon(Icons.person_add));
    await tester.pumpAndSettle();
    expect(find.text('Current players'), findsOneWidget);
    expect(find.text('• Alice'), findsOneWidget);
    expect(find.text('• Bob'), findsOneWidget);
    await tester.enterText(find.byType(TextField).last, 'Chloe');
    await tester.tap(find.widgetWithText(ElevatedButton, 'Add player'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Never have I ever...'));
    await tester.pumpAndSettle();

    expect(find.widgetWithText(ElevatedButton, 'Vote (0/2)'), findsOneWidget);
  });

  testWidgets('can remove player from themes before starting a game', (tester) async {
    await tester.pumpWidget(
      buildTestApp(
        const ThemeSelectionScreen(playerNames: ['Alice', 'Bob', 'Chloe']),
      ),
    );

    await tester.tap(find.byIcon(Icons.person_add));
    await tester.pumpAndSettle();
    expect(find.text('• Chloe'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.remove_circle_outline).last);
    await tester.pumpAndSettle();
    expect(find.text('• Chloe'), findsNothing);
    await tester.tap(find.widgetWithText(TextButton, 'Cancel'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Friends night'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Never have I ever...'));
    await tester.pumpAndSettle();

    expect(find.widgetWithText(ElevatedButton, 'Vote (0/1)'), findsOneWidget);
  });

  testWidgets('can remove player from game mode before starting a game', (tester) async {
    await tester.pumpWidget(
      buildTestApp(
        const ModeSelectionScreen(
          playerNames: ['Alice', 'Bob', 'Chloe'],
          theme: PartyTheme.friendsNight,
        ),
      ),
    );

    await tester.tap(find.byIcon(Icons.person_add));
    await tester.pumpAndSettle();
    expect(find.text('• Chloe'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.remove_circle_outline).last);
    await tester.pumpAndSettle();
    expect(find.text('• Chloe'), findsNothing);
    await tester.tap(find.widgetWithText(TextButton, 'Cancel'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Never have I ever...'));
    await tester.pumpAndSettle();

    expect(find.widgetWithText(ElevatedButton, 'Vote (0/1)'), findsOneWidget);
  });
}
