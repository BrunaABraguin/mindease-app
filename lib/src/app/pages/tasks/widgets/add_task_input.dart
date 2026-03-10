import 'package:flutter/material.dart';
import 'package:mindease_app/src/app/utils/app_constants.dart';

class AddTaskInput extends StatefulWidget {
  const AddTaskInput({
    super.key,
    required this.onSave,
    required this.onCancel,
    required this.hintText,
  });

  final void Function(String name) onSave;
  final VoidCallback onCancel;
  final String hintText;

  @override
  State<AddTaskInput> createState() => _AddTaskInputState();
}

class _AddTaskInputState extends State<AddTaskInput> {
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
        vertical: AppSizes.paddingXs,
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
          Expanded(
            child: TextField(
              controller: _controller,
              autofocus: true,
              decoration: InputDecoration(
                hintText: widget.hintText,
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
            icon: const Icon(Icons.check_outlined, color: Colors.green),
            onPressed: () {
              if (_controller.text.trim().isNotEmpty) {
                widget.onSave(_controller.text);
              }
            },
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
            iconSize: AppSizes.iconSmall,
          ),
        ],
      ),
    );
  }
}
