import 'package:flutter/material.dart';
import 'package:west_fun/l10n/app_text.dart';
import 'package:west_fun/screens/theme_selection_screen.dart';
import 'package:west_fun/widgets/app_gradient_background.dart';

class PlayerSetupScreen extends StatefulWidget {
  const PlayerSetupScreen({super.key});

  @override
  State<PlayerSetupScreen> createState() => _PlayerSetupScreenState();
}

class _PlayerSetupScreenState extends State<PlayerSetupScreen> {
  final List<TextEditingController> _controllers = [
    TextEditingController(),
    TextEditingController(),
  ];

  void _removePlayerAt(int index) {
    final controller = _controllers.removeAt(index);
    controller.dispose();
    if (_controllers.isEmpty) {
      _controllers.add(TextEditingController());
    }
  }

  Widget _buildStyledActionButton({
    required String label,
    required VoidCallback onPressed,
  }) {
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(999),
        boxShadow: const [
          BoxShadow(
            color: Color(0x66000000),
            blurRadius: 18,
            offset: Offset(0, 10),
          ),
          BoxShadow(
            color: Color(0x33FFFFFF),
            blurRadius: 6,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          elevation: 10,
          shadowColor: Colors.black45,
          backgroundColor: Colors.white,
          foregroundColor: const Color(0xFF4A00E0),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          textStyle: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(999),
          ),
        ),
        onPressed: onPressed,
        child: Text(label),
      ),
    );
  }

  @override
  void dispose() {
    for (final controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final t = AppText.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(t.players)),
      body: AppGradientBackground(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: _controllers.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      key: ValueKey(_controllers[index]),
                      padding: const EdgeInsets.only(bottom: 12),
                      child: TextField(
                        controller: _controllers[index],
                        decoration: InputDecoration(
                          labelText: '${t.player} ${index + 1}',
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(999),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(999),
                            borderSide: BorderSide.none,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(999),
                            borderSide: const BorderSide(
                              color: Color(0xFF4A00E0),
                              width: 2,
                            ),
                          ),
                          suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                _removePlayerAt(index);
                              });
                            },
                            icon: const Text(
                              '-',
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF4A00E0),
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: _buildStyledActionButton(
                      label: t.addPlayer,
                      onPressed: () {
                        setState(() {
                          _controllers.add(TextEditingController());
                        });
                      },
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _buildStyledActionButton(
                      label: t.start,
                      onPressed: () {
                        final names = _controllers
                            .map((controller) => controller.text.trim())
                            .where((name) => name.isNotEmpty)
                            .toList();
                        if (names.length < 2) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(t.minTwoPlayers)),
                          );
                          return;
                        }
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => ThemeSelectionScreen(playerNames: names),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
