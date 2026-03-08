import 'package:flutter/material.dart';
import 'package:mindease_app/src/app/utils/app_constants.dart';

class TimerSegmentedButton extends StatelessWidget {
  const TimerSegmentedButton({
    super.key,
    required this.selectedIndex,
    required this.onChanged,
  });

  final int selectedIndex;
  final ValueChanged<int> onChanged;

  static const List<String> _timerOptions = [
    'Foco',
    'Pausa curta',
    'Pausa longa',
  ];
  static const List<IconData> _timerIcons = [
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
          icon: Icon(
            _timerIcons[index],
            color: Theme.of(context).iconTheme.color,
          ),
        ),
      ),
      selected: <int>{selectedIndex},
      onSelectionChanged: (newSelection) {
        onChanged(newSelection.first);
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
