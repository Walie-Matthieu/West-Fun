import 'package:flutter/material.dart';
import 'package:west_fun/widgets/west_buttons.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:west_fun/l10n/app_text.dart';
import 'package:west_fun/screens/mode_selection_screen.dart';
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
  final List<Uint8List?> _playerAvatars = [null, null];
  final ImagePicker _imagePicker = ImagePicker();

  void _removePlayerAt(int index) {
    final controller = _controllers.removeAt(index);
    controller.dispose();
    _playerAvatars.removeAt(index);
    if (_controllers.isEmpty) {
      _controllers.add(TextEditingController());
      _playerAvatars.add(null);
    }
  }

  Future<void> _pickPlayerAvatar(int index, ImageSource source) async {
    final t = AppText.of(context);
    try {
      final photo = await _imagePicker.pickImage(source: source);
      if (photo == null) {
        return;
      }
      final bytes = await photo.readAsBytes();
      if (!mounted) {
        return;
      }
      setState(() {
        _playerAvatars[index] = bytes;
      });
    } on PlatformException {
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(t.photoAccessFailed)),
      );
    }
  }

  Future<void> _showAvatarOptions(int index) async {
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
                onTap: () {
                  Navigator.of(bottomSheetContext).pop();
                  _pickPlayerAvatar(index, ImageSource.camera);
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: Text(t.pickFromGallery),
                onTap: () {
                  Navigator.of(bottomSheetContext).pop();
                  _pickPlayerAvatar(index, ImageSource.gallery);
                },
              ),
              if (_playerAvatars[index] != null)
                ListTile(
                  leading: const Icon(Icons.delete_outline),
                  title: Text(t.removePhoto),
                  onTap: () {
                    Navigator.of(bottomSheetContext).pop();
                    setState(() {
                      _playerAvatars[index] = null;
                    });
                  },
                ),
            ],
          ),
        );
      },
    );
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
      child: WestElevatedButton(
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
                        textAlign: TextAlign.center,
                        decoration: InputDecoration(
                          hintText: '${t.player} ${index + 1}',
                          hintStyle: const TextStyle(color: Colors.black54),
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
                          prefixIcon: WestIconButton(
                            disablePressedShadow: true,
                            tooltip: t.chooseProfilePhoto,
                            onPressed: () => _showAvatarOptions(index),
                            icon: CircleAvatar(
                              backgroundColor: const Color(0xFFEDE7F6),
                              backgroundImage: _playerAvatars[index] != null
                                  ? MemoryImage(_playerAvatars[index]!)
                                  : null,
                              child: _playerAvatars[index] == null
                                  ? const Icon(
                                      Icons.tag_faces,
                                      color: Color(0xFF4A00E0),
                                    )
                                  : null,
                            ),
                          ),
                          suffixIcon: WestIconButton(
                            disablePressedShadow: true,
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
                          _playerAvatars.add(null);
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
                            builder: (_) {
                              final avatars = _controllers
                                  .asMap()
                                  .entries
                                  .where((entry) => entry.value.text.trim().isNotEmpty)
                                  .map((entry) => _playerAvatars[entry.key])
                                  .toList();
                              return ModeSelectionScreen(
                                playerNames: names,
                                playerAvatars: avatars,
                              );
                            },
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



