import 'package:flutter/material.dart';
import 'package:mindease_app/src/app/utils/app_constants.dart';
import 'package:mindease_app/src/domain/entities/timer_entity.dart';

class TimerDisplay extends StatefulWidget {
  const TimerDisplay({
    super.key,
    required this.timer,
    required this.onIncrement,
    required this.onDecrement,
    required this.isRunning,
  });
  final TimerEntity timer;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;
  final bool isRunning;

  @override
  State<TimerDisplay> createState() => _TimerDisplayState();
}

class _TimerDisplayState extends State<TimerDisplay>
    with SingleTickerProviderStateMixin {
  late final AnimationController _blinkController;

  @override
  void initState() {
    super.initState();
    _blinkController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _updateBlinking();
  }

  @override
  void didUpdateWidget(covariant TimerDisplay oldWidget) {
    super.didUpdateWidget(oldWidget);
    _updateBlinking();
  }

  void _updateBlinking() {
    final isZero =
        widget.timer.remainingSeconds == null ||
        widget.timer.remainingSeconds! <= 0;
    if (isZero) {
      if (!_blinkController.isAnimating) {
        _blinkController.repeat(reverse: true);
      }
    } else {
      if (_blinkController.isAnimating) {
        _blinkController.stop();
        _blinkController.value = 1.0;
      }
    }
  }

  @override
  void dispose() {
    _blinkController.dispose();
    super.dispose();
  }

  String _formatDuration(int? seconds) {
    if (seconds == null || seconds <= 0) {
      return '00:00';
    }
    final minutes = (seconds ~/ 60).toString().padLeft(2, '0');
    final secs = (seconds % 60).toString().padLeft(2, '0');
    return '$minutes:$secs';
  }

  @override
  Widget build(BuildContext context) {
    final isZero =
        widget.timer.remainingSeconds == null ||
        widget.timer.remainingSeconds! <= 0;
    return Center(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Semantics(
            label: 'Diminuir tempo',
            button: true,
            child: IconButton(
              icon: const Icon(Icons.remove),
              onPressed: widget.isRunning ? null : widget.onDecrement,
              tooltip: 'Diminuir tempo',
            ),
          ),
          const SizedBox(width: AppSizes.spacingL),
          Flexible(
            child: AnimatedBuilder(
              animation: _blinkController,
              builder: (context, child) {
                return Opacity(
                  opacity: isZero
                      ? (_blinkController.value < AppConstants.blinkThreshold
                            ? AppConstants.blinkMinOpacity
                            : 1.0)
                      : 1.0,
                  child: Text(
                    _formatDuration(widget.timer.remainingSeconds),
                    style:
                        Theme.of(context).textTheme.displayLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.inverseSurface,
                          fontSize: AppSizes.timerFontSize,
                        ) ??
                        TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.inverseSurface,
                          fontSize: AppSizes.timerFontSize,
                        ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(width: AppSizes.spacingL),
          Semantics(
            label: 'Aumentar tempo',
            button: true,
            child: IconButton(
              icon: const Icon(Icons.add),
              onPressed: widget.isRunning ? null : widget.onIncrement,
              tooltip: 'Aumentar tempo',
            ),
          ),
        ],
      ),
    );
  }
}
