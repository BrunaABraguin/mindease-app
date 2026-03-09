import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mindease_app/src/app/pages/timer/widgets/settings_sessions.dart';
import 'package:mindease_app/src/app/widgets/cycle_completed_message.dart';

void main() {
  group('SettingsSessions', () {
    Widget buildWidget({
      int currentCycle = 1,
      int totalCycles = 4,
      bool isRunning = false,
      VoidCallback? onIncrement,
      VoidCallback? onDecrement,
      bool showCompletedMessage = false,
    }) {
      return MaterialApp(
        home: Scaffold(
          body: SettingsSessions(
            currentCycle: currentCycle,
            totalCycles: totalCycles,
            isRunning: isRunning,
            onIncrement: onIncrement ?? () {},
            onDecrement: onDecrement ?? () {},
            iconColor: Colors.blue,
            showCompletedMessage: showCompletedMessage,
          ),
        ),
      );
    }

    testWidgets('deve exibir ciclos no formato atual/total', (tester) async {
      await tester.pumpWidget(buildWidget(currentCycle: 2, totalCycles: 5));
      expect(find.text('2/5'), findsOneWidget);
    });

    testWidgets('botão de incremento deve chamar onIncrement', (tester) async {
      bool called = false;
      await tester.pumpWidget(buildWidget(onIncrement: () => called = true));

      await tester.tap(find.byIcon(Icons.add_circle_outline));
      await tester.pump();
      expect(called, isTrue);
    });

    testWidgets('botão de decremento deve chamar onDecrement', (tester) async {
      bool called = false;
      await tester.pumpWidget(buildWidget(onDecrement: () => called = true));

      await tester.tap(find.byIcon(Icons.remove_circle_outline));
      await tester.pump();
      expect(called, isTrue);
    });

    testWidgets('botões desabilitados quando timer está rodando', (
      tester,
    ) async {
      bool incrementCalled = false;
      bool decrementCalled = false;

      await tester.pumpWidget(
        buildWidget(
          isRunning: true,
          onIncrement: () => incrementCalled = true,
          onDecrement: () => decrementCalled = true,
        ),
      );

      await tester.tap(find.byIcon(Icons.add_circle_outline));
      await tester.tap(find.byIcon(Icons.remove_circle_outline));
      await tester.pump();

      expect(incrementCalled, isFalse);
      expect(decrementCalled, isFalse);
    });

    testWidgets('botão decremento desabilitado quando totalCycles <= 1', (
      tester,
    ) async {
      bool called = false;
      await tester.pumpWidget(
        buildWidget(totalCycles: 1, onDecrement: () => called = true),
      );

      await tester.tap(find.byIcon(Icons.remove_circle_outline));
      await tester.pump();
      expect(called, isFalse);
    });

    testWidgets('botão incremento desabilitado quando totalCycles >= 10', (
      tester,
    ) async {
      bool called = false;
      await tester.pumpWidget(
        buildWidget(totalCycles: 10, onIncrement: () => called = true),
      );

      await tester.tap(find.byIcon(Icons.add_circle_outline));
      await tester.pump();
      expect(called, isFalse);
    });

    testWidgets('deve exibir mensagem de ciclo completado', (tester) async {
      await tester.pumpWidget(buildWidget(showCompletedMessage: true));
      // CycleCompletedMessage should be rendered when showCompletedMessage is true
      expect(find.byType(CycleCompletedMessage), findsOneWidget);
    });

    testWidgets('não deve exibir mensagem quando showCompletedMessage é false', (
      tester,
    ) async {
      await tester.pumpWidget(buildWidget());
      // CycleCompletedMessage should not be rendered when showCompletedMessage is false
      expect(find.byType(CycleCompletedMessage), findsNothing);
    });

  });
}