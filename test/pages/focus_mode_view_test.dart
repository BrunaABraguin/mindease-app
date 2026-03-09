import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mindease_app/src/app/pages/focus_mode/focus_mode_view.dart';
import 'package:mindease_app/src/app/pages/timer/timer_controller.dart';
import 'package:mindease_app/src/data/repositories/timer_repository.dart';

void main() {
  group('FocusModeView', () {
    testWidgets('renders timer text and back button', (tester) async {
      final timerCubit = TimerCubit(
        timerRepository: TimerRepository(),
        tickDuration: const Duration(seconds: 10),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<TimerCubit>.value(
            value: timerCubit,
            child: const FocusModeView(),
          ),
        ),
      );

      // Should show the mode label
      expect(find.text('MODO FOCO'), findsOneWidget);
      // Should show the timer display
      expect(find.textContaining(':'), findsOneWidget);
      // Should have a back button
      expect(find.byType(IconButton), findsWidgets);
    });

    testWidgets('renders short break label when mode is shortBreak', (
      tester,
    ) async {
      final timerCubit = TimerCubit(
        timerRepository: TimerRepository(),
        tickDuration: const Duration(seconds: 10),
      );
      timerCubit.updateCurrentModeIndex(TimerCubit.modeShortBreak);

      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<TimerCubit>.value(
            value: timerCubit,
            child: const FocusModeView(),
          ),
        ),
      );

      expect(find.text('PAUSA CURTA'), findsOneWidget);
    });

    testWidgets('renders long break label when mode is longBreak', (
      tester,
    ) async {
      final timerCubit = TimerCubit(
        timerRepository: TimerRepository(),
        tickDuration: const Duration(seconds: 10),
      );
      timerCubit.updateCurrentModeIndex(TimerCubit.modeLongBreak);

      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<TimerCubit>.value(
            value: timerCubit,
            child: const FocusModeView(),
          ),
        ),
      );

      expect(find.text('PAUSA LONGA'), findsOneWidget);
    });
  });
}
