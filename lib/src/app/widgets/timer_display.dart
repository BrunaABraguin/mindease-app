import 'package:flutter/material.dart';
import 'package:mindease_app/src/app/utils/app_constants.dart';
import 'package:mindease_app/src/app/utils/time_formatter.dart';
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
  static const int timerMinSeconds = 0;

  bool _editing = false;
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  late final AnimationController _blinkController;

  @override
  void initState() {
    super.initState();
    _blinkController = AnimationController(
      vsync: this,
      duration: const Duration(
        milliseconds: AppConstants.blinkAnimationDurationMs,
      ),
    );
    _focusNode.addListener(_onFocusChange);
    _updateBlinking();
  }

  @override
  void didUpdateWidget(covariant TimerDisplay oldWidget) {
    super.didUpdateWidget(oldWidget);
    _updateBlinking();
  }

  @override
  void dispose() {
    _blinkController.dispose();
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _onFocusChange() {
    if (!_focusNode.hasFocus && _editing) {
      _saveInput();
    }
  }

  void _startEditing() {
    setState(() {
      _editing = true;
      _controller.text = formatDuration(widget.timer.remainingSeconds);
      _focusNode.requestFocus();
      _controller.selection = TextSelection(
        baseOffset: 0,
        extentOffset: _controller.text.length,
      );
    });
  }

  void _saveInput() {
    widget.onSetValue(_controller.text.trim());
    setState(() => _editing = false);
  }

  bool get _isZero =>
      widget.timer.remainingSeconds == null ||
      widget.timer.remainingSeconds! <= timerMinSeconds;

  bool get _isMax =>
      widget.timer.remainingSeconds != null &&
      widget.timer.remainingSeconds! >= AppConstants.timerMaxSeconds;

  bool get _shouldBlink => _isZero && widget.showAnimations;

  void _updateBlinking() {
    if (_shouldBlink) {
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

  TextStyle _timerTextStyle(BuildContext context) {
    final theme = Theme.of(context);
    final screenWidth = MediaQuery.of(context).size.width;
    double fontSize = AppSizes.timerFontSize;
    if (screenWidth < AppSizes.breakpointMobile) {
      fontSize = AppSizes.timerFontSizeMobile;
    } else if (screenWidth < AppSizes.breakpointTablet) {
      fontSize = AppSizes.timerFontSizeTablet;
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

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    double iconSize = AppSizes.iconMedium;
    double spacing = AppSizes.spacingL;
    double textFieldWidth = AppSizes.buttonMinWidthMedium;
    if (screenWidth < AppSizes.breakpointMobile) {
      iconSize = AppSizes.timerIconSizeMobile;
      spacing = AppSizes.spacingXs;
      textFieldWidth = AppSizes.buttonMinWidthSmall;
    } else if (screenWidth < AppSizes.breakpointTablet) {
      iconSize = AppSizes.timerIconSizeTablet;
      spacing = AppSizes.spacingM;
      textFieldWidth = AppSizes.timerTextFieldWidthTablet;
    }

    return Center(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildIconButton(
            icon: Icons.remove_circle,
            size: iconSize,
            label: AppStrings.decreaseTime,
            onPressed: widget.isRunning || _isZero ? null : widget.onDecrement,
          ),
          SizedBox(width: spacing),
          Flexible(
            child: AnimatedBuilder(
              animation: _blinkController,
              builder: (context, child) {
                final blinkOpacity =
                    _blinkController.value < AppConstants.blinkThreshold
                        ? AppConstants.blinkMinOpacity
                        : 1.0;
                return Opacity(
                  opacity: _shouldBlink ? blinkOpacity : 1.0,
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
                            formatDuration(widget.timer.remainingSeconds),
                            style: _timerTextStyle(context),
                          ),
                  ),
                );
              },
            ),
          ),
          SizedBox(width: spacing),
          _buildIconButton(
            icon: Icons.add_circle,
            size: iconSize,
            label: AppStrings.increaseTime,
            onPressed: widget.isRunning || _isMax ? null : widget.onIncrement,
          ),
        ],
      ),
    );
  }

  Widget _buildIconButton({
    required IconData icon,
    required double size,
    required String label,
    required VoidCallback? onPressed,
  }) {
    return Semantics(
      label: label,
      button: true,
      child: IconButton(
        icon: Icon(icon, size: size),
        onPressed: onPressed,
        tooltip: label,
      ),
    );
  }
}
