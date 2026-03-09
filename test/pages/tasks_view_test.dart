import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mindease_app/src/app/pages/tasks/tasks_view.dart';
import 'package:mindease_app/src/app/utils/app_constants.dart';

void main() {
  group('TasksPage', () {
    testWidgets('deve renderizar ícone e texto de tarefas', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: TasksPage()),
      );

      expect(find.byIcon(AppIcons.tasks), findsOneWidget);
      expect(find.text(AppStrings.tasks), findsOneWidget);
    });

    testWidgets('deve usar cor primária do tema no ícone', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
          ),
          home: const TasksPage(),
        ),
      );

      final icon = tester.widget<Icon>(find.byIcon(AppIcons.tasks));
      expect(icon.size, AppSizes.iconLarge);
    });
  });
}
