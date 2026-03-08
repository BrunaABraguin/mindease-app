import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mindease_app/src/app/widgets/timer_display.dart';
import 'package:mindease_app/src/domain/entities/timer_entity.dart';

void main() {
  testWidgets('TimerDisplay pisca quando o tempo é zero', (tester) async {
    final timer = TimerEntity(
      durations: const TimerDurations(
        focus: 1500,
        shortBreak: 300,
        longBreak: 900,
      ),
      currentCycle: 1,
      totalCycles: 4,
      remainingSeconds: 0,
      completedSessions: 0,
      currentModeIndex: 0,
    );
    await tester.pumpWidget(
      MaterialApp(
        home: TimerDisplay(
          timer: timer,
          onIncrement: () {},
          onDecrement: () {},
          isRunning: false,
        ),
      ),
    );
    final text = find.text('00:00');
    expect(text, findsOneWidget);
    // Animation should start
    await tester.pump(const Duration(milliseconds: 700));
    final opacity = tester.widget<Opacity>(find.byType(Opacity));
    expect(opacity.opacity, anyOf(0.2, 1.0));
  });

  testWidgets('TimerDisplay não pisca quando rodando', (tester) async {
    final timer = TimerEntity(
      durations: const TimerDurations(
        focus: 1500,
        shortBreak: 300,
        longBreak: 900,
      ),
      currentCycle: 1,
      totalCycles: 4,
      remainingSeconds: 10,
      completedSessions: 0,
      currentModeIndex: 0,
    );
    await tester.pumpWidget(
      MaterialApp(
        home: TimerDisplay(
          timer: timer,
          onIncrement: () {},
          onDecrement: () {},
          isRunning: false,
        ),
      ),
    );
    await tester.pump(const Duration(milliseconds: 700));
    final opacity = tester.widget<Opacity>(find.byType(Opacity));
    expect(opacity.opacity, 1.0);
  });
  testWidgets('TimerDisplay mostra tempo formatado corretamente', (
    tester,
  ) async {
    final timer = TimerEntity(
      durations: const TimerDurations(
        focus: 1500,
        shortBreak: 300,
        longBreak: 900,
      ),
      currentCycle: 1,
      totalCycles: 4,
      remainingSeconds: 90,
      completedSessions: 0,
      currentModeIndex: 0,
    );
    await tester.pumpWidget(
      MaterialApp(
        home: TimerDisplay(
          timer: timer,
          onIncrement: () {},
          onDecrement: () {},
          isRunning: false,
        ),
      ),
    );
    expect(find.text('01:30'), findsOneWidget);
  });

  testWidgets('Botões ficam desabilitados quando isRunning=true', (
    tester,
  ) async {
    final timer = TimerEntity(
      durations: const TimerDurations(
        focus: 1500,
        shortBreak: 300,
        longBreak: 900,
      ),
      currentCycle: 1,
      totalCycles: 4,
      remainingSeconds: 90,
      completedSessions: 0,
      currentModeIndex: 0,
    );
    await tester.pumpWidget(
      MaterialApp(
        home: TimerDisplay(
          timer: timer,
          onIncrement: () {},
          onDecrement: () {},
          isRunning: true,
        ),
      ),
    );
    final addButton = tester.widget<IconButton>(
      find.descendant(
        of: find.bySemanticsLabel('Aumentar tempo'),
        matching: find.byType(IconButton),
      ),
    );
    final removeButton = tester.widget<IconButton>(
      find.descendant(
        of: find.bySemanticsLabel('Diminuir tempo'),
        matching: find.byType(IconButton),
      ),
    );
    expect(addButton.onPressed, isNull);
    expect(removeButton.onPressed, isNull);
  });

  testWidgets('Botões chamam callbacks quando habilitados', (tester) async {
    bool incremented = false;
    bool decremented = false;
    final timer = TimerEntity(
      durations: const TimerDurations(
        focus: 1500,
        shortBreak: 300,
        longBreak: 900,
      ),
      currentCycle: 1,
      totalCycles: 4,
      remainingSeconds: 90,
      completedSessions: 0,
      currentModeIndex: 0,
    );
    await tester.pumpWidget(
      MaterialApp(
        home: TimerDisplay(
          timer: timer,
          onIncrement: () {
            incremented = true;
          },
          onDecrement: () {
            decremented = true;
          },
          isRunning: false,
        ),
      ),
    );
    await tester.tap(find.byIcon(Icons.add));
    await tester.tap(find.byIcon(Icons.remove));
    expect(incremented, isTrue);
    expect(decremented, isTrue);
  });
}
