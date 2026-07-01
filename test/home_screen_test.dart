import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:west_fun/screens/home_screen.dart';

void main() {
  testWidgets('shows app name and play button', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        locale: Locale('en'),
        supportedLocales: [Locale('fr'), Locale('en')],
        localizationsDelegates: [
          GlobalMaterialLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        home: HomeScreen(),
      ),
    );

    expect(find.text('West-Fun'), findsNWidgets(2));
    expect(find.text('Play'), findsOneWidget);
  });
}
