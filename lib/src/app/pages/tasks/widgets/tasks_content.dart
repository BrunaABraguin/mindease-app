import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:mindease_app/src/app/pages/tasks/tasks_controller.dart';
import 'package:mindease_app/src/app/pages/tasks/widgets/history_toggle_button.dart';
import 'package:mindease_app/src/app/pages/tasks/widgets/task_section.dart';
import 'package:mindease_app/src/app/pages/tasks/widgets/tasks_section.dart';
import 'package:mindease_app/src/app/pages/tasks/widgets/tasks_summary_bar.dart';
import 'package:mindease_app/src/app/utils/app_constants.dart';

class TasksContent extends StatelessWidget {
  const TasksContent({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TasksCubit, TasksState>(
      builder: (context, state) {
        final cubit = context.read<TasksCubit>();

        return ListView(
          padding: const EdgeInsets.symmetric(
            vertical: AppSizes.paddingXl,
            horizontal: AppSizes.paddingL,
          ),
          children: [
            TasksSummaryBar(
              total: state.totalCount,
              pending: state.pendingCount,
              completed: state.completedCount,
            ),
            const SizedBox(height: AppSizes.spacingXs),
            HistoryToggleButton(
              showHistory: state.showHistory,
              onPressed: cubit.toggleHistoryView,
            ),
            const SizedBox(height: AppSizes.spacingM),
            _PrioritiesSection(state: state, cubit: cubit),
            const SizedBox(height: AppSizes.spacingL),
            TasksSection(state: state, cubit: cubit),
          ],
        );
      },
    );
  }
}

class _PrioritiesSection extends StatelessWidget {
  const _PrioritiesSection({required this.state, required this.cubit});

  final TasksState state;
  final TasksCubit cubit;

  @override
  Widget build(BuildContext context) {
    return TaskSection(
      title: 'Prioridades',
      tasks: state.showHistory
          ? state.completedPriorities
          : state.pendingPriorities,
      completedCount: state.showHistory
          ? state.completedPriorities.length
          : state.pendingPriorities.length,
      isAdding: state.isAddingPriority,
      onStartAdding: cubit.startAddingPriority,
      onSave: (name) => cubit.addTask(name, isPriority: true),
      onCancel: cubit.cancelAddingPriority,
      onComplete: cubit.completeTask,
      onDelete: cubit.deleteTask,
      onEditName: cubit.updateTaskName,
      editingTaskId: state.editingTaskId,
      onStartEditing: cubit.startEditing,
      onCancelEditing: cubit.cancelEditing,
      maxItems: state.showHistory ? null : TasksCubit.maxPriorities,
      hintText: 'Nome da prioridade',
      readOnly: state.showHistory,
    );
  }
}
