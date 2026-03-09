import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mindease_app/src/app/pages/focus_mode/focus_mode_view.dart';
import 'package:mindease_app/src/app/pages/profile/profile_controller.dart';
import 'package:mindease_app/src/app/pages/timer/timer_controller.dart';
import 'package:mindease_app/src/app/pages/timer/widgets/settings_sessions.dart';
import 'package:mindease_app/src/app/pages/timer/widgets/timer_control_buttons.dart';
import 'package:mindease_app/src/app/pages/timer/widgets/timer_segmented_button.dart';
import 'package:mindease_app/src/app/utils/app_constants.dart';
import 'package:mindease_app/src/app/utils/help_texts.dart';
import 'package:mindease_app/src/app/utils/layout_utils.dart';
import 'package:mindease_app/src/app/widgets/focus_mode_button.dart';
import 'package:mindease_app/src/app/widgets/help_icon_button.dart';
import 'package:mindease_app/src/app/widgets/timer_display.dart';
import 'package:mindease_app/src/app/widgets/vertical_timer_progress.dart';
import 'package:mindease_app/src/data/repositories/timer_repository.dart'
    as repo;
import 'package:mindease_app/src/domain/entities/timer_entity.dart';

class TimerPage extends StatefulWidget {
  const TimerPage({super.key, required this.timerRepository});
  final repo.TimerRepository timerRepository;

  @override
  State<TimerPage> createState() => _TimerPageState();
}

class _TimerPageState extends State<TimerPage> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (ctx) => TimerCubit(
        timerRepository: widget.timerRepository,
        onFocusSessionCompleted: (minutes) async {
          ctx.read<ProfileCubit>().addFocusMinutes(minutes);
        },
      ),
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
    return Scaffold(
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
          return Align(
            alignment: Alignment.topCenter,
            child: Container(
              constraints: BoxConstraints(
                maxWidth: getResponsiveMaxWidth(context),
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
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TimerDisplay(
                          timer: state,
                          isRunning: state.isRunning,
                          onIncrement: () => cubit.incrementSessionDuration(),
                          onDecrement: () => cubit.decrementSessionDuration(),
                          onSetValue: (value) => cubit.setTimerFromInput(value),
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
                              cubit.updateTotalCycles(state.totalCycles + 1),
                          onDecrement: () =>
                              cubit.updateTotalCycles(state.totalCycles - 1),
                          iconColor: gold,
                          showCompletedMessage:
                              state.currentCycle == state.totalCycles,
                        ),
                      ],
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
          );
        },
      ),
    );
  }
}
