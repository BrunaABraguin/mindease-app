import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mindease_app/src/app/pages/focus_mode/focus_mode_view.dart';
import 'package:mindease_app/src/app/pages/timer/timer_controller.dart';
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
      create: (_) => TimerCubit(timerRepository: widget.timerRepository),
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
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const FocusModePage()),
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
          return Align(
            alignment: Alignment.topCenter,
            child: Container(
              constraints: BoxConstraints(
                maxWidth: getResponsiveMaxWidth(context),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                //Seleção do timer mode e display do timer
                children: [
                  const Row(
                    children: [
                      Spacer(),
                      // Ícone de ajuda para o timer
                      HelpIconButton(
                        title: HelpTexts.timerTitle,
                        description: HelpTexts.timerDescription,
                        size: AppSizes.iconSmall,
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSizes.spacingS),
                  // Timer mode selection
                  TimerSegmentedButton(
                    selectedIndex: state.currentModeIndex,
                    onChanged: state.isRunning
                        ? null
                        : (index) {
                            context.read<TimerCubit>().updateCurrentModeIndex(
                              index,
                            );
                          },
                    disabled: state.isRunning,
                  ),
                  const SizedBox(height: AppSizes.spacingL),
                  VerticalTimerProgress(
                    totalSeconds: context.read<TimerCubit>().getTotalSeconds(timer: state),
                    remainingSeconds:
                        state.remainingSeconds ??
                        context.read<TimerCubit>().getTotalSeconds(timer: state),
                  ),
                  const SizedBox(height: AppSizes.spacingM),
                  Expanded(
                    child: Center(
                      child: TimerDisplay(
                        timer: state,
                        isRunning: state.isRunning,
                        onIncrement: () {
                          final cubit = context.read<TimerCubit>();
                          cubit.incrementSessionDuration();
                        },
                        onDecrement: () {
                          final cubit = context.read<TimerCubit>();
                          cubit.decrementSessionDuration();
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSizes.spacingXxl),

                  Padding(
                    padding: const EdgeInsets.only(
                      bottom: AppSizes.timerControlButtonsBottomPadding,
                    ),
                    child: Center(
                      child: BlocBuilder<TimerCubit, TimerEntity>(
                        buildWhen: (previous, current) =>
                            previous.remainingSeconds !=
                            current.remainingSeconds,
                        builder: (context, _) {
                          final cubit = context.read<TimerCubit>();
                          return TimerControlButtons(
                            onStartPause: () {
                              cubit.startPauseTimer();
                            },
                            onReset: () {
                              cubit.resetTimer();
                            },
                            isRunning: state.isRunning,
                          );
                        },
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
