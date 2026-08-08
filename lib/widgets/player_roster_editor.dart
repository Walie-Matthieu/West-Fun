import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:west_fun/widgets/west_buttons.dart';
import 'package:west_fun/l10n/app_text.dart';

/// Manages the mutable player list (names + avatars) shared by
/// ThemeSelectionScreen and ModeSelectionScreen, and owns the
/// add/remove dialog.
class PlayerRosterController {
  PlayerRosterController({
    required List<String> initialNames,
    List<Uint8List?>? initialAvatars,
    required VoidCallback onChanged,
  }) : _onChanged = onChanged {
    names = List<String>.of(initialNames, growable: true);
    avatars = List<Uint8List?>.generate(
      names.length,
      (i) =>
          initialAvatars != null && i < initialAvatars.length
              ? initialAvatars[i]
              : null,
      growable: true,
    );
  }

  final VoidCallback _onChanged;
  late final List<String> names;
  late final List<Uint8List?> avatars;

  static Widget buildAvatar(Uint8List? avatarBytes) {
    return CircleAvatar(
      radius: 16,
      backgroundColor: const Color(0xFFEDE7F6),
      backgroundImage: avatarBytes != null ? MemoryImage(avatarBytes) : null,
      child: avatarBytes == null
          ? const Icon(Icons.tag_faces, size: 18, color: Color(0xFF4A00E0))
          : null,
    );
  }

  bool _tryRemoveAt(int index, BuildContext context) {
    final t = AppText.of(context);
    if (names.length <= 2) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(t.minTwoPlayersInGame)),
      );
      return false;
    }
    names.removeAt(index);
    avatars.removeAt(index);
    _onChanged();
    return true;
  }

  void _addPlayer(String normalizedName) {
    names.add(normalizedName);
    avatars.add(null);
    _onChanged();
  }

  Future<void> showRosterDialog(BuildContext context) async {
    final t = AppText.of(context);
    var newPlayerName = '';
    await showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (_, dialogSetState) {
            void submitAdd() {
              final name = newPlayerName.trim();
              if (name.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(t.enterPlayerName)),
                );
                return;
              }
              Navigator.of(dialogContext).pop();
              _addPlayer(name);
            }

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
                          for (var i = 0; i < names.length; i++)
                            Row(
                              children: [
                                buildAvatar(avatars[i]),
                                const SizedBox(width: 8),
                                Expanded(child: Text(names[i])),
                                WestIconButton(
                                  onPressed: () {
                                    if (_tryRemoveAt(i, context)) {
                                      dialogSetState(() {});
                                    }
                                  },
                                  icon: const Icon(
                                    Icons.remove_circle_outline,
                                  ),
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
                      newPlayerName = value;
                    },
                    onSubmitted: (_) => submitAdd(),
                  ),
                ],
              ),
              actions: [
                WestTextButton(
                  onPressed: () => Navigator.of(dialogContext).pop(),
                  child: Text(t.cancel),
                ),
                WestElevatedButton(
                  onPressed: submitAdd,
                  child: Text(t.addPlayer),
                ),
              ],
            );
          },
        );
      },
    );
  }
}

