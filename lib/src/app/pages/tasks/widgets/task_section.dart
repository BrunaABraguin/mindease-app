import 'package:flutter/material.dart';
import 'package:mindease_app/src/app/pages/tasks/widgets/add_task_input.dart';
import 'package:mindease_app/src/app/pages/tasks/widgets/task_card.dart';
import 'package:mindease_app/src/app/utils/app_constants.dart';
import 'package:mindease_app/src/domain/entities/task.dart';

class TaskSection extends StatelessWidget {
  const TaskSection({
    super.key,
    required this.title,
    required this.tasks,
    required this.completedCount,
    required this.isAdding,
    required this.onStartAdding,
    required this.onSave,
    required this.onCancel,
    required this.onComplete,
    required this.onDelete,
    required this.onEditName,
    required this.editingTaskId,
    required this.onStartEditing,
    required this.onCancelEditing,
    this.maxItems,
    this.hintText = 'Nome da tarefa',
    this.readOnly = false,
  });

  final String title;
  final List<Task> tasks;
  final int completedCount;
  final bool isAdding;
  final VoidCallback onStartAdding;
  final void Function(String name) onSave;
  final VoidCallback onCancel;
  final void Function(String taskId) onComplete;
  final void Function(String taskId) onDelete;
  final void Function(String taskId, String newName) onEditName;
  final String editingTaskId;
  final void Function(String taskId) onStartEditing;
  final VoidCallback onCancelEditing;
  final int? maxItems;
  final String hintText;
  final bool readOnly;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final total = maxItems ?? tasks.length;
    final addDisabled = maxItems != null && tasks.length >= maxItems!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              title,
              style: textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(width: AppSizes.spacingXs),
            Text(
              maxItems != null
                  ? '($completedCount/$maxItems)'
                  : '($completedCount/$total)',
              style: textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            const Spacer(),
            if (!readOnly)
              Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: addDisabled ? null : onStartAdding,
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: addDisabled
                          ? colorScheme.surfaceContainerHighest
                          : colorScheme.secondary,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      Icons.add,
                      size: AppSizes.iconExtraSmall,
                      color: addDisabled
                          ? colorScheme.onSurfaceVariant
                          : colorScheme.onSecondary,
                    ),
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: AppSizes.spacingS),
        ...tasks.map(
          (task) => Padding(
            padding: const EdgeInsets.only(bottom: AppSizes.spacingXs),
            child: TaskCard(
              name: task.name,
              isDone: task.isDone,
              onComplete: () => onComplete(task.id),
              onDelete: () => onDelete(task.id),
              onEditName: (newName) => onEditName(task.id, newName),
              isEditing: editingTaskId == task.id,
              onStartEditing: () => onStartEditing(task.id),
              onCancelEditing: onCancelEditing,
            ),
          ),
        ),
        if (isAdding && !readOnly)
          Padding(
            padding: const EdgeInsets.only(bottom: AppSizes.spacingXs),
            child: AddTaskInput(
              onSave: onSave,
              onCancel: onCancel,
              hintText: hintText,
            ),
          ),
      ],
    );
  }
}
