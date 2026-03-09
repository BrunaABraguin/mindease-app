import 'package:flutter/material.dart';

import 'package:mindease_app/src/app/utils/app_constants.dart';

class StartPauseButton extends StatelessWidget {
  const StartPauseButton({
    super.key,
    required this.isRunning,
    required this.onPressed,
  });

  final bool isRunning;
  final VoidCallback onPressed;

  String get _label => isRunning ? AppStrings.pause : AppStrings.start;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: _label,
      button: true,
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
        ),
        child: IconButton(
          icon: Icon(
            isRunning ? Icons.pause : Icons.play_arrow,
            color: Colors.black87,
            size: AppSizes.iconMedium,
          ),
          onPressed: onPressed,
          tooltip: _label,
        ),
      ),
    );
  }
}
