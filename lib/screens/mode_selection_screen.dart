import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:west_fun/widgets/west_buttons.dart';
import 'package:west_fun/l10n/app_text.dart';
import 'package:west_fun/models/game_models.dart';
import 'package:west_fun/screens/gameplay_screen.dart';
import 'package:west_fun/widgets/app_gradient_background.dart';
import 'package:west_fun/widgets/player_roster_editor.dart';

class ModeSelectionScreen extends StatefulWidget {
  const ModeSelectionScreen({
    super.key,
    required this.playerNames,
    this.playerAvatars,
    required this.theme,
  });

  final List<String> playerNames;
  final List<Uint8List?>? playerAvatars;
  final PartyTheme theme;

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
  Widget _buildModeTrailingIcon(GameMode mode) {
    if (mode == GameMode.whoWould) {
      return Image.asset(
        'assets/images/main_mickey.png',
        width: 100,   // Largeur image qui pourrait 
        height: 100, // hauteur image qui pourrait
        fit: BoxFit.contain,
      );
    }

    if (mode == GameMode.shesA10But) {
      return Image.asset(
        'assets/images/shes_a_ten.png',
        width: 100,   // Largeur image c'est une 10 mais
        height: 100, // Hauteur image c'est une 10 mais
        fit: BoxFit.contain,
      );
    }

    if (mode == GameMode.neverHaveIEver) {
      return Image.asset(
        'assets/images/never_I_have_ever.png',
        width: 100,   // Largeur image je n'ai jamais
        height: 100, // Hauteur image je n'ai jamais
        fit: BoxFit.contain,
      );
    }

    if (mode == GameMode.truthOrDare) {
      return Image.asset(
        'assets/images/truth_or_dare.png',
        width: 100,   // Largeur image Action/Vérité
        height: 100, // Hauteur image Action/Vérité
        fit: BoxFit.contain,
      );
    }

    if (mode == GameMode.wouldYouRather) {
      return Image.asset(
        'assets/images/would_you_rather.png',
        width: 100,   // Largeur image Matrix
        height: 100, // Hauteur image Matrix
        fit: BoxFit.contain,
      );
    }

    return const SizedBox.shrink();
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
                color: const Color(0xFF0F172A),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18), 
                ),
                child: SizedBox(
                  height: 70, // changer la taille de la carte pour s'adapter à l'image
                  child: ListTile(
                    title: Text(
                      mode.label,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Transform.translate(
                        offset: const Offset(0, 7), // Ajuster la position verticale de l'image
                        child: _buildModeTrailingIcon(mode),
                      ),
                      const SizedBox(width: 4),
                      const Icon(Icons.arrow_forward_ios, color: Colors.white, size: 18),
                    ],
                  ),
                  textColor: Colors.white,
                  iconColor: Colors.white,
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => GameplayScreen(
                          playerNames: _roster.names,
                          playerAvatars: _roster.avatars,
                          mode: mode,
                          theme: widget.theme,
                        ),
                      ),
                    );
                    },
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}














