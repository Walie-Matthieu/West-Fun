import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:west_fun/l10n/app_text.dart';
import 'package:west_fun/models/game_models.dart';
import 'package:west_fun/screens/gameplay_screen.dart';
import 'package:west_fun/widgets/app_gradient_background.dart';
import 'package:west_fun/widgets/player_roster_editor.dart';
import 'package:west_fun/widgets/west_buttons.dart';

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
  static const Color _modePlatformColor = Color(0xFF0F172A); // Couleur de fond du "platform" du bouton de sélection de mode
  static const Color _modeButtonColor = Color.fromARGB(255, 6, 35, 102); // Couleur de fond du bouton de sélection de mode

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

  Widget _buildModeTrailingIcon(
    GameMode mode, {
    double scale = 1.0,
    Offset offset = Offset.zero,
  }) {
    final assetPath = switch (mode) {
      GameMode.whoWould => 'assets/images/main_mickey.png',
      GameMode.shesA10But => 'assets/images/shes_a_ten.png',
      GameMode.neverHaveIEver => 'assets/images/never_I_have_ever.png',
      GameMode.truthOrDare => 'assets/images/truth_or_dare.png',
      GameMode.wouldYouRather => 'assets/images/would_you_rather.png',
      GameMode.crazySituations => 'assets/images/crazy_situations.png',
    };

    return Transform.translate(
      offset: offset,
      child: Transform.scale(
        scale: scale,
        child: Image.asset(
          assetPath,
          width: 104,
          height: 104,
          fit: BoxFit.contain,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final t = AppText.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          t.modes,
          style: const TextStyle(
            fontSize: 28, // Titre dans la barre du haut
            fontWeight: FontWeight.w900,
            letterSpacing: 0.5,
          ),
        ),
        actions: [
          WestIconButton(
            disablePressedShadow: true,
            onPressed: () => _roster.showRosterDialog(context),
            icon: const Icon(Icons.person_add, size: 28),
            tooltip: t.addPlayer,
          ),
        ],
      ),
      body: AppGradientBackground(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            for (final mode in GameMode.values)
              Padding(
                padding: const EdgeInsets.only(bottom: 12), // Séparation entre les boutons de Game mode
                child: _ModePhysicalCard(
                  platformColor: _modePlatformColor,
                  buttonColor: _modeButtonColor,
                  onPressed: () {
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
                  child: SizedBox(
                    height: 106,
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 4),
                      title: Transform.translate(
                        offset: const Offset(0, 10),
                        child: Text(
                          mode.label,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w900,
                            fontSize: 24,
                            letterSpacing: 0.3,
                          ),
                        ),
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Transform.translate(
                            offset: const Offset(0, 7),
                            child: switch (mode) {
                              GameMode.whoWould => _buildModeTrailingIcon(
                                  mode,
                                  scale: 1.40, // Taille de l'icone de mode "Who Would"
                                  offset: const Offset(-15, 10), // Déplacement de l'icone de mode "Who Would"
                                ),
                              GameMode.shesA10But => _buildModeTrailingIcon(
                                  mode,
                                  scale: 1.60, // Taille de l'icone de mode "She's a 10 But"
                                  offset: const Offset(-2, 10), // Déplacement de l'icone de mode "She's a 10 But"
                                ),
                              GameMode.neverHaveIEver => _buildModeTrailingIcon(
                                  mode,
                                  scale: 1.40, // Taille de l'icone de mode "Never Have I Ever"
                                  offset: const Offset(-4, -5), // Déplacement de l'icone de mode "Never Have I Ever"
                                ),
                              GameMode.truthOrDare => _buildModeTrailingIcon(
                                  mode,
                                  scale: 1.40, // Taille de l'icone de mode "Truth or Dare"
                                  offset: const Offset(-4, 7), // Déplacement de l'icone de mode "Truth or Dare"
                                ),
                              GameMode.wouldYouRather => _buildModeTrailingIcon(
                                  mode,
                                  scale: 1.40, // Taille de l'icone de mode "Would You Rather"
                                  offset: const Offset(-6, -7), // Déplacement de l'icone de mode "Would You Rather"
                                ),
                              GameMode.crazySituations => _buildModeTrailingIcon(
                                  mode,
                                  scale: 1.60, // Taille de l'icone de mode "Crazy Situations"
                                  offset: const Offset(-4, 10), // Déplacement de l'icone de mode "Crazy Situations"
                                ),
                            },
                          ),
                          const SizedBox(width: 10),
                          Transform.translate(
                            offset: const Offset(0, 9),
                            child: const Icon(
                              Icons.arrow_forward_ios,
                              color: Colors.white,
                              size: 24,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _ModePhysicalCard extends StatefulWidget {
  const _ModePhysicalCard({
    required this.onPressed,
    required this.child,
    required this.platformColor,
    required this.buttonColor,
  });

  final VoidCallback onPressed;
  final Widget child;
  final Color platformColor;
  final Color buttonColor;

  @override
  State<_ModePhysicalCard> createState() => _ModePhysicalCardState();
}

class _ModePhysicalCardState extends State<_ModePhysicalCard> {
  bool _pressed = false;

  void _setPressed(bool value) {
    if (_pressed != value) {
      setState(() {
        _pressed = value;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final duration = Duration(milliseconds: _pressed ? 100 : 150);

    return Listener(
      onPointerDown: (_) => _setPressed(true),
      onPointerUp: (_) => _setPressed(false),
      onPointerCancel: (_) => _setPressed(false),
      child: TweenAnimationBuilder<double>(
        tween: Tween<double>(end: _pressed ? 1 : 0),
        duration: duration,
        curve: Curves.easeOut,
        builder: (context, t, _) {
          final dy = 8 * t; // Cran de descente du bouton lorsqu'il est pressé

          return SizedBox(
            height: 104,
            child: Stack(
              children: [
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  height: 86,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: widget.platformColor,
                      borderRadius: BorderRadius.circular(22),
                    ),
                  ),
                ),
                Positioned(
                  left: 0,
                  right: 0,
                  top: 0,
                  height: 96,
                  child: Transform.translate(
                    offset: Offset(0, dy),
                    child: Material(
                      color: widget.buttonColor,
                      borderRadius: BorderRadius.circular(22),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(22),
                        splashFactory: NoSplash.splashFactory,
                        splashColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        hoverColor: Colors.transparent,
                        focusColor: Colors.transparent,
                        onTap: widget.onPressed,
                        child: widget.child,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}



