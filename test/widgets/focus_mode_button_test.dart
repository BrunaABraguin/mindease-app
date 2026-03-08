import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mindease_app/src/app/widgets/focus_mode_button.dart';

void main() {
  testWidgets('FocusModeButton chama onPressed e mostra label', (tester) async {
    bool pressed = false;
    const label = 'Entrar no modo foco';

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: FocusModeButton(
            onPressed: () {
              pressed = true;
            },
          ),
        ),
      ),
    );

    // O botão deve estar presente
    expect(find.byIcon(Icons.fullscreen), findsOneWidget);
    expect(find.byTooltip(label), findsOneWidget);

    // Toca no botão
    await tester.tap(find.byIcon(Icons.fullscreen));
    await tester.pumpAndSettle();
    expect(pressed, isTrue);
  });

  testWidgets('FocusModeButton mostra icone de sair quando exit=true', (
    tester,
  ) async {
    const label = 'Sair do modo foco';
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(body: FocusModeButton(exit: true, onPressed: () {})),
      ),
    );
    expect(find.byIcon(Icons.fullscreen_exit), findsOneWidget);
    expect(find.byTooltip(label), findsOneWidget);
  });
}
