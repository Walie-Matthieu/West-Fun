import 'package:flutter_test/flutter_test.dart';
import 'package:west_fun/main.dart';

void main() {
  testWidgets('shows app name and play button', (tester) async {
    await tester.pumpWidget(const WestFunApp());

    expect(find.text('West-Fun'), findsOneWidget);
    expect(find.text('Jouer'), findsOneWidget);
  });
}
