import 'package:flutter/material.dart';
import 'package:west_fun/l10n/app_text.dart';
import 'package:west_fun/models/game_models.dart';
import 'package:west_fun/screens/home_screen.dart';

class EndGameScreen extends StatelessWidget {
  const EndGameScreen({super.key, required this.players});

  final List<Player> players;

  @override
  Widget build(BuildContext context) {
    final t = AppText.of(context);
    final winner = players.first;
    return Scaffold(
      appBar: AppBar(title: Text(t.finalScores)),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('${t.winner}: ${winner.name} (${winner.score} pts)', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 16),
            Expanded(
              child: Card(
                child: ListView.builder(
                  itemCount: players.length,
                  itemBuilder: (context, index) {
                    final player = players[index];
                    return ListTile(
                      leading: Text('#${index + 1}'),
                      title: Text(player.name),
                      trailing: Text('${player.score} pts'),
                    );
                  },
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (_) => const HomeScreen()),
                  (route) => false,
                );
              },
              child: Text(t.replay),
            ),
          ],
        ),
      ),
    );
  }
}
