import 'package:flutter/material.dart';
import 'package:mindease_app/src/app/pages/habits/habits_view.dart';
import 'package:mindease_app/src/app/pages/missions/missions_view.dart';
import 'package:mindease_app/src/app/pages/profile/profile_view.dart';
import 'package:mindease_app/src/app/pages/tasks/tasks_view.dart';
import 'package:mindease_app/src/app/pages/timer/timer_view.dart';
import 'package:mindease_app/src/app/utils/app_constants.dart';
import 'package:mindease_app/src/data/repositories/timer_repository.dart'
    as repo;
import 'package:mindease_app/src/domain/repositories/habit_repository.dart';
import 'package:mindease_app/src/domain/repositories/task_repository.dart';

/// Main adaptive navigation shell for the app.
///
/// Uses `NavigationBar` on mobile and `NavigationRail` on wider/web layouts.
class AppNavigator extends StatefulWidget {
  const AppNavigator({
    super.key,
    required this.timerRepository,
    required this.habitRepository,
    required this.taskRepository,
  });

  /// The timer repository to use.
  final repo.TimerRepository timerRepository;

  /// The habit repository to use.
  final HabitRepository habitRepository;

  /// The task repository to use.
  final TaskRepository taskRepository;

  /// Switches the active navigation tab from a descendant context.
  static void switchTab(BuildContext context, int index) {
    final state = context.findAncestorStateOfType<_AppNavigatorState>();
    assert(
      state != null,
      'AppNavigator.switchTab was called with a context that does not contain an AppNavigator.\n'
      'Make sure the provided BuildContext is a descendant of AppNavigator.',
    );

    state!.onSelect(index);
  }

  @override
  State<AppNavigator> createState() => _AppNavigatorState();
}

/// State holder for the selected destination index.
class _AppNavigatorState extends State<AppNavigator> {
  int _selectedIndex = 0;

  static const _destinations = <_AppDestination>[
    _AppDestination(
      label: AppStrings.timer,
      icon: AppIcons.timerOutlined,
      selectedIcon: AppIcons.timer,
    ),
    _AppDestination(
      label: AppStrings.habits,
      icon: AppIcons.habitsOutlined,
      selectedIcon: AppIcons.habits,
    ),
    _AppDestination(
      label: AppStrings.tasks,
      icon: AppIcons.tasksOutlined,
      selectedIcon: AppIcons.tasks,
    ),
    _AppDestination(
      label: AppStrings.missions,
      icon: AppIcons.missionsOutlined,
      selectedIcon: AppIcons.missions,
    ),
    _AppDestination(
      label: AppStrings.profile,
      icon: AppIcons.profileOutlined,
      selectedIcon: AppIcons.profile,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final width = MediaQuery.sizeOf(context).width;
    final useRail = width >= AppSizes.breakpointMobile;

    return Scaffold(
      body: useRail
          ? Row(
              children: [
                DecoratedBox(
                  decoration: BoxDecoration(
                    color: colorScheme.surfaceContainerHighest,
                    border: Border(
                      right: BorderSide(color: colorScheme.outlineVariant),
                    ),
                  ),
                  child: NavigationRail(
                    selectedIndex: _selectedIndex,
                    labelType: NavigationRailLabelType.all,
                    groupAlignment: AppSizes.navigationRailAlignment,
                    onDestinationSelected: onSelect,
                    destinations: _destinations
                        .map(
                          (d) => NavigationRailDestination(
                            icon: Icon(d.icon, semanticLabel: d.label),
                            selectedIcon: Icon(
                              d.selectedIcon,
                              semanticLabel: d.label,
                            ),
                            label: Text(
                              _ellipsizedLabel(d.label),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              softWrap: false,
                            ),
                          ),
                        )
                        .toList(growable: false),
                  ),
                ),
                Expanded(child: _buildBody()),
              ],
            )
          : _buildBody(),
      bottomNavigationBar: useRail
          ? null
          : DecoratedBox(
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color: colorScheme.tertiary.withValues(
                      alpha: AppOpacity.light,
                    ),
                    width: AppSizes.borderWidthMedium,
                  ),
                ),
              ),
              child: NavigationBar(
                selectedIndex: _selectedIndex,
                onDestinationSelected: onSelect,
                labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
                destinations: _destinations
                    .map(
                      (d) => NavigationDestination(
                        icon: Icon(d.icon, semanticLabel: d.label),
                        selectedIcon: Icon(
                          d.selectedIcon,
                          semanticLabel: d.label,
                        ),
                        label: _ellipsizedLabel(d.label),
                      ),
                    )
                    .toList(growable: false),
              ),
            ),
    );
  }

  /// Updates selected destination index.
  ///
  /// Exposed without private prefix to simplify widget testing hooks.
  @visibleForTesting
  void onSelect(int index) {
    setState(() => _selectedIndex = index);
  }

  final Map<int, Widget> _pageCache = <int, Widget>{};

  /// Lazily builds and caches pages to avoid eagerly instantiating all of them.
  /// Uses [IndexedStack] so that previously-visited pages stay mounted
  /// (preserving running timers, scroll positions, etc.).
  Widget _buildBody() {
    _pageCache[_selectedIndex] ??= _buildPage(_selectedIndex);
    return IndexedStack(
      index: _selectedIndex,
      children: List.generate(
        _destinations.length,
        (i) => _pageCache[i] ?? const SizedBox.shrink(),
      ),
    );
  }

  Widget _buildPage(int index) {
    switch (index) {
      case 0:
        return TimerPage(
          timerRepository: widget.timerRepository,
          taskRepository: widget.taskRepository,
        );
      case 1:
        return HabitsPage(habitRepository: widget.habitRepository);
      case 2:
        return TasksPage(taskRepository: widget.taskRepository);
      case 3:
        return const MissionsPage();
      case 4:
        return const ProfilePage();
      default:
        return TimerPage(
          timerRepository: widget.timerRepository,
          taskRepository: widget.taskRepository,
        );
    }
  }

  String _ellipsizedLabel(String label) {
    if (label.length <= AppSizes.navLabelMaxChars) {
      return label;
    }

    return '${label.substring(0, AppSizes.navLabelMaxChars)}…';
  }
}

/// Immutable descriptor for one navigation destination.
class _AppDestination {
  const _AppDestination({
    required this.label,
    required this.icon,
    required this.selectedIcon,
  });

  final String label;
  final IconData icon;
  final IconData selectedIcon;
}
