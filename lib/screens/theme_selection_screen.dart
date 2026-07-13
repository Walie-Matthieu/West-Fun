import 'package:flutter/material.dart';
import 'package:west_fun/l10n/app_text.dart';
import 'package:west_fun/models/game_models.dart';
import 'package:west_fun/screens/mode_selection_screen.dart';
import 'package:west_fun/widgets/app_gradient_background.dart';

class ThemeSelectionScreen extends StatefulWidget {
  const ThemeSelectionScreen({super.key, required this.playerNames});

  final List<String> playerNames;

  @override
  State<ThemeSelectionScreen> createState() => _ThemeSelectionScreenState();
}

class _ThemeSelectionScreenState extends State<ThemeSelectionScreen> {
  late final List<String> _playerNames;

  @override
  void initState() {
    super.initState();
    _playerNames = List<String>.of(widget.playerNames, growable: true);
  }

  void _addPlayerFromInput(
    BuildContext dialogContext,
    String playerName,
  ) {
    final t = AppText.of(context);
    final normalizedName = playerName.trim();
    if (normalizedName.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(t.enterPlayerName)),
      );
      return;
    }
    Navigator.of(dialogContext).pop();
    setState(() {
      _playerNames.add(normalizedName);
    });
  }

  bool _removePlayerAt(int index) {
    final t = AppText.of(context);
    if (_playerNames.length <= 2) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(t.minTwoPlayersInGame)),
      );
      return false;
    }
    setState(() {
      _playerNames.removeAt(index);
    });
    return true;
  }

  Future<void> _showAddPlayerDialog(BuildContext context) async {
    final t = AppText.of(context);
    var playerName = '';
    await showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (dialogContext, dialogSetState) {
            return AlertDialog(
              title: Text(t.addPlayer),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    t.currentPlayers,
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  const SizedBox(height: 8),
                  ConstrainedBox(
                    constraints: const BoxConstraints(maxHeight: 160),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          for (var i = 0; i < _playerNames.length; i++)
                            Row(
                              children: [
                                Expanded(child: Text('• ${_playerNames[i]}')),
                                IconButton(
                                  onPressed: () {
                                    if (_removePlayerAt(i)) {
                                      dialogSetState(() {});
                                    }
                                  },
                                  icon: const Icon(Icons.remove_circle_outline),
                                  tooltip: t.removePlayer,
                                ),
                              ],
                            ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    autofocus: true,
                    decoration: InputDecoration(labelText: t.playerName),
                    textInputAction: TextInputAction.done,
                    onChanged: (value) {
                      playerName = value;
                    },
                    onSubmitted: (_) =>
                        _addPlayerFromInput(dialogContext, playerName),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(dialogContext).pop(),
                  child: Text(t.cancel),
                ),
                ElevatedButton(
                  onPressed: () => _addPlayerFromInput(dialogContext, playerName),
                  child: Text(t.addPlayer),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final t = AppText.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(t.themes),
        actions: [
          IconButton(
            onPressed: () => _showAddPlayerDialog(context),
            icon: const Icon(Icons.person_add),
            tooltip: t.addPlayer,
          ),
        ],
      ),
      body: AppGradientBackground(
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
                        builder: (_) => ModeSelectionScreen(
                          playerNames: _playerNames,
                          theme: theme,
                        ),
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
