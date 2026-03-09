import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mindease_app/src/app/pages/focus_mode/focus_mode_view.dart';
import 'package:mindease_app/src/app/pages/timer/timer_controller.dart';
import 'package:mindease_app/src/app/widgets/focus_mode_button.dart';
import 'package:mindease_app/src/data/repositories/timer_repository.dart';

void main() {
  group('FocusModeView interactions', () {
    testWidgets('renders play button and mode label', (tester) async {
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

      expect(find.byIcon(Icons.play_arrow), findsOneWidget);
      expect(find.text('MODO FOCO'), findsOneWidget);

      await timerCubit.close();
    });

    testWidgets('renders exit focus mode button', (tester) async {
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

      // Should have exit button (FocusModeButton with exit: true)
      expect(find.byType(FocusModeButton), findsOneWidget);
      expect(find.byIcon(Icons.fullscreen_exit), findsOneWidget);

      await timerCubit.close();
    });

    testWidgets('displays remaining cycles text', (tester) async {
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

      // Should show sessions until long break
      expect(find.textContaining('sessões'), findsOneWidget);

      await timerCubit.close();
    });

    testWidgets('displays timer text with colon format', (tester) async {
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

      // Should show a time formatted with colon (e.g. "25:00")
      expect(find.textContaining(':'), findsOneWidget);

      await timerCubit.close();
    });
  });
}
