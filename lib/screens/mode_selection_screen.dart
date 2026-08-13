import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:west_fun/widgets/west_buttons.dart';
import 'package:west_fun/l10n/app_text.dart';
import 'package:west_fun/models/game_models.dart';
import 'package:west_fun/screens/gameplay_screen.dart';
import 'package:west_fun/screens/theme_selection_screen.dart';
import 'package:west_fun/widgets/app_gradient_background.dart';
import 'package:west_fun/widgets/player_roster_editor.dart';

class ModeSelectionScreen extends StatefulWidget {
  const ModeSelectionScreen({
    super.key,
    required this.playerNames,
    this.playerAvatars,
    this.theme,
  });

  final List<String> playerNames;
  final List<Uint8List?>? playerAvatars;
  final PartyTheme? theme;

  @override
  State<ModeSelectionScreen> createState() => _ModeSelectionScreenState();
}

class _ModeSelectionScreenState extends State<ModeSelectionScreen> {
  late final PlayerRosterController _roster;

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
        title: Text(t.modes),
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
            for (final mode in GameMode.values)
              Card(
                child: ListTile(
                  title: Text(mode.label),
                  subtitle: widget.theme != null
                      ? Text('${t.theme}: ${widget.theme!.label}')
                      : null,
                  trailing: const Icon(Icons.arrow_forward_ios),
                  onTap: () {
                    if (widget.theme != null) {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => GameplayScreen(
                            playerNames: _roster.names,
                            playerAvatars: _roster.avatars,
                            mode: mode,
                            theme: widget.theme!,
                          ),
                        ),
                      );
                      return;
                    }

                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => ThemeSelectionScreen(
                          playerNames: _roster.names,
                          playerAvatars: _roster.avatars,
                          mode: mode,
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



