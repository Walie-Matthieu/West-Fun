import 'dart:math';

import 'package:west_fun/data/question_bank.dart';
import 'package:west_fun/models/game_models.dart';

class GameEngine {
  GameEngine({
    required this.players,
    required this.mode,
    required this.theme,
    this.maxDelta = 10,
    Random? random,
  })  : assert(players.length > 1, 'At least 2 players are required'),
        totalTurns = max(players.length * 3, 1),
        _random = random ?? Random() {
    _currentQuestion = _drawNextQuestion();
  }

  final List<Player> players;
  final GameMode mode;
  final PartyTheme theme;
  final int maxDelta;
  final int totalTurns;
  final Random _random;
  final List<String> _questionQueue = [];
  String? _lastQuestion;
  late String _currentQuestion;

  int currentTurn = 0;
  int activePlayerIndex = 0;

  String get currentQuestion => _currentQuestion;

  Player get activePlayer => players[activePlayerIndex];

  bool get isFinished => currentTurn >= totalTurns;
  int get remainingQuestions => totalTurns - currentTurn;

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
    if (!isFinished) {
      _drawNextQuestion();
    }
    return delta;
  }

  int applyWhoWouldVote({required int selectedPlayerIndex}) {
    assert(
      selectedPlayerIndex >= 0 && selectedPlayerIndex < players.length,
      'Selected player index is out of range',
    );
    players[selectedPlayerIndex].score += maxDelta;
    currentTurn += 1;
    activePlayerIndex = (activePlayerIndex + 1) % players.length;
    if (!isFinished) {
      _drawNextQuestion();
    }
    return maxDelta;
  }

  void addParticipant(String name) {
    players.add(Player(name));
  }

  bool removeParticipantAt(int index, {int minPlayers = 2}) {
    if (players.length <= minPlayers) {
      return false;
    }
    players.removeAt(index);
    if (players.isEmpty) {
      activePlayerIndex = 0;
      return true;
    }
    if (index < activePlayerIndex) {
      activePlayerIndex -= 1;
    } else if (index == activePlayerIndex && activePlayerIndex >= players.length) {
      activePlayerIndex = 0;
    }
    return true;
  }

  void skipTurn() {
    currentTurn += 1;
    activePlayerIndex = (activePlayerIndex + 1) % players.length;
    if (!isFinished) {
      _drawNextQuestion();
    }
  }

  List<Player> get ranking {
    final sorted = [...players];
    sorted.sort((a, b) => b.score.compareTo(a.score));
    return sorted;
  }

  String _drawNextQuestion() {
    final questions = _questionPoolForSelection();
    if (questions == null || questions.isEmpty) {
      _currentQuestion = 'No question available';
      _lastQuestion = _currentQuestion;
      return _currentQuestion;
    }

    if (questions.length == 1) {
      _currentQuestion = questions.first;
      _lastQuestion = _currentQuestion;
      return _currentQuestion;
    }

    if (_questionQueue.isEmpty) {
      _questionQueue
        ..clear()
        ..addAll(questions);
      _questionQueue.shuffle(_random);

      if (_lastQuestion != null && _questionQueue.first == _lastQuestion) {
        final swapIndex = 1 + _random.nextInt(_questionQueue.length - 1);
        final temp = _questionQueue[0];
        _questionQueue[0] = _questionQueue[swapIndex];
        _questionQueue[swapIndex] = temp;
      }
    }

    _currentQuestion = _questionQueue.removeAt(0);
    _lastQuestion = _currentQuestion;
    return _currentQuestion;
  }

  List<String>? _questionPoolForSelection() {
    if (theme != PartyTheme.mix) {
      return questionBank[theme]?[mode];
    }

    final mixedQuestions = <String>[];
    for (final baseTheme in PartyTheme.values) {
      if (baseTheme == PartyTheme.mix) {
        continue;
      }
      final themeQuestions = questionBank[baseTheme]?[mode];
      if (themeQuestions != null && themeQuestions.isNotEmpty) {
        mixedQuestions.addAll(themeQuestions);
      }
    }

    return mixedQuestions;
  }
}
