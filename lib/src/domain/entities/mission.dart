import 'package:flutter/material.dart';

class Mission {
  const Mission({
    required this.id,
    required this.name,
    required this.icon,
    required this.destinationIndex,
  });

  final String id;
  final String name;
  final IconData icon;

  /// Index of the navigation destination in [AppNavigator].
  final int destinationIndex;
}

class MissionSection {
  const MissionSection({
    required this.title,
    required this.destinationIndex,
    required this.missions,
  });

  final String title;
  final int destinationIndex;
  final List<Mission> missions;
}

/// Fixed missions that guide users through the platform.
///
/// Sections mirror the main navigation destinations.
const List<MissionSection> appMissions = [
  MissionSection(
    title: 'Timer',
    destinationIndex: 0,
    missions: [
      Mission(
        id: 'timer_first_session',
        name: 'Complete sua primeira sessão de foco',
        icon: Icons.play_circle_outline,
        destinationIndex: 0,
      ),
      Mission(
        id: 'timer_30_min',
        name: 'Acumule 30 minutos de foco',
        icon: Icons.timer,
        destinationIndex: 0,
      ),
      Mission(
        id: 'timer_long_break',
        name: 'Alcance uma pausa longa',
        icon: Icons.coffee,
        destinationIndex: 0,
      ),
    ],
  ),
  MissionSection(
    title: 'Hábitos',
    destinationIndex: 1,
    missions: [
      Mission(
        id: 'habits_create_first',
        name: 'Crie seu primeiro hábito',
        icon: Icons.add_circle_outline,
        destinationIndex: 1,
      ),
      Mission(
        id: 'habits_complete_one',
        name: 'Conclua um hábito do dia',
        icon: Icons.check_circle_outline,
        destinationIndex: 1,
      ),
      Mission(
        id: 'habits_streak_3',
        name: 'Mantenha um hábito por 3 dias',
        icon: Icons.local_fire_department,
        destinationIndex: 1,
      ),
    ],
  ),
  MissionSection(
    title: 'Tarefas',
    destinationIndex: 2,
    missions: [
      Mission(
        id: 'tasks_create_first',
        name: 'Crie sua primeira tarefa',
        icon: Icons.playlist_add,
        destinationIndex: 2,
      ),
      Mission(
        id: 'tasks_complete_one',
        name: 'Conclua uma tarefa',
        icon: Icons.task_alt,
        destinationIndex: 2,
      ),
      Mission(
        id: 'tasks_complete_5',
        name: 'Conclua 5 tarefas',
        icon: Icons.checklist,
        destinationIndex: 2,
      ),
    ],
  ),
  MissionSection(
    title: 'Perfil',
    destinationIndex: 4,
    missions: [
      Mission(
        id: 'profile_login',
        name: 'Faça login com o Google',
        icon: Icons.login,
        destinationIndex: 4,
      ),
      Mission(
        id: 'profile_dark_theme',
        name: 'Experimente o tema escuro',
        icon: Icons.brightness_6_outlined,
        destinationIndex: 4,
      ),
    ],
  ),
];

/// Total number of missions available.
int get totalMissionsCount =>
    appMissions.fold(0, (sum, s) => sum + s.missions.length);
