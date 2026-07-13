import 'package:flutter/material.dart';
import 'package:west_fun/l10n/app_text.dart';
import 'package:west_fun/models/game_models.dart';
import 'package:west_fun/screens/theme_selection_screen.dart';
import 'package:west_fun/widgets/app_gradient_background.dart';

class EndGameScreen extends StatelessWidget {
  const EndGameScreen({
    super.key,
    required this.players,
    required this.replayPlayerNames,
  });

  final List<Player> players;
  final List<String> replayPlayerNames;

  @override
  Widget build(BuildContext context) {
    final t = AppText.of(context);
    final winner = players.first;
    return Scaffold(
      appBar: AppBar(title: Text(t.finalScores)),
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
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          '${t.winner}: ${winner.name}',
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
                          '${winner.score} pts',
                          textAlign: TextAlign.center,
                          style:
                              Theme.of(context).textTheme.titleMedium?.copyWith(
                                    color: const Color(0xFF4A00E0),
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                        const SizedBox(height: 24),
                        for (final entry in players.indexed) ...[
                          ListTile(
                            contentPadding: EdgeInsets.zero,
                            leading:
                                CircleAvatar(child: Text('${entry.$1 + 1}')),
                            title: Text(entry.$2.name),
                            trailing: Text('${entry.$2.score} pts'),
                          ),
                          if (entry.$1 != players.length - 1)
                            const Divider(height: 1),
                        ],
                        const SizedBox(height: 24),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(
                                builder: (_) => ThemeSelectionScreen(
                                  playerNames: replayPlayerNames,
                                ),
                              ),
                              (route) => false,
                            );
                          },
                          child: Text(t.replay),
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
