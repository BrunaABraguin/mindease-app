import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:mindease_app/src/app/pages/timer/widgets/timer_control_buttons.dart';

void main() {
  testWidgets('TimerControlButtons calls onStartPause and onReset', (
    tester,
  ) async {
    bool started = false;
    bool reset = false;
    await tester.pumpWidget(
      MaterialApp(
        home: TimerControlButtons(
          onStartPause: () => started = true,
          onReset: () => reset = true,
          isRunning: false,
        ),
      ),
    );
    await tester.tap(find.text('Iniciar'));
    await tester.pump();
    expect(started, isTrue);
    await tester.tap(find.text('Reiniciar'));
    await tester.pump();
    expect(reset, isTrue);
  });

  testWidgets('TimerControlButtons shows correct labels/icons', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: TimerControlButtons(
          onStartPause: () {},
          onReset: () {},
          isRunning: true,
        ),
      ),
    );
    expect(find.text('Parar'), findsOneWidget);
    expect(find.byIcon(Icons.pause), findsOneWidget);
    expect(find.text('Reiniciar'), findsOneWidget);
    expect(find.byIcon(Icons.restart_alt), findsOneWidget);
  });
}
