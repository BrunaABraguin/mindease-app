import 'package:flutter/material.dart';
import 'package:mindease_app/src/app/utils/app_constants.dart';

class TimerSegmentedButton extends StatelessWidget {
  const TimerSegmentedButton({
    super.key,
    required this.selectedIndex,
    required this.onChanged,
    this.disabled = false,
  });

  final int selectedIndex;
  final ValueChanged<int>? onChanged;
  final bool disabled;
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
    final bool enabled = !disabled && onChanged != null;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: double.infinity,
          child: Opacity(
            opacity: enabled ? 1.0 : AppOpacity.medium,
            child: IgnorePointer(
              ignoring: !enabled,
              child: Semantics(
                label: 'Seleção de modo do timer',
                child: SegmentedButton<int>(
                  segments: List.generate(
                    _timerOptions.length,
                    (index) => ButtonSegment(
                      value: index,
                      label: Text(_timerOptions[index]),
                      icon: Icon(
                        _timerIcons[index],
                        color: Theme.of(context).iconTheme.color,
                        semanticLabel: _timerOptions[index],
                      ),
                    ),
                  ),
                  selected: <int>{selectedIndex},
                  onSelectionChanged: (newSelection) {
                    onChanged?.call(newSelection.first);
                  },
                  style: ButtonStyle(
                    padding: WidgetStateProperty.all(
                      const EdgeInsets.symmetric(
                        vertical: AppSizes.timerSegmentedButtonPaddingV,
                        horizontal: AppSizes.timerSegmentedButtonPaddingH,
                      ),
                    ),
                    backgroundColor: WidgetStateProperty.resolveWith<Color?>((
                      states,
                    ) {
                      if (states.contains(WidgetState.disabled)) {
                        return colorScheme.onSurface.withValues(
                          alpha: AppOpacity.medium,
                        );
                      }
                      if (states.contains(WidgetState.selected)) {
                        return colorScheme.secondaryContainer;
                      }
                      return colorScheme.surfaceContainerHighest;
                    }),
                    foregroundColor: WidgetStateProperty.resolveWith<Color?>((
                      states,
                    ) {
                      if (states.contains(WidgetState.disabled)) {
                        return colorScheme.onSurfaceVariant.withValues(
                          alpha: AppOpacity.medium,
                        );
                      }
                      if (states.contains(WidgetState.selected)) {
                        return colorScheme.onPrimaryContainer;
                      }
                      return colorScheme.onSurfaceVariant;
                    }),
                  ),
                ),
              ),
            ),
          ),
        ),
        if (disabled)
          Padding(
            padding: const EdgeInsets.only(
              top: AppSizes.paddingXs,
              bottom: AppSizes.spacingXxs,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.lock_outline,
                  size: AppSizes.iconSmall,
                  color: Theme.of(context).colorScheme.onSurfaceVariant
                      .withValues(alpha: AppOpacity.medium),
                ),
                const SizedBox(width: AppSizes.spacingXs),
                Text(
                  'Pressione Reiniciar ou Parar para alterar modo',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant
                        .withValues(alpha: AppOpacity.medium),
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
