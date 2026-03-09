import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mindease_app/src/app/pages/focus_mode/widgets/start_pause_button.dart';

void main() {
  group('StartPauseButton (focus_mode)', () {
    testWidgets('shows play icon when not running', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: StartPauseButton(
              isRunning: false,
              onPressed: () {},
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.play_arrow), findsOneWidget);
    });

    testWidgets('shows pause icon when running', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: StartPauseButton(
              isRunning: true,
              onPressed: () {},
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.pause), findsOneWidget);
    });

    testWidgets('calls onPressed when tapped', (tester) async {
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

      await tester.tap(find.byType(IconButton));
      expect(pressed, isTrue);
    });
  });
}
