import 'package:flutter/material.dart';
import 'package:mindease_app/src/app/utils/app_constants.dart';

/// Linha de progresso personalizada para o timer
class VerticalTimerProgress extends StatelessWidget {
  const VerticalTimerProgress({
    super.key,
    required this.totalSeconds,
    required this.remainingSeconds,
    this.height = 8,
    this.width,
    this.bottomMargin = 0,
  });

  final int totalSeconds;
  final int remainingSeconds;
  final double height;
  final double? width;
  final double bottomMargin;

  @override
  Widget build(BuildContext context) {
    final Color lineColor = Theme.of(context).colorScheme.secondary;
    final double progress = totalSeconds > 0
        ? 1.0 - (remainingSeconds.clamp(0, totalSeconds) / totalSeconds)
        : 0.0;
    final double progressLineWidth =
        width ?? MediaQuery.of(context).size.width * 0.5;

    return Container(
      width: progressLineWidth,
      margin: EdgeInsets.only(bottom: bottomMargin),
      child: LinearProgressIndicator(
        value: progress,
        backgroundColor: lineColor.withValues(alpha: AppOpacity.heavy),
        valueColor: AlwaysStoppedAnimation<Color>(lineColor),
        minHeight: height,
        borderRadius: BorderRadius.circular(height / 2),
      ),
    );
  }
}
