import 'package:flutter/material.dart';
import 'package:mindease_app/src/app/utils/app_constants.dart';
import 'package:mindease_app/src/domain/entities/habit.dart';

class HabitCard extends StatelessWidget {
  const HabitCard({
    super.key,
    required this.habit,
    required this.weekDays,
    required this.selectedDate,
    required this.onToggleDay,
    required this.onDelete,
    required this.onStartEditing,
    required this.onSaveEdit,
    required this.onCancelEdit,
    required this.isEditing,
    required this.isDeleting,
    required this.onConfirmDelete,
    required this.onCancelDelete,
  });

  final Habit habit;
  final List<DateTime> weekDays;
  final DateTime selectedDate;
  final void Function(DateTime day) onToggleDay;
  final VoidCallback onDelete;
  final VoidCallback onStartEditing;
  final void Function(String newName) onSaveEdit;
  final VoidCallback onCancelEdit;
  final bool isEditing;
  final bool isDeleting;
  final VoidCallback onConfirmDelete;
  final VoidCallback onCancelDelete;

  static const _dayLabels = [
    AppStrings.mon,
    AppStrings.tue,
    AppStrings.wed,
    AppStrings.thu,
    AppStrings.fri,
    AppStrings.sat,
    AppStrings.sun,
  ];

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: colorScheme.outline.withValues(alpha: 0.6)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.paddingM),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(context, colorScheme),
            if (isDeleting) _buildDeleteConfirmation(context, colorScheme),
            const SizedBox(height: AppSizes.spacingS),
            _buildWeekRow(context, colorScheme),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, ColorScheme colorScheme) {
    if (isEditing) {
      return _EditingHeader(
        initialName: habit.name,
        onSave: onSaveEdit,
        onCancel: onCancelEdit,
        colorScheme: colorScheme,
      );
    }

    return Row(
      children: [
        Expanded(
          child: GestureDetector(
            onDoubleTap: onStartEditing,
            child: Text(
              habit.name,
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
            ),
          ),
        ),
        IconButton(
          icon: Icon(
            Icons.close,
            size: AppSizes.iconSmall,
            color: colorScheme.onSurface,
          ),
          onPressed: onDelete,
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(),
        ),
      ],
    );
  }

  Widget _buildDeleteConfirmation(
    BuildContext context,
    ColorScheme colorScheme,
  ) {
    return Padding(
      padding: const EdgeInsets.only(top: AppSizes.spacingXs),
      child: Row(
        children: [
          Text(
            AppStrings.confirmDelete,
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: colorScheme.error),
          ),
          const Spacer(),
          TextButton(
            onPressed: onConfirmDelete,
            child: Text(
              AppStrings.yes,
              style: TextStyle(color: colorScheme.error),
            ),
          ),
          TextButton(
            onPressed: onCancelDelete,
            child: Text(
              AppStrings.no,
              style: TextStyle(color: colorScheme.onSurface),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWeekRow(BuildContext context, ColorScheme colorScheme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: List.generate(7, (index) {
        final day = weekDays[index];
        final hasRecord = habit.hasRecordOn(day);
        final isToday = _isSameDay(day, DateTime.now());
        final isSelected = _isSameDay(day, selectedDate);

        return Column(
          children: [
            Text(
              _dayLabels[index],
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurface.withValues(alpha: 0.85),
                fontSize: 11,
              ),
            ),
            const SizedBox(height: AppSizes.spacingXxs),
            GestureDetector(
              onTap: () => onToggleDay(day),
              child: Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: hasRecord ? colorScheme.secondary : Colors.transparent,
                  border: Border.all(
                    color: hasRecord
                        ? colorScheme.secondary
                        : colorScheme.secondary.withValues(alpha: 0.65),
                    width: isSelected || isToday
                        ? AppSizes.borderWidthThick
                        : AppSizes.borderWidthThin,
                  ),
                ),
                alignment: Alignment.center,
                child: Text(
                  '${day.day}',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: isSelected
                        ? FontWeight.bold
                        : FontWeight.normal,
                    color: hasRecord
                        ? colorScheme.onSecondary
                        : colorScheme.onSurface,
                  ),
                ),
              ),
            ),
          ],
        );
      }),
    );
  }

  bool _isSameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;
}

class _EditingHeader extends StatefulWidget {
  const _EditingHeader({
    required this.initialName,
    required this.onSave,
    required this.onCancel,
    required this.colorScheme,
  });

  final String initialName;
  final void Function(String) onSave;
  final VoidCallback onCancel;
  final ColorScheme colorScheme;

  @override
  State<_EditingHeader> createState() => _EditingHeaderState();
}

class _EditingHeaderState extends State<_EditingHeader> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialName);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: _controller,
            autofocus: true,
            decoration: InputDecoration(
              isDense: true,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: AppSizes.paddingXs,
                vertical: AppSizes.paddingXs,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: widget.colorScheme.secondary),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(
                  color: widget.colorScheme.secondary,
                  width: AppSizes.borderWidthThick,
                ),
              ),
            ),
            onSubmitted: (value) => widget.onSave(value),
          ),
        ),
        IconButton(
          icon: Icon(
            Icons.check,
            color: widget.colorScheme.secondary,
            size: AppSizes.iconSmall,
          ),
          onPressed: () => widget.onSave(_controller.text),
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(),
        ),
        const SizedBox(width: AppSizes.spacingXs),
        IconButton(
          icon: Icon(
            Icons.close,
            color: widget.colorScheme.onSurface,
            size: AppSizes.iconSmall,
          ),
          onPressed: widget.onCancel,
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(),
        ),
      ],
    );
  }
}
