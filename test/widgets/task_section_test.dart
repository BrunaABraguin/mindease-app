import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mindease_app/src/app/pages/tasks/widgets/task_section.dart';
import 'package:mindease_app/src/domain/entities/task.dart';

void main() {
  group('TaskSection', () {
    final tasks = [
      const Task(id: '1', userEmail: 'u@e.com', name: 'Task A'),
      const Task(
        id: '2',
        userEmail: 'u@e.com',
        name: 'Task B',
        isDone: true,
      ),
    ];

    Widget buildWidget({
      List<Task> taskList = const [],
      int completedCount = 0,
      bool isAdding = false,
      String editingTaskId = '',
      int? maxItems,
      bool readOnly = false,
      VoidCallback? onStartAdding,
      void Function(String)? onSave,
      VoidCallback? onCancel,
      void Function(String)? onComplete,
      void Function(String)? onDelete,
      void Function(String, String)? onEditName,
      void Function(String)? onStartEditing,
      VoidCallback? onCancelEditing,
    }) {
      return MaterialApp(
        home: Scaffold(
          body: SingleChildScrollView(
            child: TaskSection(
              title: 'Tarefas',
              tasks: taskList,
              completedCount: completedCount,
              isAdding: isAdding,
              onStartAdding: onStartAdding ?? () {},
              onSave: onSave ?? (_) {},
              onCancel: onCancel ?? () {},
              onComplete: onComplete ?? (_) {},
              onDelete: onDelete ?? (_) {},
              onEditName: onEditName ?? (_, _) {},
              editingTaskId: editingTaskId,
              onStartEditing: onStartEditing ?? (_) {},
              onCancelEditing: onCancelEditing ?? () {},
              maxItems: maxItems,
              readOnly: readOnly,
            ),
          ),
        ),
      );
    }

    testWidgets('renders title and task count', (tester) async {
      await tester.pumpWidget(buildWidget(
        taskList: tasks,
        completedCount: 1,
      ));

      expect(find.text('Tarefas'), findsOneWidget);
      expect(find.text('(1/2)'), findsOneWidget);
    });

    testWidgets('renders count with maxItems', (tester) async {
      await tester.pumpWidget(buildWidget(
        taskList: tasks,
        completedCount: 1,
        maxItems: 5,
      ));

      expect(find.text('(1/5)'), findsOneWidget);
    });

    testWidgets('renders task cards for each task', (tester) async {
      await tester.pumpWidget(buildWidget(taskList: tasks));

      expect(find.text('Task A'), findsOneWidget);
      expect(find.text('Task B'), findsOneWidget);
    });

    testWidgets('shows add button when not readOnly', (tester) async {
      await tester.pumpWidget(buildWidget(taskList: tasks));

      expect(find.byIcon(Icons.add), findsOneWidget);
    });

    testWidgets('hides add button when readOnly', (tester) async {
      await tester.pumpWidget(buildWidget(
        taskList: tasks,
        readOnly: true,
      ));

      expect(find.byIcon(Icons.add), findsNothing);
    });

    testWidgets('add button triggers onStartAdding', (tester) async {
      var called = false;
      await tester.pumpWidget(buildWidget(
        taskList: tasks,
        onStartAdding: () => called = true,
      ));

      await tester.tap(find.byIcon(Icons.add));
      expect(called, isTrue);
    });

    testWidgets('shows AddTaskInput when isAdding is true', (tester) async {
      await tester.pumpWidget(buildWidget(isAdding: true));

      expect(find.text('Nome da tarefa'), findsOneWidget);
    });

    testWidgets('does not show AddTaskInput when readOnly even if isAdding',
        (tester) async {
      await tester.pumpWidget(buildWidget(
        isAdding: true,
        readOnly: true,
      ));

      expect(find.text('Nome da tarefa'), findsNothing);
    });

    testWidgets('add button disabled when tasks reach maxItems',
        (tester) async {
      var called = false;
      await tester.pumpWidget(buildWidget(
        taskList: tasks,
        maxItems: 2,
        onStartAdding: () => called = true,
      ));

      await tester.tap(find.byIcon(Icons.add));
      expect(called, isFalse);
    });
  });
}
