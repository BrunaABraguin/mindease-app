import 'package:flutter/material.dart';
import 'package:mindease_app/src/app/utils/app_constants.dart';

class AddHabitInput extends StatefulWidget {
  const AddHabitInput({
    super.key,
    required this.onSave,
    required this.onCancel,
  });

  final void Function(String name) onSave;
  final VoidCallback onCancel;

  @override
  State<AddHabitInput> createState() => _AddHabitInputState();
}

class _AddHabitInputState extends State<AddHabitInput> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSizes.paddingM,
        vertical: AppSizes.paddingS,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colorScheme.secondary.withValues(alpha: 0.7)),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              autofocus: true,
              decoration: const InputDecoration(
                hintText: AppStrings.habitNameHint,
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.zero,
              ),
              onSubmitted: (value) {
                if (value.trim().isNotEmpty) {
                  widget.onSave(value);
                }
              },
            ),
          ),
          IconButton(
            icon: Icon(
              Icons.check,
              color: colorScheme.secondary,
              size: AppSizes.iconSmall,
            ),
            onPressed: () {
              if (_controller.text.trim().isNotEmpty) {
                widget.onSave(_controller.text);
              }
            },
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
          const SizedBox(width: AppSizes.spacingXs),
          IconButton(
            icon: Icon(
              Icons.close,
              color: colorScheme.onSurface,
              size: AppSizes.iconSmall,
            ),
            onPressed: widget.onCancel,
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
        ],
      ),
    );
  }
}
