import 'package:flutter/material.dart';
import 'package:mindease_app/src/app/utils/app_sizes.dart';
import 'package:mindease_app/src/app/widgets/cycle_completed_message.dart';

class SettingsSessions extends StatelessWidget {
  const SettingsSessions({
    super.key,
    required this.currentCycle,
    required this.totalCycles,
    required this.isRunning,
    required this.onIncrement,
    required this.onDecrement,
    required this.iconColor,
    this.showCompletedMessage = false,
  });
  final int currentCycle;
  final int totalCycles;
  final bool isRunning;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;
  final Color iconColor;
  final bool showCompletedMessage;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.auto_awesome,
              color: iconColor,
              size: AppSizes.iconSmall,
            ),
            const SizedBox(width: AppSizes.spacingXs),
            IconButton(
              icon: const Icon(Icons.remove_circle_outline),
              color: iconColor,
              onPressed: (isRunning || totalCycles <= 1)
                  ? null
                  : onDecrement,
            ),
            Text(
              '$currentCycle/$totalCycles',
              style: TextStyle(
                color: iconColor,
                fontWeight: FontWeight.bold,
                fontSize: AppSizes.cycleFontSize,
              ),
            ),
            IconButton(
              icon: const Icon(Icons.add_circle_outline),
              color: iconColor,
              onPressed: (isRunning || totalCycles >= 10)
                  ? null
                  : onIncrement,
            ),
            const SizedBox(width: AppSizes.spacingXs),
            Icon(
              Icons.auto_awesome,
              color: iconColor,
              size: AppSizes.iconSmall,
            ),
          ],
        ),
        if (showCompletedMessage) const CycleCompletedMessage(),
      ],
    );
  }
}
