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

  /// Taille des icones du mode "Themes"
  Widget _buildThemeIcon(PartyTheme theme, {double size = 50}) {
    final assetPath = switch (theme) {
      PartyTheme.friendsNight => 'assets/images/friends_night.png',
      _ => null,
    };

    if (assetPath != null) {
      return Transform.translate(
        offset: const Offset(0, 9), // Déplacement de l'icone "Friends night"
        child: Image.asset(
          assetPath,
          width: 100, // Taille de l'icone "Friends night" dans le mode "Themes"
          height: 90, // Taille en hauteur de l'icone "Friends night" dans le mode "Themes"
          fit: BoxFit.contain,
        ),
      );
    }

    final fallbackIcon = switch (theme) {
      PartyTheme.couple => Icons.favorite,
      PartyTheme.eighteenPlus => Icons.eighteen_up_rating,
      PartyTheme.mix => Icons.shuffle,
      PartyTheme.friendsNight => Icons.groups,
    };

    return Transform.translate(
      offset: const Offset(0, 4), // Déplacement des autres icones du mode "Themes"
      child: Icon(
        fallbackIcon,
        color: Colors.white, // Couleur des icones du mode "Themes"
        size: size * 0.9,
      ),
    );
  }

  Widget _buildThemeTile(BuildContext context, PartyTheme theme) {
    const shapeBorderRadius = BorderRadius.only(
      topLeft: Radius.circular(36),
      topRight: Radius.circular(10),
      bottomRight: Radius.circular(36),
      bottomLeft: Radius.circular(10),
    );

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: _ThemePhysicalCard(
        shapeBorderRadius: shapeBorderRadius,
        onPressed: () {
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
        child: SizedBox(
          height: 70,
          child: ListTile(
            contentPadding: const EdgeInsets.only(left: 18, right: 16), // Déplacement du titre des boutons du mode "Themes"
            title: Transform.translate(
              offset: const Offset(0, 10), // Déplacement du titre des boutons du mode "Themes"
              child: Text(
                theme.label,
                style: const TextStyle(
                  color: Colors.white, // Couleur du texte des boutons du mode "Themes"
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildThemeIcon(theme),
                const SizedBox(width: 10), // Déplacement de l'icône de flèche du mode "Themes"
                Transform.translate(
                  offset: const Offset(0, 10), // Déplacement de l'icône de flèche du mode "Themes"
                  child: const Icon(
                    Icons.arrow_forward_ios,
                    color: Color.fromARGB(255, 239, 236, 236), // Couleur des flèches du mode "Themes"
                    size: 18,
                  ),
                ),
              ],
            ),
          ),
        ),
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

class _ThemePhysicalCard extends StatefulWidget {
  const _ThemePhysicalCard({
    required this.onPressed,
    required this.child,
    required this.shapeBorderRadius,
  });

  final VoidCallback onPressed;
  final Widget child;
  final BorderRadius shapeBorderRadius;

  @override
  State<_ThemePhysicalCard> createState() => _ThemePhysicalCardState();
}

class _ThemePhysicalCardState extends State<_ThemePhysicalCard> {
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
          final dy = 8 * t; // Descend le bouton de 8 pixels lorsque le bouton est pressé

          return SizedBox(
            height: 78,
            child: Stack(
              children: [
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  height: 64,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: const Color(0xFF0F172A), // Couleur du socle des boutons dans Themes
                      borderRadius: widget.shapeBorderRadius,
                    ),
                  ),
                ),
                Positioned(
                  left: 0,
                  right: 0,
                  top: 0,
                  height: 70,
                  child: Transform.translate(
                    offset: Offset(0, dy), // Déplace les boutons de droites à gauche
                    child: Material(
                      color: const Color.fromARGB(255, 6, 35, 102), // Couleur des boutons dans Themes
                      borderRadius: widget.shapeBorderRadius,
                      child: InkWell(
                        borderRadius: widget.shapeBorderRadius,
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
