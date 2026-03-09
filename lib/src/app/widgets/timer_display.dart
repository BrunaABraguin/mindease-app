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
    required this.onSetValue,
    required this.showAnimations,
  });
  final TimerEntity timer;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;
  final bool isRunning;
  final void Function(String value) onSetValue;
  final bool showAnimations;

  @override
  State<TimerDisplay> createState() => _TimerDisplayState();
}

class _TimerDisplayState extends State<TimerDisplay>
    with SingleTickerProviderStateMixin {
  bool _editing = false;
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  late final AnimationController _blinkController;

  @override
  void initState() {
    super.initState();
    _blinkController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _updateBlinking();
    _focusNode.addListener(_onFocusChange);
  }

  void _onFocusChange() {
    if (!_focusNode.hasFocus && _editing) {
      _saveInput();
    }
  }

  @override
  void didUpdateWidget(covariant TimerDisplay oldWidget) {
    super.didUpdateWidget(oldWidget);
    _updateBlinking();
  }

  bool get _isZero {
    return widget.timer.remainingSeconds == null ||
        widget.timer.remainingSeconds! <= 0;
  }

  void _updateBlinking() {
    if (_isZero && widget.showAnimations) {
      if (!_blinkController.isAnimating) {
        _blinkController.repeat(reverse: true);
      }
    } else if (_blinkController.isAnimating) {
      _blinkController.stop();
      _blinkController.value = 1.0;
    }
  }

  @override
  void dispose() {
    _blinkController.dispose();
    _controller.dispose();
    _focusNode.dispose();
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

  TextStyle _timerTextStyle(BuildContext context) {
    final theme = Theme.of(context);
    final screenWidth = MediaQuery.of(context).size.width;
    double fontSize = AppSizes.timerFontSize;
    if (screenWidth < AppSizes.breakpointMobile) {
      fontSize = 40;
    } else if (screenWidth < AppSizes.breakpointTablet) {
      fontSize = 60;
    }
    return theme.textTheme.displayLarge?.copyWith(
          fontWeight: FontWeight.bold,
          color: theme.colorScheme.inverseSurface,
          fontSize: fontSize,
        ) ??
        TextStyle(
          fontWeight: FontWeight.bold,
          color: theme.colorScheme.inverseSurface,
          fontSize: fontSize,
        );
  }

  void _startEditing() {
    setState(() {
      _editing = true;
      final secs = widget.timer.remainingSeconds ?? 0;
      final min = (secs ~/ 60).toString().padLeft(2, '0');
      final sec = (secs % 60).toString().padLeft(2, '0');
      _controller.text = "$min:$sec";
      _focusNode.requestFocus();
      _controller.selection = TextSelection(
        baseOffset: 0,
        extentOffset: _controller.text.length,
      );
    });
  }

  void _saveInput() {
    final text = _controller.text.trim();
    widget.onSetValue(text);
    setState(() {
      _editing = false;
    });
  }

  // Timer boundaries as static constants
  static const int timerMinSeconds = 0;
  static const int timerMaxMinutes = 60; // Maximum of 60 minutes
  static const int timerMaxSeconds =
      timerMaxMinutes * Duration.secondsPerMinute;

  @override
  Widget build(BuildContext context) {
    final isZero =
        widget.timer.remainingSeconds == null ||
        widget.timer.remainingSeconds! <= timerMinSeconds;
    final isMax =
        widget.timer.remainingSeconds != null &&
        widget.timer.remainingSeconds! >= timerMaxSeconds;
    final screenWidth = MediaQuery.of(context).size.width;
    double iconSize = AppSizes.iconMedium;
    double spacing = AppSizes.spacingL;
    double textFieldWidth = AppSizes.buttonMinWidthMedium;
    if (screenWidth < AppSizes.breakpointMobile) {
      iconSize = 32;
      spacing = 8;
      textFieldWidth = 80;
    } else if (screenWidth < AppSizes.breakpointTablet) {
      iconSize = 40;
      spacing = 16;
      textFieldWidth = 100;
    }
    return Center(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Semantics(
            label: 'Diminuir tempo',
            button: true,
            child: IconButton(
              icon: Icon(Icons.remove_circle, size: iconSize),
              onPressed: widget.isRunning || isZero ? null : widget.onDecrement,
              tooltip: 'Diminuir tempo',
            ),
          ),
          SizedBox(width: spacing),
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
                  child: GestureDetector(
                    onDoubleTap: widget.isRunning ? null : _startEditing,
                    child: _editing
                        ? SizedBox(
                            width: textFieldWidth,
                            child: TextField(
                              controller: _controller,
                              focusNode: _focusNode,
                              onSubmitted: (_) => _saveInput(),
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                isDense: true,
                                contentPadding: EdgeInsets.symmetric(
                                  vertical: AppSizes.spacingXs,
                                  horizontal: AppSizes.spacingXs,
                                ),
                              ),
                              style: _timerTextStyle(context),
                              keyboardType: TextInputType.number,
                              textAlign: TextAlign.center,
                            ),
                          )
                        : Text(
                            _formatDuration(widget.timer.remainingSeconds),
                            style: _timerTextStyle(context),
                          ),
                  ),
                );
              },
            ),
          ),
          SizedBox(width: spacing),
          Semantics(
            label: 'Aumentar tempo',
            button: true,
            child: IconButton(
              icon: Icon(Icons.add_circle, size: iconSize),
              onPressed: widget.isRunning || isMax ? null : widget.onIncrement,
              tooltip: 'Aumentar tempo',
            ),
          ),
        ],
      ),
    );
  }
}
