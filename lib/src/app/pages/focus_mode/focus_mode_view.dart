import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:mindease_app/src/app/pages/timer/timer_controller.dart';
import 'package:mindease_app/src/app/utils/app_constants.dart';
import 'package:mindease_app/src/app/utils/time_formatter.dart';
import 'package:mindease_app/src/app/widgets/focus_mode_button.dart';
import 'package:mindease_app/src/app/widgets/start_pause_button.dart';
import 'package:mindease_app/src/app/widgets/vertical_timer_progress.dart';
import 'package:mindease_app/src/domain/entities/timer_entity.dart';
import 'package:mindease_app/theme.dart';

class FocusModePage extends StatelessWidget {
  const FocusModePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const FocusModeView();
  }
}

class FocusModeView extends StatefulWidget {
  const FocusModeView({super.key});

  @override
  State<FocusModeView> createState() => _FocusModeViewState();
}

class _FocusModeViewState extends State<FocusModeView> {
  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  }

  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    super.dispose();
  }

  Color _modeBackgroundColor(int modeIndex, ColorScheme colorScheme) {
    switch (modeIndex) {
      case TimerCubit.modeShortBreak:
        return colorScheme.secondary;
      case TimerCubit.modeLongBreak:
        return colorScheme.primary;
      default:
        return colorScheme.inversePrimary;
    }
  }

  String _modeLabel(int modeIndex) {
    switch (modeIndex) {
      case TimerCubit.modeShortBreak:
        return AppStrings.shortBreakLabel;
      case TimerCubit.modeLongBreak:
        return AppStrings.longBreakLabel;
      default:
        return AppStrings.focusMode.toUpperCase();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TimerCubit, TimerEntity>(
      builder: (context, state) {
        final cubit = context.read<TimerCubit>();
        final colorScheme = Theme.of(context).colorScheme;
        final bgColor = _modeBackgroundColor(
          state.currentModeIndex,
          colorScheme,
        );
        final totalSeconds = cubit.getTotalSeconds(timer: state);
        final remainingSeconds = state.remainingSeconds ?? totalSeconds;
        final remainingCycles = state.totalCycles - state.currentCycle;

        return Scaffold(
          backgroundColor: bgColor,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: AppSizes.elevationNone,
            leading: FocusModeButton(
              exit: true,
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
          body: SafeArea(
            child: SizedBox.expand(
              child: Column(
                children: [
                  const SizedBox(height: AppSizes.spacingL),
                  Text(
                    _modeLabel(state.currentModeIndex),
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: AppTheme.focusModeForeground,
                      fontWeight: FontWeight.bold,
                      letterSpacing: AppSizes.focusModeLetterSpacing,
                    ),
                  ),
                  const Spacer(),
                  VerticalTimerProgress(
                    totalSeconds: totalSeconds,
                    remainingSeconds: remainingSeconds,
                    height: AppSizes.borderWidthMedium,
                    width:
                        MediaQuery.of(context).size.width *
                        AppSizes.focusModeProgressWidthFactor,
                    bottomMargin: AppSizes.spacingL,
                  ),
                  Text(
                    formatDuration(remainingSeconds),
                    style: Theme.of(context).textTheme.displayLarge?.copyWith(
                      color: AppTheme.focusModeForeground,
                      fontWeight: FontWeight.bold,
                      fontSize: AppSizes.timerFontSize,
                    ),
                  ),
                  const SizedBox(height: AppSizes.spacingL),
                  Text(
                    AppStrings.sessionsUntilLongBreak(remainingCycles),
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppTheme.focusModeForeground,
                    ),
                  ),
                  const Spacer(),
                  Padding(
                    padding: const EdgeInsets.only(
                      bottom: AppSizes.timerControlButtonsBottomPadding,
                    ),
                    child: StartPauseButton(
                      isRunning: state.isRunning,
                      onPressed: () => cubit.startPauseTimer(),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
