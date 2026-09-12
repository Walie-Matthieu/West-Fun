import 'package:flutter/material.dart';
import 'package:west_fun/l10n/app_text.dart';
import 'package:west_fun/models/game_models.dart';

class Scoreboard extends StatelessWidget {
  const Scoreboard({super.key, required this.players});

  final List<Player> players;

  @override
  Widget build(BuildContext context) {
    final t = AppText.of(context);
    return Card(
      margin: const EdgeInsets.all(12),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              t.scoreboard,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            for (final player in players)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 2),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(player.name),
                    Text('${player.score} pts'),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
