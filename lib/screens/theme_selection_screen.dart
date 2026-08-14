import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:west_fun/widgets/west_buttons.dart';
import 'package:west_fun/l10n/app_text.dart';
import 'package:west_fun/models/game_models.dart';
import 'package:west_fun/screens/gameplay_screen.dart';
import 'package:west_fun/screens/mode_selection_screen.dart';
import 'package:west_fun/widgets/app_gradient_background.dart';
import 'package:west_fun/widgets/player_roster_editor.dart';

class ThemeSelectionScreen extends StatefulWidget {
  const ThemeSelectionScreen({
    super.key,
    required this.playerNames,
    this.playerAvatars,
    this.mode,
  });

  final List<String> playerNames;
  final List<Uint8List?>? playerAvatars;
  final GameMode? mode;

  @override
  State<ThemeSelectionScreen> createState() => _ThemeSelectionScreenState();
}

class _ThemeSelectionScreenState extends State<ThemeSelectionScreen> {
  late final PlayerRosterController _roster;

  Widget _buildThemeTile(BuildContext context, PartyTheme theme) {
    return Card(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(36),
          topRight: Radius.circular(10),
          bottomRight: Radius.circular(36),
          bottomLeft: Radius.circular(10),
        ),
      ),
      child: ListTile(
        title: Text(theme.label),
        trailing: const Icon(Icons.arrow_forward_ios),
        onTap: () {
          if (widget.mode != null) {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => GameplayScreen(
                  playerNames: _roster.names,
                  playerAvatars: _roster.avatars,
                  mode: widget.mode!,
                  theme: theme,
                ),
              ),
            );
            return;
          }

          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => ModeSelectionScreen(
                playerNames: _roster.names,
                playerAvatars: _roster.avatars,
                theme: theme,
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _roster = PlayerRosterController(
      initialNames: widget.playerNames,
      initialAvatars: widget.playerAvatars,
      onChanged: () => setState(() {}),
    );
  }

  @override
  Widget build(BuildContext context) {
    final t = AppText.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(t.themes),
        actions: [
          WestIconButton(
            disablePressedShadow: true,
            onPressed: () => _roster.showRosterDialog(context),
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
              _buildThemeTile(context, theme),
          ],
        ),
      ),
    );
  }
}
