import 'package:flutter/material.dart';

import 'package:mindease_app/src/app/pages/habits/widgets/add_habit_input.dart';
import 'package:mindease_app/src/app/utils/app_constants.dart';
import 'package:mindease_app/src/app/utils/help_texts.dart';
import 'package:mindease_app/src/app/widgets/dotted_border_decoration.dart';
import 'package:mindease_app/src/app/widgets/help_icon_button.dart';

class AddHabitButton extends StatelessWidget {
  const AddHabitButton({
    super.key,
    required this.isAdding,
    required this.onStartAdding,
    required this.onSave,
    required this.onCancel,
  });

  final bool isAdding;
  final VoidCallback onStartAdding;
  final void Function(String) onSave;
  final VoidCallback onCancel;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    if (isAdding) {
      return AddHabitInput(onSave: onSave, onCancel: onCancel);
    }

    return Row(
      children: [
        Expanded(
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onStartAdding,
              borderRadius: BorderRadius.circular(12),
              child: DecoratedBox(
                decoration: DottedBorderDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: colorScheme.secondary,
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: AppSizes.paddingS,
                  ),
                  child: Center(
                    child: Text(
                      AppStrings.addNewHabit,
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        color: colorScheme.secondary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: AppSizes.spacingXs),
        const HelpIconButton(
          title: HelpTexts.addHabitTitle,
          description: HelpTexts.addHabitDescription,
        ),
      ],
    );
  }
}
