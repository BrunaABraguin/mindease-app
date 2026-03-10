import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mindease_app/src/app/pages/focus_mode/focus_mode_view.dart';
import 'package:mindease_app/src/app/pages/profile/profile_controller.dart';
import 'package:mindease_app/src/app/pages/tasks/tasks_controller.dart';
import 'package:mindease_app/src/app/pages/timer/timer_controller.dart';
import 'package:mindease_app/src/app/pages/timer/widgets/settings_sessions.dart';
import 'package:mindease_app/src/app/pages/timer/widgets/timer_control_buttons.dart';
import 'package:mindease_app/src/app/pages/timer/widgets/timer_segmented_button.dart';
import 'package:mindease_app/src/app/utils/app_constants.dart';
import 'package:mindease_app/src/app/utils/help_texts.dart';
import 'package:mindease_app/src/app/utils/layout_utils.dart';
import 'package:mindease_app/src/app/widgets/focus_confetti_overlay.dart';
import 'package:mindease_app/src/app/widgets/focus_mode_button.dart';
import 'package:mindease_app/src/app/widgets/help_icon_button.dart';
import 'package:mindease_app/src/app/widgets/timer_display.dart';
import 'package:mindease_app/src/app/widgets/timer_task_selector.dart';
import 'package:mindease_app/src/app/widgets/vertical_timer_progress.dart';
import 'package:mindease_app/src/data/repositories/timer_repository.dart'
    as repo;
import 'package:mindease_app/src/domain/entities/timer_entity.dart';
import 'package:mindease_app/src/domain/repositories/task_repository.dart';

class TimerPage extends StatefulWidget {
  const TimerPage({
    super.key,
    required this.timerRepository,
    required this.taskRepository,
  });
  final repo.TimerRepository timerRepository;
  final TaskRepository taskRepository;

  @override
  State<TimerPage> createState() => _TimerPageState();
}

class _TimerPageState extends State<TimerPage> {
  @override
  Widget build(BuildContext context) {
    final userEmail = context.select<ProfileCubit, String?>(
      (cubit) => cubit.state.user?.email,
    );
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (ctx) => TasksCubit(
            taskRepository: widget.taskRepository,
            userEmail: userEmail,
          ),
        ),
        BlocProvider(
          create: (ctx) {
            final savedTaskId = ctx
                .read<ProfileCubit>()
                .state
                .preferences
                .selectedTaskId;
            final cubit = TimerCubit(
              timerRepository: widget.timerRepository,
              onFocusSessionCompleted: (minutes) async {
                ctx.read<ProfileCubit>().addFocusMinutes(minutes);
              },
              onMissionTriggered: (missionId) async {
                ctx.read<ProfileCubit>().tryCompleteMission(missionId);
              },
              onTaskFocusCompleted: (taskId, minutes) async {
                ctx.read<TasksCubit>().addSpendTime(taskId, minutes);
              },
            );
            if (savedTaskId != null) cubit.selectedTaskId = savedTaskId;
            return cubit;
          },
        ),
      ],
      child: const TimerView(),
    );
  }
}

class TimerView extends StatefulWidget {
  const TimerView({super.key});

  @override
  State<TimerView> createState() => _TimerViewState();
}

class _TimerViewState extends State<TimerView> {
  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final gold = Theme.of(context).colorScheme.tertiary;
    return BlocListener<ProfileCubit, ProfileState>(
      listenWhen: (prev, curr) => prev.user?.email != curr.user?.email,
      listener: (context, profileState) {
        context.read<TasksCubit>().updateUserEmail(profileState.user?.email);
      },
      child: Scaffold(
        appBar: AppBar(
          leadingWidth: AppSizes.leadingWidth,
          leading: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.only(
                  left: AppSizes.paddingLeftFocusMode,
                ),
                child: FocusModeButton(
                  onPressed: () {
                    final timerCubit = context.read<TimerCubit>();
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => BlocProvider.value(
                          value: timerCubit,
                          child: const FocusModePage(),
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(width: AppSizes.spacingXs),
              const HelpIconButton(
                title: HelpTexts.focusModeTitle,
                description: HelpTexts.focusModeDescription,
                size: AppSizes.iconSmall,
              ),
            ],
          ),
        ),
        body: BlocBuilder<TimerCubit, TimerEntity>(
          builder: (context, state) {
            final cubit = context.read<TimerCubit>();
            return FocusConfettiOverlay(
              trigger: state.currentCycle,
              shouldPlay:
                  state.currentCycle == state.totalCycles &&
                  context.read<ProfileCubit>().state.preferences.showAnimations,
              child: Stack(
                children: [
                  Align(
                    alignment: Alignment.topCenter,
                    child: Container(
                      constraints: BoxConstraints(
                        maxWidth: getResponsiveMaxWidth(context),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSizes.paddingM,
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const Row(
                            children: [
                              Spacer(),
                              HelpIconButton(
                                title: HelpTexts.timerTitle,
                                description: HelpTexts.timerDescription,
                                size: AppSizes.iconSmall,
                              ),
                            ],
                          ),
                          const SizedBox(height: AppSizes.spacingS),
                          TimerSegmentedButton(
                            selectedIndex: state.currentModeIndex,
                            onChanged: state.isRunning
                                ? null
                                : (index) {
                                    cubit.updateCurrentModeIndex(index);
                                  },
                            disabled: state.isRunning,
                          ),
                          const SizedBox(height: AppSizes.spacingL),
                          VerticalTimerProgress(
                            totalSeconds: cubit.getTotalSeconds(timer: state),
                            remainingSeconds:
                                state.remainingSeconds ??
                                cubit.getTotalSeconds(timer: state),
                          ),
                          Expanded(
                            child: LayoutBuilder(
                              builder: (context, constraints) {
                                return SingleChildScrollView(
                                  child: ConstrainedBox(
                                    constraints: BoxConstraints(
                                      minHeight: constraints.maxHeight,
                                    ),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        TimerDisplay(
                                          timer: state,
                                          isRunning: state.isRunning,
                                          onIncrement: () =>
                                              cubit.incrementSessionDuration(),
                                          onDecrement: () =>
                                              cubit.decrementSessionDuration(),
                                          onSetValue: (value) =>
                                              cubit.setTimerFromInput(value),
                                          showAnimations: context
                                              .read<ProfileCubit>()
                                              .state
                                              .preferences
                                              .showAnimations,
                                        ),
                                        // Controle de ciclos logo abaixo
                                        const SizedBox(height: 24),
                                        SettingsSessions(
                                          currentCycle: state.currentCycle,
                                          totalCycles: state.totalCycles,
                                          isRunning: state.isRunning,
                                          onIncrement: () =>
                                              cubit.updateTotalCycles(
                                                state.totalCycles + 1,
                                              ),
                                          onDecrement: () =>
                                              cubit.updateTotalCycles(
                                                state.totalCycles - 1,
                                              ),
                                          iconColor: gold,
                                          showCompletedMessage:
                                              state.currentCycle ==
                                              state.totalCycles,
                                        ),
                                        const SizedBox(
                                          height: AppSizes.spacingM,
                                        ),
                                        const TimerTaskSelector(),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                              bottom: AppSizes.timerControlButtonsBottomPadding,
                            ),
                            child: Center(
                              child: TimerControlButtons(
                                onStartPause: () {
                                  cubit.startPauseTimer();
                                },
                                onReset: () {
                                  cubit.resetTimer();
                                },
                                isRunning: state.isRunning,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  if (state.isLoading)
                    const Positioned.fill(
                      child: ColoredBox(
                        color: Color(0x33000000),
                        child: Center(child: CircularProgressIndicator()),
                      ),
                    ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
