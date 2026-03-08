import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mindease_app/src/app/pages/timer/widgets/timer_segmented_button.dart';

class _TestWrapper extends StatefulWidget {
  const _TestWrapper();

  @override
  State<_TestWrapper> createState() => _TestWrapperState();
}

class _TestWrapperState extends State<_TestWrapper> {
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return TimerSegmentedButton(
      selectedIndex: selectedIndex,
      onChanged: (index) {
        setState(() {
          selectedIndex = index;
        });
      },
    );
  }
}

void main() {
  testWidgets('TimerSegmentedButton exibe opções e responde ao toque', (
    tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(home: Scaffold(body: _TestWrapper())),
    );

    // Verifica se as três opções estão presentes
    expect(find.text('Foco'), findsOneWidget);
    expect(find.text('Pausa curta'), findsOneWidget);
    expect(find.text('Pausa longa'), findsOneWidget);

    // Toca na opção "Pausa curta"
    await tester.tap(find.text('Pausa curta'));
    await tester.pumpAndSettle();
    // O selectedIndex deve ser alterado para 1 (ícone selecionado)
    final selected = tester
        .widget<SegmentedButton<int>>(find.byType(SegmentedButton<int>))
        .selected;
    expect(selected, contains(1));

    // Toca na opção "Pausa longa"
    await tester.tap(find.text('Pausa longa'));
    await tester.pumpAndSettle();
    final selected2 = tester
        .widget<SegmentedButton<int>>(find.byType(SegmentedButton<int>))
        .selected;
    expect(selected2, contains(2));
  });
}
