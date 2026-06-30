import 'package:flutter/material.dart';
import 'package:west_fun/l10n/app_text.dart';
import 'package:west_fun/models/game_engine.dart';
import 'package:west_fun/models/game_models.dart';
import 'package:west_fun/screens/end_game_screen.dart';
import 'package:west_fun/widgets/app_gradient_background.dart';
import 'package:west_fun/widgets/scoreboard.dart';

class GameplayScreen extends StatefulWidget {
  const GameplayScreen({
    super.key,
    required this.playerNames,
    required this.mode,
    required this.theme,
  });

  final List<String> playerNames;
  final GameMode mode;
  final PartyTheme theme;

  @override
  State<GameplayScreen> createState() => _GameplayScreenState();
}

class _GameplayScreenState extends State<GameplayScreen> {
  late final GameEngine _engine;
  int _agreeVotes = 0;

  @override
  void initState() {
    super.initState();
    _engine = GameEngine(
      players: widget.playerNames.map((name) => Player(name)).toList(),
      mode: widget.mode,
      theme: widget.theme,
    );
  }

  @override
  Widget build(BuildContext context) {
    final t = AppText.of(context);
    final voterCount = _engine.players.length - 1;
    return Scaffold(
      appBar: AppBar(title: Text(widget.mode.label)),
      body: AppGradientBackground(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Scoreboard(players: _engine.players),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                '${t.activePlayer}: ${_engine.activePlayer.name}',
                style: const TextStyle(color: Colors.white),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    _engine.currentQuestion,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                '${t.agreeVotes}: $_agreeVotes / $voterCount ${t.others}',
                style: const TextStyle(color: Colors.white),
              ),
            ),
            Slider(
              value: _agreeVotes.toDouble(),
              min: 0,
              max: voterCount.toDouble(),
              divisions: voterCount,
              onChanged: (value) {
                setState(() {
                  _agreeVotes = value.round();
                });
              },
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: ElevatedButton(
                onPressed: () {
                  _engine.applyVote(agreeVotes: _agreeVotes, voterCount: voterCount);
                  if (_engine.isFinished) {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (_) => EndGameScreen(players: _engine.ranking)),
                    );
                    return;
                  }
                  setState(() {
                    _agreeVotes = 0;
                  });
                },
                child: Text(t.next),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
