import 'package:flutter/material.dart';
import 'package:mindease_app/src/app/utils/app_constants.dart';
import 'package:mindease_app/theme.dart';

class TasksSummaryBar extends StatelessWidget {
  const TasksSummaryBar({
    super.key,
    required this.total,
    required this.pending,
    required this.completed,
  });

  final int total;
  final int pending;
  final int completed;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final width = MediaQuery.sizeOf(context).width;
    final isMobile = width < AppSizes.breakpointMobile;

    if (isMobile) {
      return _buildMobileSummary(colorScheme, textTheme);
    }
    return _buildWebSummary(colorScheme, textTheme);
  }

  Widget _buildMobileSummary(ColorScheme colorScheme, TextTheme textTheme) {
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: AppSizes.paddingS,
        horizontal: AppSizes.paddingM,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppTheme.green.withValues(alpha: 0.2),
            AppTheme.blue.withValues(alpha: 0.2),
          ],
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.blue,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _SummaryItem(
            label: 'Total',
            value: total,
            textTheme: textTheme,
            colorScheme: colorScheme,
          ),
          _SummaryItem(
            label: 'Pendentes',
            value: pending,
            textTheme: textTheme,
            colorScheme: colorScheme,
          ),
          _SummaryItem(
            label: 'Concluídas',
            value: completed,
            textTheme: textTheme,
            colorScheme: colorScheme,
          ),
        ],
      ),
    );
  }

  Widget _buildWebSummary(ColorScheme colorScheme, TextTheme textTheme) {
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: AppSizes.paddingS,
        horizontal: AppSizes.paddingM,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppTheme.green.withValues(alpha: 0.2),
            AppTheme.blue.withValues(alpha: 0.2),
          ],
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.blue,
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: _WebSummaryChip(
              label: 'Total',
              value: total,
              colorScheme: colorScheme,
              textTheme: textTheme,
            ),
          ),
          const SizedBox(width: AppSizes.spacingS),
          Expanded(
            child: _WebSummaryChip(
              label: 'Pendentes',
              value: pending,
              colorScheme: colorScheme,
              textTheme: textTheme,
            ),
          ),
          const SizedBox(width: AppSizes.spacingS),
          Expanded(
            child: _WebSummaryChip(
              label: 'Concluídas',
              value: completed,
              colorScheme: colorScheme,
              textTheme: textTheme,
            ),
          ),
        ],
      ),
    );
  }
}

class _SummaryItem extends StatelessWidget {
  const _SummaryItem({
    required this.label,
    required this.value,
    required this.textTheme,
    required this.colorScheme,
  });

  final String label;
  final int value;
  final TextTheme textTheme;
  final ColorScheme colorScheme;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label,
          style: textTheme.labelSmall?.copyWith(
            color: colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: AppSizes.spacingXxs),
        Text(
          '$value',
          style: textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: colorScheme.onSurface,
          ),
        ),
      ],
    );
  }
}

class _WebSummaryChip extends StatelessWidget {
  const _WebSummaryChip({
    required this.label,
    required this.value,
    required this.colorScheme,
    required this.textTheme,
  });

  final String label;
  final int value;
  final ColorScheme colorScheme;
  final TextTheme textTheme;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSizes.paddingM,
        vertical: AppSizes.paddingXs,
      ),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: AppTheme.blue.withValues(alpha: 0.4),
        ),
        boxShadow: [
          BoxShadow(
            color: AppTheme.blue.withValues(alpha: 0.15),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: Text(
              label,
              style: textTheme.labelMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Text(
            '$value',
            style: textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: colorScheme.onSurface,
            ),
          ),
        ],
      ),
    );
  }
}
