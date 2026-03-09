import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mindease_app/src/app/pages/habits/habits_view.dart';
import 'package:mindease_app/src/app/utils/app_constants.dart';

void main() {
  group('HabitsPage', () {
    testWidgets('deve renderizar ícone e texto de hábitos', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: HabitsPage()),
      );

      expect(find.byIcon(AppIcons.habits), findsOneWidget);
      expect(find.text(AppStrings.habits), findsOneWidget);
    });

    testWidgets('deve usar cor primária do tema no ícone', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
          ),
          home: const HabitsPage(),
        ),
      );

      final icon = tester.widget<Icon>(find.byIcon(AppIcons.habits));
      expect(icon.size, AppSizes.iconLarge);
    });
  });
}
