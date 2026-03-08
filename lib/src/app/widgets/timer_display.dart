import 'package:flutter/material.dart';
import 'package:mindease_app/src/domain/entities/timer_entity.dart';

class TimerDisplay extends StatelessWidget {
  const TimerDisplay({super.key, required this.timer});
  final TimerEntity timer;

  static const int focusModeIndex = 0;
  static const int breakModeIndex = 1;
  static const int longBreakModeIndex = 2;

  int _getDefaultSeconds() {
    if (timer.currentModeIndex == breakModeIndex) {
      return timer.durations.shortBreak;
    } else if (timer.currentModeIndex == longBreakModeIndex) {
      return timer.durations.longBreak;
    }
    return timer.durations.focus;
  }

  String _formatDuration(int? seconds) {
    final int effectiveSeconds;
    if (seconds == null || seconds <= 0) {
      effectiveSeconds = _getDefaultSeconds();
    } else {
      effectiveSeconds = seconds;
    }
    final minutes = (effectiveSeconds ~/ 60).toString().padLeft(2, '0');
    final secs = (effectiveSeconds % 60).toString().padLeft(2, '0');
    return '$minutes:$secs';
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        _formatDuration(timer.remainingSeconds),
        style: Theme.of(context).textTheme.displayLarge?.copyWith(
          fontWeight: FontWeight.bold,
          color: Theme.of(context).colorScheme.inverseSurface,
        ),
      ),
    );
  }
}
