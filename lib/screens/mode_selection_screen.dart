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

  Widget _buildModeTrailingIcon(GameMode mode) {
    if (mode == GameMode.whoWould) {
      return Image.asset(
        'assets/images/main_mickey.png',
        width: 100,
        height: 100,
        fit: BoxFit.contain,
      );
    }

    if (mode == GameMode.shesA10But) {
      return Image.asset(
        'assets/images/shes_a_ten.png',
        width: 100,
        height: 100,
        fit: BoxFit.contain,
      );
    }

    if (mode == GameMode.neverHaveIEver) {
      return Image.asset(
        'assets/images/never_I_have_ever.png',
        width: 100,
        height: 100,
        fit: BoxFit.contain,
      );
    }

    if (mode == GameMode.truthOrDare) {
      return Image.asset(
        'assets/images/truth_or_dare.png',
        width: 100,
        height: 100,
        fit: BoxFit.contain,
      );
    }

    if (mode == GameMode.wouldYouRather) {
      return Image.asset(
        'assets/images/would_you_rather.png',
        width: 100,
        height: 100,
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
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
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
                    height: 70,
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
                            offset: const Offset(0, 7),
                            child: _buildModeTrailingIcon(mode),
                          ),
                          const SizedBox(width: 4),
                          const Icon(
                            Icons.arrow_forward_ios,
                            color: Colors.white,
                            size: 18,
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
                      color: widget.platformColor,
                      borderRadius: BorderRadius.circular(18),
                    ),
                  ),
                ),
                Positioned(
                  left: 0,
                  right: 0,
                  top: 0,
                  height: 70,
                  child: Transform.translate(
                    offset: Offset(0, dy), 
                    child: Material(
                      color: widget.buttonColor,
                      borderRadius: BorderRadius.circular(18),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(18),
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
