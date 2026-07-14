import 'package:flutter_test/flutter_test.dart';
import 'package:west_fun/data/question_bank.dart';
import 'package:west_fun/models/game_engine.dart';
import 'package:west_fun/models/game_models.dart';

void main() {
  group('GameEngine scoring', () {
    late GameEngine engine;

    setUp(() {
      engine = GameEngine(
        players: [Player('A'), Player('B'), Player('C')],
        mode: GameMode.whoWould,
        theme: PartyTheme.friendsNight,
      );
    });

    test('100% agreement gives max points', () {
      expect(engine.scoreDeltaForVote(agreeVotes: 2, voterCount: 2), 10);
    });

    test('50/50 agreement gives neutral points', () {
      expect(engine.scoreDeltaForVote(agreeVotes: 1, voterCount: 2), 0);
    });

    test('0% agreement deducts points', () {
      expect(engine.scoreDeltaForVote(agreeVotes: 0, voterCount: 2), -10);
    });
  });

  group('GameEngine mix theme', () {
    test('draws questions from all themes for selected mode', () {
      final allWhoWouldQuestions = <String>{
        ...questionBank[PartyTheme.friendsNight]![GameMode.whoWould]!,
        ...questionBank[PartyTheme.couple]![GameMode.whoWould]!,
        ...questionBank[PartyTheme.eighteenPlus]![GameMode.whoWould]!,
      };

      final engine = GameEngine(
        players: [Player('A'), Player('B'), Player('C'), Player('D')],
        mode: GameMode.whoWould,
        theme: PartyTheme.mix,
      );

      expect(allWhoWouldQuestions.contains(engine.currentQuestion), isTrue);
    });
  });
}
