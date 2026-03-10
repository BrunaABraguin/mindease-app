import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mindease_app/src/app/pages/habits/widgets/add_habit_input.dart';
import 'package:mindease_app/src/app/utils/app_constants.dart';

void main() {
  Widget buildInput({void Function(String)? onSave, VoidCallback? onCancel}) {
    return MaterialApp(
      home: Scaffold(
        body: AddHabitInput(
          onSave: onSave ?? (_) {},
          onCancel: onCancel ?? () {},
        ),
      ),
    );
  }

  group('AddHabitInput', () {
    testWidgets('renders text field with hint and action buttons', (
      tester,
    ) async {
      await tester.pumpWidget(buildInput());

      expect(find.text(AppStrings.habitNameHint), findsOneWidget);
      expect(find.byIcon(Icons.check), findsOneWidget);
      expect(find.byIcon(Icons.close), findsOneWidget);
    });

    testWidgets('calls onSave via check button when text is not empty', (
      tester,
    ) async {
      String? savedName;
      await tester.pumpWidget(buildInput(onSave: (name) => savedName = name));

      await tester.enterText(find.byType(TextField), 'New Habit');
      await tester.tap(find.byIcon(Icons.check));
      expect(savedName, 'New Habit');
    });

    testWidgets('does not call onSave when text is empty', (tester) async {
      var called = false;
      await tester.pumpWidget(buildInput(onSave: (_) => called = true));

      await tester.tap(find.byIcon(Icons.check));
      expect(called, isFalse);
    });

    testWidgets('calls onSave via submit (keyboard)', (tester) async {
      String? savedName;
      await tester.pumpWidget(buildInput(onSave: (name) => savedName = name));

      await tester.enterText(find.byType(TextField), 'Keyboard Habit');
      await tester.testTextInput.receiveAction(TextInputAction.done);
      expect(savedName, 'Keyboard Habit');
    });

    testWidgets('does not call onSave via submit when text is whitespace', (
      tester,
    ) async {
      var called = false;
      await tester.pumpWidget(buildInput(onSave: (_) => called = true));

      await tester.enterText(find.byType(TextField), '   ');
      await tester.testTextInput.receiveAction(TextInputAction.done);
      expect(called, isFalse);
    });

    testWidgets('calls onCancel via close button', (tester) async {
      var cancelled = false;
      await tester.pumpWidget(buildInput(onCancel: () => cancelled = true));

      await tester.tap(find.byIcon(Icons.close));
      expect(cancelled, isTrue);
    });
  });
}
