import 'package:flutter/material.dart';
import 'package:west_fun/l10n/app_text.dart';
import 'package:west_fun/models/game_models.dart';
import 'package:west_fun/screens/mode_selection_screen.dart';

class ThemeSelectionScreen extends StatelessWidget {
  const ThemeSelectionScreen({super.key, required this.playerNames});

  final List<String> playerNames;

  @override
  Widget build(BuildContext context) {
    final t = AppText.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(t.themes)),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF8E2DE2), Color(0xFF4A00E0)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            for (final theme in PartyTheme.values)
              Card(
                child: ListTile(
                  title: Text(theme.label),
                  trailing: const Icon(Icons.arrow_forward_ios),
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => ModeSelectionScreen(playerNames: playerNames, theme: theme),
                      ),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}
