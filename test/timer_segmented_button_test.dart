import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mindease_app/src/app/pages/timer/timer_segmented_button.dart';

void main() {
  testWidgets('TimerSegmentedButton exibe opções e responde ao toque', (
    tester,
  ) async {
    int selectedIndex = 0;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: TimerSegmentedButton(
            selectedIndex: selectedIndex,
            onChanged: (index) {
              selectedIndex = index;
            },
          ),
        ),
      ),
    );

    // Verifica se as três opções estão presentes
    expect(find.text('Foco'), findsOneWidget);
    expect(find.text('Pausa curta'), findsOneWidget);
    expect(find.text('Pausa longa'), findsOneWidget);

    // Toca na opção "Pausa curta"
    await tester.tap(find.text('Pausa curta'));
    await tester.pumpAndSettle();
    // O selectedIndex deve ser alterado para 1
    expect(selectedIndex, 1);

    // Toca na opção "Pausa longa"
    await tester.tap(find.text('Pausa longa'));
    await tester.pumpAndSettle();
    expect(selectedIndex, 2);
  });
}
