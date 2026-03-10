import 'package:flutter/material.dart';
import 'package:mindease_app/src/app/pages/missions/widgets/mission_badge.dart';
import 'package:mindease_app/src/app/utils/app_constants.dart';
import 'package:mindease_app/src/domain/entities/mission.dart';

class MissionSectionWidget extends StatefulWidget {
  const MissionSectionWidget({
    super.key,
    required this.section,
    required this.completedMissions,
    required this.onMissionTap,
  });

  final MissionSection section;
  final List<String> completedMissions;
  final void Function(Mission mission) onMissionTap;

  @override
  State<MissionSectionWidget> createState() => _MissionSectionWidgetState();
}

class _MissionSectionWidgetState extends State<MissionSectionWidget> {
  bool _expanded = true;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: () => setState(() => _expanded = !_expanded),
          child: Row(
            children: [
              Text(
                widget.section.title.toUpperCase(),
                style: theme.textTheme.labelMedium?.copyWith(
                  letterSpacing: AppSizes.sectionLabelLetterSpacing,
                  color: colorScheme.onSurfaceVariant,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Spacer(),
              AnimatedRotation(
                turns: _expanded ? 0.5 : 0.0,
                duration: const Duration(milliseconds: 200),
                child: Icon(
                  Icons.expand_more,
                  size: AppSizes.iconSmall,
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
        AnimatedCrossFade(
          firstChild: Padding(
            padding: const EdgeInsets.only(top: AppSizes.spacingM),
            child: _buildBadges(),
          ),
          secondChild: const SizedBox.shrink(),
          crossFadeState:
              _expanded ? CrossFadeState.showFirst : CrossFadeState.showSecond,
          duration: const Duration(milliseconds: 200),
        ),
      ],
    );
  }

  Widget _buildBadges() {
    final badges = widget.section.missions.map((mission) {
      final isCompleted = widget.completedMissions.contains(mission.id);
      return Padding(
        padding: const EdgeInsets.only(bottom: AppSizes.spacingS),
        child: MissionBadge(
          mission: mission,
          isCompleted: isCompleted,
          onTap: () => widget.onMissionTap(mission),
        ),
      );
    }).toList();

    return Column(children: badges);
  }
}
