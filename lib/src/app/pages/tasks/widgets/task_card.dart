import 'package:flutter/material.dart';
import 'package:mindease_app/src/app/utils/app_constants.dart';

class TaskCard extends StatefulWidget {
  const TaskCard({
    super.key,
    required this.name,
    required this.isDone,
    required this.onComplete,
    required this.onDelete,
    required this.onEditName,
    required this.isEditing,
    required this.onStartEditing,
    required this.onCancelEditing,
  });

  final String name;
  final bool isDone;
  final VoidCallback onComplete;
  final VoidCallback onDelete;
  final void Function(String newName) onEditName;
  final bool isEditing;
  final VoidCallback onStartEditing;
  final VoidCallback onCancelEditing;

  @override
  State<TaskCard> createState() => _TaskCardState();
}

class _TaskCardState extends State<TaskCard> {
  late final TextEditingController _editController;

  @override
  void initState() {
    super.initState();
    _editController = TextEditingController(text: widget.name);
  }

  @override
  void didUpdateWidget(covariant TaskCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isEditing && !oldWidget.isEditing) {
      _editController.text = widget.name;
    }
  }

  @override
  void dispose() {
    _editController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    if (widget.isEditing) {
      return Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSizes.paddingM,
          vertical: AppSizes.paddingXs,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: colorScheme.surface,
          border: Border.all(
            color: colorScheme.primary,
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _editController,
                autofocus: true,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  isDense: true,
                  contentPadding: EdgeInsets.zero,
                ),
                onSubmitted: (value) {
                  if (value.trim().isNotEmpty) {
                    widget.onEditName(value);
                  }
                },
              ),
            ),
            IconButton(
              icon: const Icon(Icons.check_outlined, color: Colors.green),
              onPressed: () {
                if (_editController.text.trim().isNotEmpty) {
                  widget.onEditName(_editController.text);
                }
              },
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
              iconSize: AppSizes.iconSmall,
            ),
            const SizedBox(width: AppSizes.spacingXs),
            IconButton(
              icon: Icon(Icons.close, color: colorScheme.error),
              onPressed: widget.onCancelEditing,
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
              iconSize: AppSizes.iconSmall,
            ),
          ],
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSizes.paddingM,
        vertical: AppSizes.paddingS,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: colorScheme.surface,
        border: Border.all(
          color: colorScheme.secondary,
        ),
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: widget.isDone ? null : widget.onComplete,
            child: Container(
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: widget.isDone
                      ? colorScheme.primary
                      : colorScheme.outlineVariant,
                  width: AppSizes.borderWidthThick,
                ),
                color: widget.isDone ? colorScheme.primary : Colors.transparent,
              ),
              child: widget.isDone
                  ? Icon(Icons.check, size: 14, color: colorScheme.onPrimary)
                  : null,
            ),
          ),
          const SizedBox(width: AppSizes.spacingS),
          Expanded(
            child: GestureDetector(
              onDoubleTap: widget.isDone ? null : widget.onStartEditing,
              child: Text(
                widget.name,
                style: textTheme.bodyMedium?.copyWith(
                  decoration: widget.isDone ? TextDecoration.lineThrough : null,
                  color: widget.isDone
                      ? colorScheme.onSurfaceVariant
                      : colorScheme.onSurface,
                ),
              ),
            ),
          ),
          IconButton(
            icon: Icon(
              Icons.close,
              color: colorScheme.onSurfaceVariant,
              size: AppSizes.iconExtraSmall,
            ),
            onPressed: widget.onDelete,
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
        ],
      ),
    );
  }
}
