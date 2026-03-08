import 'package:flutter/material.dart';

class FocusModeButton extends StatelessWidget {
  const FocusModeButton({
    super.key,
    required this.onPressed,
    this.exit = false,
    this.size = 24,
  });

  final VoidCallback onPressed;
  final bool exit;
  final double size;

  String get label => exit ? 'Sair do modo foco' : 'Entrar no modo foco';

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: label,
      button: true,
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary,
          shape: BoxShape.circle,
        ),
        child: IconButton(
          icon: Icon(
            exit ? Icons.fullscreen_exit : Icons.fullscreen,
            color: Theme.of(context).primaryIconTheme.color,
            size: size,
          ),
          tooltip: label,
          onPressed: onPressed,
        ),
      ),
    );
  }
}
