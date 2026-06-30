import 'package:flutter/material.dart';
import 'package:west_fun/l10n/app_text.dart';
import 'package:west_fun/screens/theme_selection_screen.dart';

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
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF8E2DE2), Color(0xFF4A00E0)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: _controllers.length,
                  itemBuilder: (context, index) {
                    return Padding(
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
                        ),
                      ),
                    );
                  },
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _controllers.add(TextEditingController());
                        });
                      },
                      child: Text(t.addPlayer),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: ElevatedButton(
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
                      child: Text(t.start),
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
