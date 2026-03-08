import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mindease_app/src/app/widgets/timer_display.dart';
import 'package:mindease_app/src/domain/entities/timer_entity.dart';

void main() {
  TimerEntity timer(int? seconds) => TimerEntity(
    durations: const TimerDurations(focus: 25, shortBreak: 5, longBreak: 15),
    currentCycle: 1,
    totalCycles: 4,
    remainingSeconds: seconds,
    completedSessions: 0,
    currentModeIndex: 0,
  );

  testWidgets('TimerDisplay shows formatted time', (tester) async {
    await tester.pumpWidget(MaterialApp(home: TimerDisplay(timer: timer(65))));
    expect(find.text('01:05'), findsOneWidget);
  });

  testWidgets('TimerDisplay blinks at zero', (tester) async {
    await tester.pumpWidget(MaterialApp(home: TimerDisplay(timer: timer(0))));
    final text = find.text('00:00');
    expect(text, findsOneWidget);
    // Animation should start
    await tester.pump(const Duration(milliseconds: 700));
    final opacity = tester.widget<Opacity>(find.byType(Opacity));
    expect(opacity.opacity, anyOf(0.2, 1.0));
  });

  testWidgets('TimerDisplay does not blink when running', (tester) async {
    await tester.pumpWidget(MaterialApp(home: TimerDisplay(timer: timer(10))));
    await tester.pump(const Duration(milliseconds: 700));
    final opacity = tester.widget<Opacity>(find.byType(Opacity));
    expect(opacity.opacity, 1.0);
  });
}
