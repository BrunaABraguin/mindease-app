import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mindease_app/src/app/widgets/vertical_timer_progress.dart';

void main() {
  testWidgets('VerticalTimerProgress renders correct progress', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: VerticalTimerProgress(totalSeconds: 100, remainingSeconds: 50),
        ),
      ),
    );
    final progressFinder = find.byType(LinearProgressIndicator);
    expect(progressFinder, findsOneWidget);
    final LinearProgressIndicator progress = tester.widget(progressFinder);
    expect(progress.value, closeTo(0.5, 0.01));
  });

  testWidgets('VerticalTimerProgress handles zero totalSeconds', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: VerticalTimerProgress(totalSeconds: 0, remainingSeconds: 0),
        ),
      ),
    );
    final progress = tester.widget<LinearProgressIndicator>(
      find.byType(LinearProgressIndicator),
    );
    expect(progress.value, 0.0);
  });
}
