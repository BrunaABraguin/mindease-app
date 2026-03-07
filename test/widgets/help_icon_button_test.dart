import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mindease_app/src/app/utils/help_texts.dart';
import 'package:mindease_app/src/app/widgets/help_icon_button.dart';

void main() {
  testWidgets('HelpIcon exibe dialog com título e descrição corretos', (
    tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: HelpIconButton(
            title: HelpTexts.focusModeTitle,
            description: HelpTexts.focusModeDescription,
          ),
        ),
      ),
    );

    // O ícone deve estar presente
    expect(find.byIcon(Icons.help_outline), findsOneWidget);

    // Toca no ícone
    await tester.tap(find.byIcon(Icons.help_outline));
    await tester.pumpAndSettle();

    // O dialog deve aparecer com o título e descrição
    expect(find.text(HelpTexts.focusModeTitle), findsOneWidget);
    expect(find.text(HelpTexts.focusModeDescription), findsOneWidget);
    expect(find.text('Entendi'), findsOneWidget);
  });
}
