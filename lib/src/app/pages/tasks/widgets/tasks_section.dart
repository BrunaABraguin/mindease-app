import 'package:flutter/material.dart';

import 'package:mindease_app/src/app/pages/tasks/tasks_controller.dart';
import 'package:mindease_app/src/app/pages/tasks/widgets/task_section.dart';

class TasksSection extends StatelessWidget {
  const TasksSection({super.key, required this.state, required this.cubit});

  final TasksState state;
  final TasksCubit cubit;

  @override
  Widget build(BuildContext context) {
    return TaskSection(
      title: 'Tarefas',
      tasks: state.showHistory
          ? state.completedNonPriorityTasks
          : state.pendingTasks,
      completedCount: state.showHistory
          ? state.completedNonPriorityTasks.length
          : state.pendingTasks.length,
      isAdding: state.isAddingTask,
      onStartAdding: cubit.startAddingTask,
      onSave: (name) => cubit.addTask(name),
      onCancel: cubit.cancelAddingTask,
      onComplete: cubit.completeTask,
      onDelete: cubit.deleteTask,
      onEditName: cubit.updateTaskName,
      editingTaskId: state.editingTaskId,
      onStartEditing: cubit.startEditing,
      onCancelEditing: cubit.cancelEditing,
      readOnly: state.showHistory,
    );
  }
}
