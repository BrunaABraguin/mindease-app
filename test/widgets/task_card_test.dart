import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mindease_app/src/app/pages/tasks/widgets/task_card.dart';

void main() {
  group('TaskCard', () {
    testWidgets('renders task name when not editing and not done', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TaskCard(
              name: 'My Task',
              isDone: false,
              onComplete: () {},
              onDelete: () {},
              onEditName: (_) {},
              isEditing: false,
              onStartEditing: () {},
              onCancelEditing: () {},
            ),
          ),
        ),
      );

      expect(find.text('My Task'), findsOneWidget);
      expect(find.byIcon(Icons.check), findsNothing);
    });

    testWidgets('renders check icon when done', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TaskCard(
              name: 'Done Task',
              isDone: true,
              onComplete: () {},
              onDelete: () {},
              onEditName: (_) {},
              isEditing: false,
              onStartEditing: () {},
              onCancelEditing: () {},
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.check), findsOneWidget);
    });

    testWidgets('calls onComplete when circle tapped and not done', (
      tester,
    ) async {
      var completed = false;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TaskCard(
              name: 'Task',
              isDone: false,
              onComplete: () => completed = true,
              onDelete: () {},
              onEditName: (_) {},
              isEditing: false,
              onStartEditing: () {},
              onCancelEditing: () {},
            ),
          ),
        ),
      );

      // Tap the circle (GestureDetector wrapping the container)
      final circles = find.byType(GestureDetector);
      await tester.tap(circles.first);
      expect(completed, true);
    });

    testWidgets('calls onDelete when close button tapped', (tester) async {
      var deleted = false;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TaskCard(
              name: 'Task',
              isDone: false,
              onComplete: () {},
              onDelete: () => deleted = true,
              onEditName: (_) {},
              isEditing: false,
              onStartEditing: () {},
              onCancelEditing: () {},
            ),
          ),
        ),
      );

      await tester.tap(find.byIcon(Icons.close));
      expect(deleted, true);
    });

    testWidgets('double tap calls onStartEditing when not done', (
      tester,
    ) async {
      var startedEditing = false;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TaskCard(
              name: 'Editable',
              isDone: false,
              onComplete: () {},
              onDelete: () {},
              onEditName: (_) {},
              isEditing: false,
              onStartEditing: () => startedEditing = true,
              onCancelEditing: () {},
            ),
          ),
        ),
      );

      await tester.tap(find.text('Editable'));
      await tester.pump(const Duration(milliseconds: 50));
      await tester.tap(find.text('Editable'));
      await tester.pumpAndSettle();

      expect(startedEditing, true);
    });

    testWidgets('shows text field and buttons when editing', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TaskCard(
              name: 'Edit Me',
              isDone: false,
              onComplete: () {},
              onDelete: () {},
              onEditName: (_) {},
              isEditing: true,
              onStartEditing: () {},
              onCancelEditing: () {},
            ),
          ),
        ),
      );

      expect(find.byType(TextField), findsOneWidget);
      expect(find.byIcon(Icons.check_outlined), findsOneWidget);
      expect(find.byIcon(Icons.close), findsOneWidget);
    });

    testWidgets('calls onEditName via check button when editing', (
      tester,
    ) async {
      String? editedName;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TaskCard(
              name: 'Old',
              isDone: false,
              onComplete: () {},
              onDelete: () {},
              onEditName: (name) => editedName = name,
              isEditing: true,
              onStartEditing: () {},
              onCancelEditing: () {},
            ),
          ),
        ),
      );

      await tester.enterText(find.byType(TextField), 'New Name');
      await tester.tap(find.byIcon(Icons.check_outlined));
      expect(editedName, 'New Name');
    });

    testWidgets('calls onEditName via onSubmitted', (tester) async {
      String? editedName;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TaskCard(
              name: 'Old',
              isDone: false,
              onComplete: () {},
              onDelete: () {},
              onEditName: (name) => editedName = name,
              isEditing: true,
              onStartEditing: () {},
              onCancelEditing: () {},
            ),
          ),
        ),
      );

      await tester.enterText(find.byType(TextField), 'Submitted');
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pump();
      expect(editedName, 'Submitted');
    });

    testWidgets('check button does nothing with empty text', (tester) async {
      String? editedName;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TaskCard(
              name: 'Old',
              isDone: false,
              onComplete: () {},
              onDelete: () {},
              onEditName: (name) => editedName = name,
              isEditing: true,
              onStartEditing: () {},
              onCancelEditing: () {},
            ),
          ),
        ),
      );

      await tester.enterText(find.byType(TextField), '   ');
      await tester.tap(find.byIcon(Icons.check_outlined));
      expect(editedName, isNull);
    });

    testWidgets('onSubmitted does nothing with empty text', (tester) async {
      String? editedName;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TaskCard(
              name: 'Old',
              isDone: false,
              onComplete: () {},
              onDelete: () {},
              onEditName: (name) => editedName = name,
              isEditing: true,
              onStartEditing: () {},
              onCancelEditing: () {},
            ),
          ),
        ),
      );

      await tester.enterText(find.byType(TextField), '');
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pump();
      expect(editedName, isNull);
    });

    testWidgets('calls onCancelEditing when close tapped in editing mode', (
      tester,
    ) async {
      var cancelled = false;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TaskCard(
              name: 'Task',
              isDone: false,
              onComplete: () {},
              onDelete: () {},
              onEditName: (_) {},
              isEditing: true,
              onStartEditing: () {},
              onCancelEditing: () => cancelled = true,
            ),
          ),
        ),
      );

      await tester.tap(find.byIcon(Icons.close));
      expect(cancelled, true);
    });

    testWidgets('didUpdateWidget resets text when entering editing mode', (
      tester,
    ) async {
      var isEditing = false;
      await tester.pumpWidget(
        MaterialApp(
          home: StatefulBuilder(
            builder: (context, setState) => Scaffold(
              body: TaskCard(
                name: 'Original',
                isDone: false,
                onComplete: () {},
                onDelete: () {},
                onEditName: (_) {},
                isEditing: isEditing,
                onStartEditing: () => setState(() => isEditing = true),
                onCancelEditing: () {},
              ),
            ),
          ),
        ),
      );

      // Double tap to start editing
      await tester.tap(find.text('Original'));
      await tester.pump(const Duration(milliseconds: 50));
      await tester.tap(find.text('Original'));
      await tester.pumpAndSettle();

      // TextField should show 'Original'
      final textField = tester.widget<TextField>(find.byType(TextField));
      expect(textField.controller!.text, 'Original');
    });
  });
}
