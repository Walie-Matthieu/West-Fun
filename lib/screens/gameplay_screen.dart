import 'package:flutter/material.dart';
import 'package:west_fun/l10n/app_text.dart';
import 'package:west_fun/models/game_engine.dart';
import 'package:west_fun/models/game_models.dart';
import 'package:west_fun/screens/end_game_screen.dart';
import 'package:west_fun/widgets/app_gradient_background.dart';

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
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 560),
                child: Card(
                  elevation: 14,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(28)),
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          widget.mode.label,
                          textAlign: TextAlign.center,
                          style: Theme.of(context)
                              .textTheme
                              .headlineSmall
                              ?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '${t.theme}: ${widget.theme.label}',
                          textAlign: TextAlign.center,
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: Colors.black54,
                                  ),
                        ),
                        const SizedBox(height: 24),
                        Wrap(
                          alignment: WrapAlignment.center,
                          spacing: 12,
                          runSpacing: 12,
                          children: [
                            _InfoChip(
                              label: t.activePlayer,
                              value: _engine.activePlayer.name,
                              icon: Icons.person,
                            ),
                            _InfoChip(
                              label: t.questionsLeft,
                              value: '${_engine.remainingQuestions}',
                              icon: Icons.help_outline,
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        DecoratedBox(
                          decoration: BoxDecoration(
                            color: const Color(0xFFF5F0FF),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(20),
                            child: Text(
                              _engine.currentQuestion,
                              textAlign: TextAlign.center,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge
                                  ?.copyWith(
                                    height: 1.3,
                                  ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                        Text(
                          '${t.agreeVotes}: $_agreeVotes / $voterCount ${t.others}',
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.titleMedium,
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
                        Text(
                          t.scoresRevealedAtEnd,
                          textAlign: TextAlign.center,
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: Colors.black54,
                                  ),
                        ),
                        const SizedBox(height: 24),
                        ElevatedButton(
                          onPressed: () {
                            _engine.applyVote(
                                agreeVotes: _agreeVotes,
                                voterCount: voterCount);
                            if (_engine.isFinished) {
                              Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                  builder: (_) =>
                                      EndGameScreen(players: _engine.ranking),
                                ),
                              );
                              return;
                            }
                            setState(() {
                              _agreeVotes = 0;
                            });
                          },
                          child: Text(t.next),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  const _InfoChip({
    required this.label,
    required this.value,
    required this.icon,
  });

  final String label;
  final String value;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: const Color(0xFFF3EBFF),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 18, color: const Color(0xFF4A00E0)),
            const SizedBox(width: 8),
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        color: Colors.black54,
                      ),
                ),
                Text(
                  value,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
