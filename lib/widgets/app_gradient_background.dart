import 'package:flutter/material.dart';

class AppGradientBackground extends StatelessWidget {
  const AppGradientBackground({super.key, required this.child});

  final Widget child;

  static const LinearGradient gradient = LinearGradient(
    colors: [Color(0xFF8E2DE2), Color(0xFF4A00E0)], // Couleur du dégradé de fond de l'app
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(gradient: gradient),
      child: child,
    );
  }
}
