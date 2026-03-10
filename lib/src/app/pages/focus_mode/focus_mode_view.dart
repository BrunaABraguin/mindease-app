import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:mindease_app/src/app/pages/profile/profile_controller.dart';
import 'package:mindease_app/src/app/pages/timer/timer_controller.dart';
import 'package:mindease_app/src/app/utils/app_assets.dart';
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

class _FocusModeViewState extends State<FocusModeView>
    with SingleTickerProviderStateMixin {
  late final AnimationController _rotationController;

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    _rotationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: AppConstants.zoltraakRotationSeconds),
    )..repeat();
  }

  @override
  void dispose() {
    _rotationController.dispose();
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
                Stack(
                  alignment: Alignment.center,
                  children: [
                    // Rotating Zoltraak background image
                    Builder(
                      builder: (context) {
                        final showAnimations = context
                            .read<ProfileCubit>()
                            .state
                            .preferences
                            .showAnimations;
                        final image = Opacity(
                          opacity: AppOpacity.heavy,
                          child: Image.asset(
                            AppAssets.zoltraak,
                            width: AppSizes.zoltraakImageSize,
                            height: AppSizes.zoltraakImageSize,
                            fit: BoxFit.contain,
                          ),
                        );
                        if (!showAnimations) return image;
                        return AnimatedBuilder(
                          animation: _rotationController,
                          builder: (context, child) {
                            return Transform.rotate(
                              angle: _rotationController.value * 2 * math.pi,
                              child: child,
                            );
                          },
                          child: image,
                        );
                      },
                    ),
                    // Timer display
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
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
                          style: Theme.of(context).textTheme.displayLarge
                              ?.copyWith(
                                color: AppTheme.focusModeForeground,
                                fontWeight: FontWeight.bold,
                                fontSize: AppSizes.timerFontSize,
                              ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: AppSizes.spacingL),
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
        );
      },
    );
  }
}
