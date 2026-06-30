import 'dart:math';

import 'package:west_fun/data/question_bank.dart';
import 'package:west_fun/models/game_models.dart';

class GameEngine {
  GameEngine({required this.players, required this.mode, required this.theme, this.maxDelta = 10})
      : totalTurns = max(players.length * 3, 1);

  final List<Player> players;
  final GameMode mode;
  final PartyTheme theme;
  final int maxDelta;
  final int totalTurns;

  int currentTurn = 0;
  int activePlayerIndex = 0;

  String get currentQuestion {
    final questions = questionBank[theme]?[mode] ?? const ['No question available'];
    return questions[currentTurn % questions.length];
  }

  Player get activePlayer => players[activePlayerIndex];

  bool get isFinished => currentTurn >= totalTurns;

  int scoreDeltaForVote({required int agreeVotes, required int voterCount}) {
    if (voterCount <= 0) {
      return 0;
    }
    final ratio = agreeVotes / voterCount;
    final normalized = (ratio - 0.5) * 2;
    return (normalized * maxDelta).round();
  }

  int applyVote({required int agreeVotes, required int voterCount}) {
    final delta = scoreDeltaForVote(agreeVotes: agreeVotes, voterCount: voterCount);
    activePlayer.score += delta;
    currentTurn += 1;
    activePlayerIndex = (activePlayerIndex + 1) % players.length;
    return delta;
  }

  List<Player> get ranking {
    final sorted = [...players];
    sorted.sort((a, b) => b.score.compareTo(a.score));
    return sorted;
  }
}
