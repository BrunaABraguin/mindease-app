import 'package:flutter/material.dart';
import 'package:mindease_app/src/app/pages/habits/habits_view.dart';
import 'package:mindease_app/src/app/pages/missions/missions_view.dart';
import 'package:mindease_app/src/app/pages/profile/profile_view.dart';
import 'package:mindease_app/src/app/pages/tasks/tasks_view.dart';
import 'package:mindease_app/src/app/pages/timer/timer_view.dart';
import 'package:mindease_app/src/app/utils/app_constants.dart';
import 'package:mindease_app/src/data/repositories/timer_repository.dart'
    as repo;
import 'package:mindease_app/src/domain/usecases/timer_mode_usecases.dart';

/// Main adaptive navigation shell for the app.
///
/// Uses `NavigationBar` on mobile and `NavigationRail` on wider/web layouts.
class AppNavigator extends StatefulWidget {
  const AppNavigator({super.key, this.onToggleTheme});

  /// Callback used by the theme toggle action.
  final VoidCallback? onToggleTheme;

  @override
  State<AppNavigator> createState() => _AppNavigatorState();
}

/// State holder for the selected destination index.
class _AppNavigatorState extends State<AppNavigator> {
  int _selectedIndex = 0;
  final Map<int, Widget> _pageCache = <int, Widget>{};

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
                    leading: Padding(
                      padding: const EdgeInsets.only(top: AppSizes.paddingXs),
                      child: IconButton(
                        tooltip: AppStrings.toggleTheme,
                        onPressed: widget.onToggleTheme,
                        icon: const Icon(AppIcons.theme),
                      ),
                    ),
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
                Expanded(child: _buildPage(_selectedIndex)),
              ],
            )
          : _buildPage(_selectedIndex),
      bottomNavigationBar: useRail
          ? null
          : DecoratedBox(
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color: colorScheme.tertiary.withValues(
                      alpha: AppSizes.opacityLight,
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

  Widget _buildPage(int index) {
    return _pageCache.putIfAbsent(index, () {
      // Timer dependencies
      final timerRepository = repo.TimerRepository();
      final getCurrentModeIndexUseCase = GetCurrentModeIndexUseCase(
        timerRepository,
      );
      final setCurrentModeIndexUseCase = SetCurrentModeIndexUseCase(
        timerRepository,
      );
      switch (index) {
        case 0:
          return TimerPage(
            timerRepository: timerRepository,
            getCurrentModeIndexUseCase: getCurrentModeIndexUseCase,
            setCurrentModeIndexUseCase: setCurrentModeIndexUseCase,
          );
        case 1:
          return const HabitsPage();
        case 2:
          return const TasksPage();
        case 3:
          return const MissionsPage();
        case 4:
          return const ProfilePage();
        default:
          return TimerPage(
            timerRepository: timerRepository,
            getCurrentModeIndexUseCase: getCurrentModeIndexUseCase,
            setCurrentModeIndexUseCase: setCurrentModeIndexUseCase,
          );
      }
    });
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
