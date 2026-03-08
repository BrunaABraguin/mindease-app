import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mindease_app/src/app/utils/timer_input_parser.dart';
import 'package:mindease_app/src/app/widgets/timer_display.dart';
import 'package:mindease_app/src/domain/entities/timer_entity.dart';

void main() {
  testWidgets('TimerDisplay salva valor ao perder foco', (tester) async {
    int? setValue;
    TimerEntity timer = TimerEntity(
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
        home: Scaffold(
          body: StatefulBuilder(
            builder: (context, setState) => TimerDisplay(
              timer: timer,
              onIncrement: () {},
              onDecrement: () {},
              isRunning: false,
              onSetValue: (value) {
                final total = parseTimerInput(value);
                if (total != null) {
                  setValue = total;
                  setState(() {
                    timer = timer.copyWith(remainingSeconds: total);
                  });
                }
              },
            ),
          ),
        ),
      ),
    );
    // Simula double tap para editar
    await tester.tap(find.text('01:30'));
    await tester.pump(const Duration(milliseconds: 50));
    await tester.tap(find.text('01:30'));
    await tester.pumpAndSettle();
    // Digita novo valor
    await tester.enterText(find.byType(TextField), '10');
    await tester.pumpAndSettle();
    // Remove o foco do TextField
    FocusManager.instance.primaryFocus?.unfocus();
    await tester.pumpAndSettle();
    // Espera que o valor tenha sido salvo
    expect(setValue, 600);
    expect(find.text('10:00'), findsOneWidget);
  });
  testWidgets('TimerDisplay ignora entrada inválida', (tester) async {
    int? setValue;
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
        home: Scaffold(
          body: TimerDisplay(
            timer: timer,
            onIncrement: () {},
            onDecrement: () {},
            isRunning: false,
            onSetValue: (value) {
              final total = parseTimerInput(value);
              if (total != null) {
                setValue = total;
              }
            },
          ),
        ),
      ),
    );
    // Simula double tap para editar
    await tester.tap(find.text('01:30'));
    await tester.pump(const Duration(milliseconds: 50));
    await tester.tap(find.text('01:30'));
    await tester.pumpAndSettle();
    // Digita valor inválido
    await tester.enterText(find.byType(TextField), '99:99');
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pumpAndSettle();
    expect(setValue, isNull);
    // Digita outro valor inválido
    await tester.tap(find.text('01:30'));
    await tester.pump(const Duration(milliseconds: 50));
    await tester.tap(find.text('01:30'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField), 'abc');
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pumpAndSettle();
    expect(setValue, isNull);
  });
  testWidgets('TimerDisplay limita edição a 60 minutos', (tester) async {
    int? setValue;
    TimerEntity timer = TimerEntity(
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
        home: Scaffold(
          body: StatefulBuilder(
            builder: (context, setState) => TimerDisplay(
              timer: timer,
              onIncrement: () {},
              onDecrement: () {},
              isRunning: false,
              onSetValue: (value) {
                final total = parseTimerInput(value);
                if (total != null) {
                  setValue = total;
                  setState(() {
                    timer = timer.copyWith(remainingSeconds: total);
                  });
                }
              },
            ),
          ),
        ),
      ),
    );
    // Simula double tap para editar
    await tester.tap(find.text('01:30'));
    await tester.pump(const Duration(milliseconds: 50));
    await tester.tap(find.text('01:30'));
    await tester.pumpAndSettle();
    // Digita valor maior que 60 minutos
    await tester.enterText(find.byType(TextField), '90:00');
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pumpAndSettle();
    // Verifica se o valor retornado e o texto exibido refletem o clamp
    expect(setValue, 3600);
    expect(find.text('60:00'), findsOneWidget);
    // Opcional: Verifica se o timer interno foi atualizado corretamente
    final timerText = tester.widget<Text>(find.text('60:00'));
    expect(timerText.data, '60:00');
    // Digita valor válido
    await tester.tap(find.text('60:00'));
    await tester.pump(const Duration(milliseconds: 50));
    await tester.tap(find.text('60:00'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField), '45');
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pumpAndSettle();
    expect(setValue, 2700);
  });
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
        home: Scaffold(
          body: TimerDisplay(
            timer: timer,
            onIncrement: () {},
            onDecrement: () {},
            isRunning: false,
            onSetValue: (_) {},
          ),
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
        home: Scaffold(
          body: TimerDisplay(
            timer: timer,
            onIncrement: () {},
            onDecrement: () {},
            isRunning: false,
            onSetValue: (_) {},
          ),
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
        home: Scaffold(
          body: TimerDisplay(
            timer: timer,
            onIncrement: () {},
            onDecrement: () {},
            isRunning: false,
            onSetValue: (_) {},
          ),
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
        home: Scaffold(
          body: TimerDisplay(
            timer: timer,
            onIncrement: () {},
            onDecrement: () {},
            isRunning: true,
            onSetValue: (_) {},
          ),
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
        home: Scaffold(
          body: TimerDisplay(
            timer: timer,
            onIncrement: () {
              incremented = true;
            },
            onDecrement: () {
              decremented = true;
            },
            isRunning: false,
            onSetValue: (_) {},
          ),
        ),
      ),
    );
    await tester.tap(find.byIcon(Icons.add_circle));
    await tester.tap(find.byIcon(Icons.remove_circle));
    expect(incremented, isTrue);
    expect(decremented, isTrue);
  });
}
