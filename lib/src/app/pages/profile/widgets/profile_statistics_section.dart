import 'package:flutter/material.dart';
import 'package:mindease_app/src/app/pages/profile/widgets/stat_card.dart';
import 'package:mindease_app/src/domain/entities/mission.dart';
import 'package:mindease_app/src/domain/entities/profile.dart';

class ProfileStatisticsSection extends StatelessWidget {
  const ProfileStatisticsSection({super.key, required this.profile});

  final Profile profile;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'ESTATÍSTICAS',
          style: theme.textTheme.labelMedium?.copyWith(
            letterSpacing: 1.2,
            color: colorScheme.onSurfaceVariant,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: StatCard(
                icon: Icons.access_time_rounded,
                iconColor: colorScheme.secondary,
                value: profile.formattedFocusTime,
                label: 'Tempo de foco',
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: StatCard(
                icon: Icons.check_circle_outline,
                iconColor: colorScheme.primary,
                value: '${profile.totalTasks}',
                label: 'Tarefas concluídas',
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: StatCard(
                icon: Icons.flag,
                iconColor: colorScheme.tertiary,
                value:
                    '${profile.completedMissions.length}/$totalMissionsCount',
                label: 'Missões finalizadas',
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: StatCard(
                icon: Icons.local_fire_department,
                iconColor: Colors.deepOrange,
                value: '${profile.strikeDays}',
                label: 'Sequência',
              ),
            ),
          ],
        ),
      ],
    );
  }
}
