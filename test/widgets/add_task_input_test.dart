import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mindease_app/src/app/pages/tasks/widgets/add_task_input.dart';

void main() {
  group('AddTaskInput', () {
    testWidgets('renders text field with hint', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AddTaskInput(
              onSave: (_) {},
              onCancel: () {},
              hintText: 'Enter task',
            ),
          ),
        ),
      );

      expect(find.byType(TextField), findsOneWidget);
      expect(find.text('Enter task'), findsOneWidget);
      expect(find.byIcon(Icons.check_outlined), findsOneWidget);
    });

    testWidgets('calls onSave via check button with non-empty text', (
      tester,
    ) async {
      String? savedName;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AddTaskInput(
              onSave: (name) => savedName = name,
              onCancel: () {},
              hintText: 'Enter task',
            ),
          ),
        ),
      );

      await tester.enterText(find.byType(TextField), 'New task');
      await tester.tap(find.byIcon(Icons.check_outlined));
      expect(savedName, 'New task');
    });

    testWidgets('check button does nothing with empty text', (tester) async {
      String? savedName;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AddTaskInput(
              onSave: (name) => savedName = name,
              onCancel: () {},
              hintText: 'Enter task',
            ),
          ),
        ),
      );

      await tester.enterText(find.byType(TextField), '   ');
      await tester.tap(find.byIcon(Icons.check_outlined));
      expect(savedName, isNull);
    });

    testWidgets('calls onSave via onSubmitted', (tester) async {
      String? savedName;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AddTaskInput(
              onSave: (name) => savedName = name,
              onCancel: () {},
              hintText: 'Enter task',
            ),
          ),
        ),
      );

      await tester.enterText(find.byType(TextField), 'Submitted');
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pump();
      expect(savedName, 'Submitted');
    });

    testWidgets('onSubmitted does nothing with empty text', (tester) async {
      String? savedName;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AddTaskInput(
              onSave: (name) => savedName = name,
              onCancel: () {},
              hintText: 'Enter task',
            ),
          ),
        ),
      );

      await tester.enterText(find.byType(TextField), '');
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pump();
      expect(savedName, isNull);
    });
  });
}
