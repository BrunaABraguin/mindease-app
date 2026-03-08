import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mindease_app/src/app/navigator.dart';
import 'package:mindease_app/src/data/repositories/timer_repository.dart'
    as repo;
import 'package:mindease_app/theme.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  Future<void> pumpNavigator(WidgetTester tester, {required Size size}) async {
    tester.view.physicalSize = size;
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.lightTheme,
        home: AppNavigator(timerRepository: repo.TimerRepository()),
      ),
    );
    await tester.pump(const Duration(seconds: 2));
  }

  testWidgets('uses bottom navigation on mobile', (tester) async {
    await pumpNavigator(tester, size: const Size(390, 844));

    expect(find.byType(NavigationBar), findsOneWidget);
    expect(find.byType(NavigationRail), findsNothing);

    final navigationBar = tester.widget<NavigationBar>(
      find.byType(NavigationBar),
    );
    expect(navigationBar.selectedIndex, 0);
  });

  testWidgets('uses navigation rail on large screen', (tester) async {
    await pumpNavigator(tester, size: const Size(1280, 800));

    expect(find.byType(NavigationRail), findsOneWidget);
    expect(find.byType(NavigationBar), findsNothing);

    final navigationRail = tester.widget<NavigationRail>(
      find.byType(NavigationRail),
    );
    expect(navigationRail.selectedIndex, 0);
  });

  testWidgets('navigates between sections on mobile', (tester) async {
    await pumpNavigator(tester, size: const Size(390, 844));

    // Capture initial selected index
    final initialNavigationBar = tester.widget<NavigationBar>(
      find.byType(NavigationBar),
    );
    final initialIndex = initialNavigationBar.selectedIndex;

    // Navigate to "Tarefas" and ensure selection and content change
    await tester.tap(find.text('Tarefas').first);
    await tester.pumpAndSettle();
    // Verify that the TasksPage content is displayed
    expect(find.text('Tarefas'), findsWidgets);
    final tarefasNavigationBar = tester.widget<NavigationBar>(
      find.byType(NavigationBar),
    );
    expect(tarefasNavigationBar.selectedIndex, isNot(equals(initialIndex)));

    // Navigate to "Missões" and ensure selection and content change again
    await tester.tap(find.text('Missões').first);
    await tester.pumpAndSettle();
    expect(find.text('Missões'), findsWidgets);
    final missoesNavigationBar = tester.widget<NavigationBar>(
      find.byType(NavigationBar),
    );
    expect(
      missoesNavigationBar.selectedIndex,
      isNot(equals(tarefasNavigationBar.selectedIndex)),
    );
  });
}
