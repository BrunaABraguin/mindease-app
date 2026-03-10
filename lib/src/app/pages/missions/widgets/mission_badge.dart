import 'package:flutter/material.dart';
import 'package:mindease_app/src/app/utils/app_constants.dart';
import 'package:mindease_app/src/domain/entities/mission.dart';

class MissionBadge extends StatelessWidget {
  const MissionBadge({
    super.key,
    required this.mission,
    required this.isCompleted,
    required this.onTap,
  });

  final Mission mission;
  final bool isCompleted;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final badgeColor = isCompleted
        ? colorScheme.secondary
        : colorScheme.outline;
    final iconColor = isCompleted
        ? colorScheme.secondary
        : colorScheme.onSurfaceVariant;
    final textColor = isCompleted
        ? colorScheme.onSurface
        : colorScheme.onSurfaceVariant;

    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          Container(
            width: AppSizes.badgeSize,
            height: AppSizes.badgeSize,
            decoration: BoxDecoration(
              color: isCompleted
                  ? badgeColor.withValues(alpha: AppOpacity.badgeBg)
                  : colorScheme.surfaceContainerHighest,
              shape: BoxShape.circle,
              border: Border.all(
                color: badgeColor,
                width: AppSizes.borderWidthThick,
              ),
            ),
            child: Icon(
              mission.icon,
              color: iconColor,
              size: AppSizes.badgeIconSize,
            ),
          ),
          const SizedBox(width: AppSizes.spacingM),
          Expanded(
            child: Text(
              mission.name,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: textColor,
                fontWeight: isCompleted ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
