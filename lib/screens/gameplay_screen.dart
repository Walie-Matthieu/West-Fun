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

  Future<void> _openVoteDialog() async {
    final t = AppText.of(context);
    final voterCount = _engine.players.length - 1;
    var selectedVotes = _agreeVotes;

    final result = await showDialog<int>(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: Text(t.voteDialogTitle),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    '$selectedVotes / $voterCount ${t.others}',
                    textAlign: TextAlign.center,
                  ),
                  Slider(
                    value: selectedVotes.toDouble(),
                    min: 0,
                    max: voterCount.toDouble(),
                    divisions: voterCount,
                    onChanged: (value) {
                      setDialogState(() {
                        selectedVotes = value.round();
                      });
                    },
                  ),
                ],
              ),
              actions: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(dialogContext).pop(selectedVotes);
                  },
                  child: Text(t.confirm),
                ),
              ],
            );
          },
        );
      },
    );

    if (result != null) {
      setState(() {
        _agreeVotes = result;
      });
    }
  }

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
                          widget.theme.label,
                          textAlign: TextAlign.center,
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: Colors.black54,
                                  ),
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
                        ElevatedButton(
                          onPressed: _openVoteDialog,
                          child: Text('${t.vote} ($_agreeVotes/$voterCount)'),
                        ),
                        const SizedBox(height: 12),
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
