import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mindease_app/src/app/widgets/start_pause_button.dart';

void main() {
  group('StartPauseButton', () {
    testWidgets('shows play icon and calls onPressed when not running', (
      tester,
    ) async {
      var pressed = false;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: StartPauseButton(
              isRunning: false,
              onPressed: () => pressed = true,
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.play_arrow), findsOneWidget);
      await tester.tap(find.byType(IconButton));
      expect(pressed, isTrue);
    });

    testWidgets('shows pause icon when running', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: StartPauseButton(isRunning: true, onPressed: () {}),
          ),
        ),
      );

      expect(find.byIcon(Icons.pause), findsOneWidget);
    });
  });
}
