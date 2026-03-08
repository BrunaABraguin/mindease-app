import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mindease_app/src/app/utils/help_texts.dart';
import 'package:mindease_app/src/app/widgets/cycle_completed_message.dart';

void main() {
  group('CycleCompletedMessage', () {
    testWidgets('renders the completed message text', (
      tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: CycleCompletedMessage())),
      );
      expect(find.text(HelpTexts.cyclesCompletedMessage), findsOneWidget);
    });

    testWidgets('has correct text style and alignment', (
      tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: CycleCompletedMessage())),
      );
      final textWidget = tester.widget<Text>(
        find.text(HelpTexts.cyclesCompletedMessage),
      );
      expect(textWidget.textAlign, TextAlign.center);
    });
  });
}
