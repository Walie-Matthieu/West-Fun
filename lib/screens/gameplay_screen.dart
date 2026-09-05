import 'package:flutter/material.dart';
import 'package:west_fun/widgets/west_buttons.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:west_fun/l10n/app_text.dart';
import 'package:west_fun/models/game_engine.dart';
import 'package:west_fun/models/game_models.dart';
import 'package:west_fun/screens/end_game_screen.dart';
import 'package:west_fun/widgets/app_gradient_background.dart';

class GameplayScreen extends StatefulWidget {
  const GameplayScreen({
    super.key,
    required this.playerNames,
    this.playerAvatars,
    required this.mode,
    required this.theme,
  });

  final List<String> playerNames;
  final List<Uint8List?>? playerAvatars;
  final GameMode mode;
  final PartyTheme theme;

  @override
  State<GameplayScreen> createState() => _GameplayScreenState();
}

class _WouldYouRatherOptionButton extends StatefulWidget {
  const _WouldYouRatherOptionButton({
    required this.label,
    required this.color,
    required this.size,
    required this.onPressed,
  });

  final String label;
  final Color color;
  final double size;
  final VoidCallback onPressed;

  @override
  State<_WouldYouRatherOptionButton> createState() =>
      _WouldYouRatherOptionButtonState();
}

class _WouldYouRatherOptionButtonState extends State<_WouldYouRatherOptionButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) {
        setState(() => _pressed = false);
        widget.onPressed();
      },
      onTapCancel: () => setState(() => _pressed = false),
      child: TweenAnimationBuilder<double>(
        tween: Tween<double>(end: _pressed ? 1 : 0),
        duration: const Duration(milliseconds: 120),
        curve: Curves.easeOutCubic,
        builder: (context, t, _) {
          final scale = 1 - (0.08 * t);

          return SizedBox(
            width: widget.size,
            height: widget.size,
            child: DecoratedBox(
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color.fromARGB(255, 9, 9, 9), // Couleur du socle des boutons
              ),
              child: Padding(
                padding: const EdgeInsets.all(6),
                child: DecoratedBox(
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color.fromARGB(255, 3, 3, 3), // Contour intérieur des boutons
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(4),
                    child: Transform.scale(
                      scale: scale,
                      alignment: Alignment.center,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: widget.color,
                        ),
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: Text(
                              widget.label,
                              textAlign: TextAlign.center,
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: Colors.black, // Couleur du texte des boutons
                                fontWeight: FontWeight.w700,
                                fontSize: 14,
                                height: 1.1,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _GameplayScreenState extends State<GameplayScreen> {
  static const LinearGradient _whoWouldPlatformGradient = LinearGradient(
    colors: [Color(0xFF2563EB), Color(0xFF0B1F4D)], // Mélange de couleurs pour le dégradé de la plateforme "Who Would"
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  late final GameEngine _engine;
  final ImagePicker _imagePicker = ImagePicker();
  int _agreeVotes = 0;
  int? _selectedWhoWouldPlayerIndex;
  String? _todQuestion;
  bool? _todIsTruth;

  Widget _buildAvatar(Uint8List? avatarBytes, {double radius = 16}) {
    return CircleAvatar(
      radius: radius,
      backgroundColor: const Color(0xFFEDE7F6),
      backgroundImage: avatarBytes != null ? MemoryImage(avatarBytes) : null,
      child: avatarBytes == null
          ? const Icon(Icons.tag_faces, size: 18, color: Color(0xFF4A00E0))
          : null,
    );
  }

  Future<Uint8List?> _pickAvatarBytes(ImageSource source) async {
    final t = AppText.of(context);
    try {
      final picked = await _imagePicker.pickImage(source: source);
      if (picked == null) {
        return null;
      }
      return picked.readAsBytes();
    } on PlatformException {
      if (!mounted) {
        return null;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(t.photoAccessFailed)),
      );
      return null;
    }
  }

  Future<void> _showAvatarOptions({
    required Uint8List? currentAvatar,
    required ValueChanged<Uint8List?> onAvatarChanged,
  }) async {
    final t = AppText.of(context);
    await showModalBottomSheet<void>(
      context: context,
      builder: (bottomSheetContext) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: Text(t.takePhoto),
                onTap: () async {
                  Navigator.of(bottomSheetContext).pop();
                  final bytes = await _pickAvatarBytes(ImageSource.camera);
                  if (bytes != null) {
                    onAvatarChanged(bytes);
                  }
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: Text(t.pickFromGallery),
                onTap: () async {
                  Navigator.of(bottomSheetContext).pop();
                  final bytes = await _pickAvatarBytes(ImageSource.gallery);
                  if (bytes != null) {
                    onAvatarChanged(bytes);
                  }
                },
              ),
              if (currentAvatar != null)
                ListTile(
                  leading: const Icon(Icons.delete_outline),
                  title: Text(t.removePhoto),
                  onTap: () {
                    Navigator.of(bottomSheetContext).pop();
                    onAvatarChanged(null);
                  },
                ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _openWhoWouldDialog() async {
    final t = AppText.of(context);
    var selectedIndex = _selectedWhoWouldPlayerIndex;

    final result = await showDialog<int>(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: Text(widget.mode.label),
              content: SizedBox(
                width: 320,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      for (final entry in _engine.players.asMap().entries)
                        CheckboxListTile(
                          value: selectedIndex == entry.key,
                          contentPadding: EdgeInsets.zero,
                          title: Text(entry.value.name),
                          secondary: _buildAvatar(entry.value.avatarBytes),
                          onChanged: (checked) {
                            setDialogState(() {
                              selectedIndex = checked == true ? entry.key : null;
                            });
                          },
                        ),
                    ],
                  ),
                ),
              ),
              actions: [
                WestElevatedButton(
                  onPressed: selectedIndex == null
                      ? null
                      : () {
                          Navigator.of(dialogContext).pop(selectedIndex);
                        },
                  child: Text(t.confirm),
                ),
              ],
            );
          },
        );
      },
    );

    if (result != null) {
      setState(() {
        _selectedWhoWouldPlayerIndex = result;
      });
    }
  }

  Future<void> _openParticipantsDialog() async {
    final t = AppText.of(context);
    final nameController = TextEditingController();
    Uint8List? newParticipantAvatar;
    String? participantsError;

    await showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (dialogStateContext, setDialogState) {
            return AlertDialog(
              title: Text(t.manageParticipants),
              content: SizedBox(
                width: 360,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      for (final entry in _engine.players.asMap().entries)
                        ListTile(
                          contentPadding: EdgeInsets.zero,
                          leading: WestIconButton(
                            disablePressedShadow: true,
                            tooltip: t.chooseProfilePhoto,
                            onPressed: () {
                              _showAvatarOptions(
                                currentAvatar: entry.value.avatarBytes,
                                onAvatarChanged: (avatarBytes) {
                                  setState(() {
                                    entry.value.avatarBytes = avatarBytes;
                                  });
                                  setDialogState(() {});
                                },
                              );
                            },
                            icon: _buildAvatar(entry.value.avatarBytes),
                          ),
                          title: Text(entry.value.name),
                          trailing: WestIconButton(
                            disablePressedShadow: true,
                            key: ValueKey('remove-participant-${entry.value.name}'),
                            onPressed: () {
                              final removedIndex = entry.key;
                              final removed = _engine.removeParticipantAt(removedIndex);
                              if (!removed) {
                                setDialogState(() {
                                  participantsError = t.minTwoPlayersInGame;
                                });
                                return;
                              }
                              if (_selectedWhoWouldPlayerIndex != null) {
                                if (_selectedWhoWouldPlayerIndex == removedIndex) {
                                  _selectedWhoWouldPlayerIndex = null;
                                } else if (_selectedWhoWouldPlayerIndex! > removedIndex) {
                                  _selectedWhoWouldPlayerIndex =
                                      _selectedWhoWouldPlayerIndex! - 1;
                                }
                              }
                              _agreeVotes = _agreeVotes.clamp(0, _engine.players.length - 1);
                              setDialogState(() {
                                participantsError = null;
                              });
                            },
                            icon: const Icon(Icons.remove_circle_outline),
                          ),
                        ),
                      if (participantsError != null) ...[
                        Text(
                          participantsError!,
                          style: const TextStyle(color: Colors.red),
                        ),
                        const SizedBox(height: 8),
                      ],
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          WestIconButton(
                            disablePressedShadow: true,
                            tooltip: t.chooseProfilePhoto,
                            onPressed: () {
                              _showAvatarOptions(
                                currentAvatar: newParticipantAvatar,
                                onAvatarChanged: (avatarBytes) {
                                  newParticipantAvatar = avatarBytes;
                                  setDialogState(() {});
                                },
                              );
                            },
                            icon: _buildAvatar(newParticipantAvatar),
                          ),
                          Expanded(
                            child: TextField(
                              controller: nameController,
                              decoration: InputDecoration(
                                labelText: t.playerName,
                                border: const OutlineInputBorder(),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      WestElevatedButton(
                        onPressed: () {
                          final name = nameController.text.trim();
                          if (name.isEmpty) {
                            return;
                          }
                          _engine.addParticipant(
                            name,
                            avatarBytes: newParticipantAvatar,
                          );
                          nameController.clear();
                          newParticipantAvatar = null;
                          setDialogState(() {
                            participantsError = null;
                          });
                        },
                        child: Text(t.addPlayer),
                      ),
                    ],
                  ),
                ),
              ),
              actions: [
                WestElevatedButton(
                  onPressed: () {
                    Navigator.of(dialogContext).pop();
                  },
                  child: Text(t.confirm),
                ),
              ],
            );
          },
        );
      },
    );

    if (!mounted) {
      return;
    }
    setState(() {});
  }

  Future<void> _openVoteDialog() async {
    if (widget.mode == GameMode.whoWould) {
      await _openWhoWouldDialog();
      return;
    }

    final t = AppText.of(context);
    final voterCount = _engine.players.length - 1;
    final otherPlayers = _engine.players
        .asMap()
        .entries
        .where((entry) => entry.key != _engine.activePlayerIndex)
        .toList();
    final initialVotes = _agreeVotes.clamp(0, voterCount);
    final selectedPlayerIndexes = <int>{
      for (var i = 0; i < initialVotes; i++) otherPlayers[i].key,
    };

    final result = await showDialog<int>(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: Text(t.voteDialogTitle),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    '${selectedPlayerIndexes.length} / $voterCount ${t.others}',
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: 320,
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          for (final entry in otherPlayers)
                            CheckboxListTile(
                              value: selectedPlayerIndexes.contains(entry.key),
                              contentPadding: EdgeInsets.zero,
                              title: Text(entry.value.name),
                              secondary: _buildAvatar(entry.value.avatarBytes),
                              onChanged: (checked) {
                                setDialogState(() {
                                  if (checked == true) {
                                    selectedPlayerIndexes.add(entry.key);
                                  } else {
                                    selectedPlayerIndexes.remove(entry.key);
                                  }
                                });
                              },
                            ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              actions: [
                WestElevatedButton(
                  onPressed: () {
                    Navigator.of(dialogContext).pop(selectedPlayerIndexes.length);
                  },
                  child: Text(t.confirm),
                ),
              ],
            );
          },
        );
      },
    );

    if (result != null) {
      setState(() {
        _agreeVotes = result;
      });
    }
  }

  void _pickTruthOrDare(bool isTruth) {
    setState(() {
      _todIsTruth = isTruth;
      _todQuestion = _engine.drawTruthOrDareQuestion(isTruth);
    });
  }

  void _completeTruthOrDareAndAdvance() {
    _engine.skipTurn();
    if (_engine.isFinished) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => EndGameScreen(
            players: _engine.ranking,
            replayPlayerNames: _engine.players.map((p) => p.name).toList(),
            replayPlayerAvatars: _engine.players.map((p) => p.avatarBytes).toList(),
          ),
        ),
      );
      return;
    }
    setState(() {
      _todQuestion = null;
      _todIsTruth = null;
    });
  }

  void _applyShesA10AndAdvance({required bool thumbsUp}) {
    _engine.applyShesA10Vote(thumbsUp: thumbsUp);
    if (_engine.isFinished) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => EndGameScreen(
            players: _engine.ranking,
            replayPlayerNames:
                _engine.players.map((p) => p.name).toList(),
            replayPlayerAvatars:
                _engine.players.map((p) => p.avatarBytes).toList(),
          ),
        ),
      );
      return;
    }
    setState(() {});
  }

  void _applyNeverHaveIEverAndAdvance({required bool hasDoneIt}) {
    _engine.applyNeverHaveIEverVote(hasDoneIt: hasDoneIt);
    if (_engine.isFinished) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => EndGameScreen(
            players: _engine.ranking,
            replayPlayerNames:
                _engine.players.map((p) => p.name).toList(),
            replayPlayerAvatars:
                _engine.players.map((p) => p.avatarBytes).toList(),
          ),
        ),
      );
      return;
    }
    setState(() {});
  }

  void _applyWouldYouRatherAndAdvance({required bool chooseRightOption}) {
    _engine.applyWouldYouRatherVote(chooseRightOption: chooseRightOption);
    if (_engine.isFinished) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => EndGameScreen(
            players: _engine.ranking,
            replayPlayerNames:
                _engine.players.map((p) => p.name).toList(),
            replayPlayerAvatars:
                _engine.players.map((p) => p.avatarBytes).toList(),
          ),
        ),
      );
      return;
    }
    setState(() {});
  }

  List<String> _wouldYouRatherOptions() {
    final question = _engine.currentQuestion;
    const prompt = 'Would you rather ';
    final trimmedQuestion = question.endsWith('?')
        ? question.substring(0, question.length - 1)
        : question;
    final coreQuestion = trimmedQuestion.startsWith(prompt)
        ? trimmedQuestion.substring(prompt.length)
        : trimmedQuestion;
    final splitIndex = coreQuestion.indexOf(' OR ');

    if (splitIndex == -1) {
      return const ['A', 'B'];
    }

    return [
      coreQuestion.substring(0, splitIndex).trim(),
      coreQuestion.substring(splitIndex + 4).trim(),
    ];
  }

  @override
  void initState() {
    super.initState();
    _engine = GameEngine(
      players: widget.playerNames.asMap().entries.map((entry) {
        final avatar = widget.playerAvatars != null &&
                entry.key < widget.playerAvatars!.length
            ? widget.playerAvatars![entry.key]
            : null;
        return Player(entry.value, avatarBytes: avatar);
      }).toList(),
      mode: widget.mode,
      theme: widget.theme,
    );
  }

  @override
  Widget build(BuildContext context) {
    final t = AppText.of(context);
    final voterCount = _engine.players.length - 1;
    final voteButtonLabel = widget.mode == GameMode.whoWould
        ? (_selectedWhoWouldPlayerIndex == null
              ? t.vote
              : '${t.vote} (${_engine.players[_selectedWhoWouldPlayerIndex!].name})')
        : '${t.vote} ($_agreeVotes/$voterCount)';
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.mode.label),
        actions: [
          WestIconButton(
            disablePressedShadow: true,
            onPressed: _openParticipantsDialog,
            icon: const Icon(Icons.more_vert),
          ),
        ],
      ),
      body: AppGradientBackground(
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 560),
                child: Container(
                  decoration: widget.mode == GameMode.whoWould
                      ? const BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(28)),
                          gradient: _whoWouldPlatformGradient,
                        )
                      : null,
                  child: Card(
                    color: widget.mode == GameMode.whoWould ? Colors.transparent : null,
                    elevation: widget.mode == GameMode.whoWould ? 0 : 14,
                    shadowColor: widget.mode == GameMode.whoWould
                        ? const Color.fromARGB(255, 13, 63, 179)
                        : null,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(28)),
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Align(
                          alignment: Alignment.centerRight,
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              color: const Color(0xFFEFE7FF),
                              borderRadius: BorderRadius.circular(999),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 4,
                              ),
                              child: Text(
                                '${_engine.remainingQuestions}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF4A00E0),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        if (widget.mode == GameMode.whoWould)
                          Stack(
                            alignment: Alignment.center,
                            children: [
                              Text(
                                widget.mode.label,
                                textAlign: TextAlign.center,
                                style: TextStyle(

                                  fontSize: 32, // Taille du texte du mode "Who Would" dans le jeu
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Nunito',
                                  letterSpacing: 1.2, 
                                  foreground: Paint()
                                    ..style = PaintingStyle.stroke
                                    ..strokeWidth = 5
                                    ..color = const Color.fromARGB(255, 42, 10, 130), // Couleur du contour du texte du mode "Who Would" dans le jeu
                                ),
                              ),
                              Text(
                                widget.mode.label,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontSize: 32,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Nunito',
                                  letterSpacing: 1.2,
                                  color: Color.fromARGB(255, 236, 234, 239), // Couleur du Titre du mode "Who Would" dans le jeu
                                ),
                              ),
                            ],
                          )
                        else
                          Text(
                            widget.mode.label,
                            textAlign: TextAlign.center,
                            style: Theme.of(context)
                                .textTheme
                                .headlineSmall
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                        Text(
                          widget.theme.label,
                          textAlign: TextAlign.center,
                          style: (widget.mode == GameMode.whoWould
                                  ? Theme.of(context).textTheme.bodyMedium?.copyWith(
                                      color: Colors.white70,
                                    )
                                  : Theme.of(context)
                                      .textTheme
                                      .bodyMedium
                                      ?.copyWith(color: Colors.black54)) ?? 
                              const TextStyle(),
                        ),
                        const SizedBox(height: 12), 
                        if (widget.mode != GameMode.whoWould &&
                            widget.mode != GameMode.truthOrDare)
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              _buildAvatar(_engine.activePlayer.avatarBytes, radius: 18),
                              const SizedBox(width: 8),
                              Text('${t.activePlayer}: ${_engine.activePlayer.name}'),
                            ],
                          ),
                        if (widget.mode == GameMode.truthOrDare) ...[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              _buildAvatar(_engine.activePlayer.avatarBytes, radius: 18),
                              const SizedBox(width: 8),
                              Text(_engine.activePlayer.name,
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium
                                      ?.copyWith(fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ],
                        const SizedBox(height: 24),
                        DecoratedBox(
                          decoration: BoxDecoration(
                            color: widget.mode == GameMode.whoWould
                                ? const Color.fromARGB(255, 6, 35, 102)
                                : (widget.mode == GameMode.truthOrDare && _todIsTruth != null
                                    ? (_todIsTruth!
                                       ? const Color(0xFFE3F2FD)
                                       : const Color(0xFFFCE4EC))
                                    : const Color(0xFFF5F0FF)),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 16,
                            ),
                            child: ConstrainedBox(
                              constraints: const BoxConstraints(minHeight: 170),
                              child: widget.mode == GameMode.wouldYouRather
                                  ? Center(
                                    child: (() {
                                       final options = _wouldYouRatherOptions();
                                       return Column(
                                         mainAxisSize: MainAxisSize.min,
                                         crossAxisAlignment: CrossAxisAlignment.center,
                                         children: [
                                           Text(
                                             options[0],
                                             textAlign: TextAlign.center,
                                             style: const TextStyle(
                                               color: Color.fromARGB(255, 12, 12, 12), // Couleur du choix A de "Would You Rather"
                                               fontSize: 20,
                                               fontWeight: FontWeight.w800,
                                             ),
                                           ),
                                           const SizedBox(height: 6),
                                           const Text(
                                             'OR', // Séparateur entre les deux choix de "Would You Rather"
                                             textAlign: TextAlign.center,
                                             style: TextStyle(
                                               color: Color.fromARGB(255, 12, 12, 12), // Couleur du séparateur "OR" de "Would You Rather"
                                               fontSize: 20,
                                               fontWeight: FontWeight.w900,
                                               letterSpacing: 1.2,
                                             ),
                                           ),
                                           const SizedBox(height: 6),
                                           Text(
                                             options[1],
                                             textAlign: TextAlign.center,
                                             style: const TextStyle(
                                               color: Color.fromARGB(255, 12, 12, 12), // Couleur du choix B de "Would You Rather"
                                               fontSize: 20,
                                               fontWeight: FontWeight.w800,
                                             ),
                                           ),
                                         ],
                                       );
                                    })(),
                                    )
                                  : Center(
                                      child: Text(
                                        _engine.currentQuestion,
                                        textAlign: TextAlign.center,
                                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                              height: 1.3,
                                              color: widget.mode == GameMode.whoWould
                                                  ? Colors.white
                                                  : Colors.black,
                                            ),
                                      ),
                                    ),
                            ),
                          ),
                        ),                        const SizedBox(height: 24),
                        if (widget.mode == GameMode.shesA10But)
                          Row(
                            children: [
                              Expanded(
                                child: SizedBox(
                                  height: 56,
                                  child: WestElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFFFFCDD2),
                                      foregroundColor: Colors.red[800],
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                    ),
                                    onPressed: () => _applyShesA10AndAdvance(thumbsUp: false),
                                    child: const Icon(Icons.thumb_down, size: 28),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: SizedBox(
                                  height: 56,
                                  child: WestElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFFC8E6C9),
                                      foregroundColor: Colors.green[800],
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                    ),
                                    onPressed: () => _applyShesA10AndAdvance(thumbsUp: true),
                                    child: const Icon(Icons.thumb_up, size: 28),
                                  ),
                                ),
                              ),
                            ],
                          )
                        else if (widget.mode == GameMode.neverHaveIEver)
                          Row(
                            children: [
                              Expanded(
                                child: SizedBox(
                                  height: 56,
                                  child: WestElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFFB3E5FC),
                                      foregroundColor: Colors.blue[800],
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                    ),
                                    onPressed: () => _applyNeverHaveIEverAndAdvance(hasDoneIt: false),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        const Text('\u{1F607}', style: TextStyle(fontSize: 22)),
                                        const SizedBox(width: 8),
                                        Text(t.never),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: SizedBox(
                                  height: 56,
                                  child: WestElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFFFFCDD2),
                                      foregroundColor: Colors.red[800],
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                    ),
                                    onPressed: () => _applyNeverHaveIEverAndAdvance(hasDoneIt: true),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        const Text('\u{1F608}', style: TextStyle(fontSize: 22)),
                                        const SizedBox(width: 8),
                                        Text(t.iHave),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          )
                        else if (widget.mode == GameMode.wouldYouRather)
                          Builder(
                            builder: (context) {
                              final options = _wouldYouRatherOptions();
                              return LayoutBuilder(
                                builder: (context, constraints) {
                                  final availableWidth = constraints.maxWidth.isFinite
                                      ? constraints.maxWidth
                                      : 326.0;
                                  final buttonGap = availableWidth > 340 ? 18.0 : 10.0;
                                  final buttonSize =
                                      ((availableWidth - buttonGap) / 2).clamp(96.0, 152.0).toDouble();

                                  return Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      _WouldYouRatherOptionButton(
                                        label: options[0],
                                        color: const Color(0xFFC62828), // Couleur bouton de gauche
                                        size: buttonSize,
                                        onPressed: () => _applyWouldYouRatherAndAdvance(
                                          chooseRightOption: false,
                                        ),
                                      ),
                                      SizedBox(width: buttonGap),
                                      _WouldYouRatherOptionButton(
                                        label: options[1],
                                        color: const Color(0xFF2E7D32), // Couleur bouton de droite
                                        size: buttonSize,
                                        onPressed: () => _applyWouldYouRatherAndAdvance(
                                          chooseRightOption: true,
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                          )
                        else if (widget.mode == GameMode.truthOrDare)
                          (_todQuestion == null
                              ? Row(
                                  children: [
                                    Expanded(
                                      child: SizedBox(
                                        height: 52,
                                        child: WestElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: const Color(0xFF1565C0),
                                            foregroundColor: Colors.white,
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(16),
                                            ),
                                          ),
                                          onPressed: () => _pickTruthOrDare(true),
                                          child: Text(t.truth,
                                              style: const TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold)),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    Expanded(
                                      child: SizedBox(
                                        height: 52,
                                        child: WestElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: const Color(0xFFC62828),
                                            foregroundColor: Colors.white,
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(16),
                                            ),
                                          ),
                                          onPressed: () => _pickTruthOrDare(false),
                                          child: Text(t.dare,
                                              style: const TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold)),
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                              : SizedBox(
                                  height: 52,
                                  width: double.infinity,
                                  child: WestElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                    ),
                                    onPressed: _completeTruthOrDareAndAdvance,
                                    child: Text(t.next),
                                  ),
                                ))
                        else if (widget.mode == GameMode.whoWould)
                          Row(
                            children: [
                              Expanded(
                                child: SizedBox(
                                  height: 42,
                                  child: WestElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color.fromARGB(255, 6, 35, 102), // Bouton de vote pour le mode "Who Would"
                                      foregroundColor: Colors.white,
                                      padding: const EdgeInsets.symmetric(vertical: 10),
                                      textStyle: Theme.of(context).textTheme.titleSmall,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                    ),
                                    onPressed: _openWhoWouldDialog,
                                    child: Text(voteButtonLabel),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: SizedBox(
                                  height: 42,
                                  child: WestElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color.fromARGB(255, 6, 35, 102), // Couleur du bouton "Next" pour le mode "Who Would"
                                      foregroundColor: Colors.white, // Couleur du texte du bouton "Next" pour le mode "Who Would"
                                      padding: const EdgeInsets.symmetric(vertical: 10),
                                      textStyle: Theme.of(context).textTheme.titleSmall,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                    ),
                                    onPressed: () {
                                      if (_selectedWhoWouldPlayerIndex != null) {
                                        _engine.applyWhoWouldVote(
                                          selectedPlayerIndex: _selectedWhoWouldPlayerIndex!,
                                        );
                                      } else {
                                        _engine.skipTurn();
                                      }
                                      if (_engine.isFinished) {
                                        Navigator.of(context).pushReplacement(
                                          MaterialPageRoute(
                                            builder: (_) => EndGameScreen(
                                              players: _engine.ranking,
                                              replayPlayerNames: _engine.players
                                                  .map((player) => player.name)
                                                  .toList(),
                                              replayPlayerAvatars: _engine.players
                                                  .map((player) => player.avatarBytes)
                                                  .toList(),
                                            ),
                                          ),
                                        );
                                        return;
                                      }
                                      setState(() {
                                        _agreeVotes = 0;
                                        _selectedWhoWouldPlayerIndex = null;
                                      });
                                    },
                                    child: Text(t.next),
                                  ),
                                ),
                              ),
                            ],
                          )
                        else
                          Row(
                          children: [
                            Expanded(
                              child: SizedBox(
                                height: 42,
                                child: WestElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(vertical: 10),
                                    textStyle: Theme.of(context).textTheme.titleSmall,
                                  ),
                                  onPressed: _openVoteDialog,
                                  child: Text(voteButtonLabel),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: SizedBox(
                                height: 42,
                                child: WestElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(vertical: 10),
                                    textStyle: Theme.of(context).textTheme.titleSmall,
                                  ),
                                  onPressed: () {
                                    if (widget.mode == GameMode.whoWould) {
                                      if (_selectedWhoWouldPlayerIndex != null) {
                                        _engine.applyWhoWouldVote(
                                          selectedPlayerIndex: _selectedWhoWouldPlayerIndex!,
                                        );
                                      } else {
                                        _engine.skipTurn();
                                      }
                                    } else {
                                      _engine.applyVote(
                                          agreeVotes: _agreeVotes,
                                          voterCount: voterCount);
                                    }
                                    if (_engine.isFinished) {
                                      Navigator.of(context).pushReplacement(
                                        MaterialPageRoute(
                                          builder: (_) => EndGameScreen(
                                            players: _engine.ranking,
                                            replayPlayerNames: _engine.players
                                                .map((player) => player.name)
                                                .toList(),
                                            replayPlayerAvatars: _engine.players
                                                .map((player) => player.avatarBytes)
                                                .toList(),
                                          ),
                                        ),
                                      );
                                      return;
                                    }
                                    setState(() {
                                      _agreeVotes = 0;
                                      _selectedWhoWouldPlayerIndex = null;
                                    });
                                  },
                                  child: Text(t.next),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          ),
        ),
      ),
    );
  }
}







