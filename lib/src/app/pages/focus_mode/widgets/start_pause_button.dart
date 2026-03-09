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

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return IconButton(
      icon: Icon(
        isRunning ? Icons.pause : Icons.play_arrow,
        size: AppSizes.iconLarge,
        color: Colors.white,
      ),
      tooltip: isRunning ? AppStrings.pause : AppStrings.start,
      onPressed: onPressed,
      style: IconButton.styleFrom(
        backgroundColor: colorScheme.secondary,
        shape: const CircleBorder(),
      ),
    );
  }
}
