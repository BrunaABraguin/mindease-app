import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mindease_app/src/app/pages/missions/missions_view.dart';
import 'package:mindease_app/src/app/utils/app_constants.dart';

void main() {
  group('MissionsPage', () {
    testWidgets('deve renderizar ícone e texto de missões', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: MissionsPage()),
      );

      expect(find.byIcon(AppIcons.missions), findsOneWidget);
      expect(find.text(AppStrings.missions), findsOneWidget);
    });

    testWidgets('deve usar cor primária do tema no ícone', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.red),
          ),
          home: const MissionsPage(),
        ),
      );

      final icon = tester.widget<Icon>(find.byIcon(AppIcons.missions));
      expect(icon.size, AppSizes.iconLarge);
    });
  });
}
