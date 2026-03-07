import 'package:flutter/material.dart';
import 'package:mindease_app/src/app/utils/app_constants.dart';

class TimerSegmentedButton extends StatefulWidget {
  const TimerSegmentedButton({
    super.key,
    required this.selectedIndex,
    required this.onChanged,
  });
  final int selectedIndex;
  final ValueChanged<int> onChanged;

  @override
  State<TimerSegmentedButton> createState() => _TimerSegmentedButtonState();
}

class _TimerSegmentedButtonState extends State<TimerSegmentedButton> {
  final List<String> _timerOptions = ['Foco', 'Pausa curta', 'Pausa longa'];
  final List<IconData> _timerIcons = [
    AppIcons.timer, // Foco
    Icons.coffee, // Pausa curta
    Icons.hotel, // Pausa longa
  ];

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return SegmentedButton<int>(
      segments: List.generate(
        _timerOptions.length,
        (index) => ButtonSegment(
          value: index,
          label: Text(_timerOptions[index]),
          icon: Icon(_timerIcons[index], color: colorScheme.primary),
        ),
      ),
      selected: <int>{widget.selectedIndex},
      onSelectionChanged: (newSelection) {
        widget.onChanged(newSelection.first);
      },
      style: ButtonStyle(
        padding: WidgetStateProperty.all(
          const EdgeInsets.symmetric(
            vertical: AppSizes.timerSegmentedButtonPaddingV,
            horizontal: AppSizes.timerSegmentedButtonPaddingH,
          ),
        ),
        minimumSize: WidgetStateProperty.all(
          const Size(
            AppSizes.timerSegmentedButtonMinWidth,
            AppSizes.timerSegmentedButtonHeight,
          ),
        ),
        backgroundColor: WidgetStateProperty.resolveWith<Color?>((states) {
          if (states.contains(WidgetState.selected)) {
            return colorScheme.primaryContainer;
          }
          return colorScheme.surfaceContainerHighest;
        }),
        foregroundColor: WidgetStateProperty.resolveWith<Color?>((states) {
          if (states.contains(WidgetState.selected)) {
            return colorScheme.onPrimaryContainer;
          }
          return colorScheme.onSurfaceVariant;
        }),
      ),
    );
  }
}
