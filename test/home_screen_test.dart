import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:west_fun/screens/home_screen.dart';

void main() {
  testWidgets('shows app name and play button', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        locale: Locale('fr'),
        supportedLocales: [Locale('fr'), Locale('en')],
        home: HomeScreen(),
      ),
    );

    expect(find.text('West-Fun'), findsOneWidget);
    expect(find.text('Jouer'), findsOneWidget);
  });
}
