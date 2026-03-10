import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mindease_app/src/app/pages/profile/profile_controller.dart';
import 'package:mindease_app/src/app/pages/tasks/tasks_controller.dart';
import 'package:mindease_app/src/app/pages/timer/timer_controller.dart';
import 'package:mindease_app/src/app/utils/app_constants.dart';
import 'package:mindease_app/src/app/utils/help_texts.dart';
import 'package:mindease_app/src/app/widgets/help_icon_button.dart';

class TimerTaskSelector extends StatelessWidget {
  const TimerTaskSelector({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return BlocBuilder<ProfileCubit, ProfileState>(
      buildWhen: (prev, curr) =>
          prev.preferences.selectedTaskId != curr.preferences.selectedTaskId,
      builder: (context, profileState) {
        return BlocBuilder<TasksCubit, TasksState>(
          builder: (context, tasksState) {
            final pendingTasks = tasksState.allPending;
            if (pendingTasks.isEmpty) return const SizedBox.shrink();

            final timerCubit = context.read<TimerCubit>();
            final profileCubit = context.read<ProfileCubit>();
            final savedTaskId = profileState.preferences.selectedTaskId;
            final selectedTaskId = pendingTasks.any((t) => t.id == savedTaskId)
                ? savedTaskId
                : null;

            return Container(
              padding: const EdgeInsets.all(AppSizes.paddingM),
              decoration: BoxDecoration(
                color: colorScheme.surfaceContainerLowest,
                borderRadius: BorderRadius.circular(AppSizes.paddingS),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        'Tarefa associada',
                        style: textTheme.titleSmall?.copyWith(
                          color: colorScheme.onSurface,
                        ),
                      ),
                      const Spacer(),
                      const HelpIconButton(
                        title: HelpTexts.taskSelectorTitle,
                        description: HelpTexts.taskSelectorDescription,
                        size: AppSizes.iconSmall,
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSizes.spacingXs),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSizes.paddingS,
                    ),
                    decoration: BoxDecoration(
                      color: colorScheme.surface,
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: colorScheme.secondary),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String?>(
                        value: selectedTaskId,
                        isExpanded: true,
                        icon: Icon(
                          Icons.arrow_drop_down,
                          color: colorScheme.onSurfaceVariant,
                        ),
                        hint: Text(
                          'Selecione uma tarefa',
                          style: textTheme.bodyMedium?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                        items: [
                          DropdownMenuItem<String?>(
                            child: Text(
                              'Nenhuma',
                              style: textTheme.bodyMedium?.copyWith(
                                color: colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ),
                          ...pendingTasks.map(
                            (task) => DropdownMenuItem<String?>(
                              value: task.id,
                              child: Text(
                                task.name,
                                style: textTheme.bodyMedium,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                        ],
                        onChanged: (value) {
                          timerCubit.selectedTaskId = value;
                          profileCubit.setSelectedTaskId(value);
                        },
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
