import 'package:flutter/material.dart';
import 'package:west_fun/l10n/app_text.dart';
import 'package:west_fun/models/game_models.dart';
import 'package:west_fun/screens/gameplay_screen.dart';

class ModeSelectionScreen extends StatelessWidget {
  const ModeSelectionScreen({
    super.key,
    required this.playerNames,
    required this.theme,
  });

  final List<String> playerNames;
  final PartyTheme theme;

  @override
  Widget build(BuildContext context) {
    final t = AppText.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(t.modes)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          for (final mode in GameMode.values)
            Card(
              child: ListTile(
                title: Text(mode.label),
                subtitle: Text('${t.theme}: ${theme.label}'),
                trailing: const Icon(Icons.play_arrow),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => GameplayScreen(
                        playerNames: playerNames,
                        mode: mode,
                        theme: theme,
                      ),
                    ),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}
