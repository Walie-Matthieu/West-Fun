import 'package:flutter/material.dart';
import 'package:west_fun/l10n/app_text.dart';
import 'package:west_fun/models/game_engine.dart';
import 'package:west_fun/models/game_models.dart';
import 'package:west_fun/screens/end_game_screen.dart';
import 'package:west_fun/widgets/app_gradient_background.dart';

class GameplayScreen extends StatefulWidget {
  const GameplayScreen({
    super.key,
    required this.playerNames,
    required this.mode,
    required this.theme,
  });

  final List<String> playerNames;
  final GameMode mode;
  final PartyTheme theme;

  @override
  State<GameplayScreen> createState() => _GameplayScreenState();
}

class _GameplayScreenState extends State<GameplayScreen> {
  late final GameEngine _engine;
  int _agreeVotes = 0;
  int? _selectedWhoWouldPlayerIndex;

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
                ElevatedButton(
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
                ElevatedButton(
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

  @override
  void initState() {
    super.initState();
    _engine = GameEngine(
      players: widget.playerNames.map((name) => Player(name)).toList(),
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
      appBar: AppBar(title: Text(widget.mode.label)),
      body: AppGradientBackground(
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 560),
                child: Card(
                  elevation: 14,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(28)),
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          widget.mode.label,
                          textAlign: TextAlign.center,
                          style: Theme.of(context)
                              .textTheme
                              .headlineSmall
                              ?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          widget.theme.label,
                          textAlign: TextAlign.center,
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: Colors.black54,
                                  ),
                        ),
                        const SizedBox(height: 24),
                        DecoratedBox(
                          decoration: BoxDecoration(
                            color: const Color(0xFFF5F0FF),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 28,
                            ),
                            child: ConstrainedBox(
                              constraints: const BoxConstraints(minHeight: 170),
                              child: Center(
                                child: Text(
                                  _engine.currentQuestion,
                                  textAlign: TextAlign.center,
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleLarge
                                      ?.copyWith(
                                        height: 1.3,
                                      ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                        Row(
                          children: [
                            Expanded(
                              child: SizedBox(
                                height: 42,
                                child: ElevatedButton(
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
                                child: ElevatedButton(
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
                                          builder: (_) =>
                                              EndGameScreen(players: _engine.ranking),
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
    );
  }
}
