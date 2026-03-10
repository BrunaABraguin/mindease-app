import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mindease_app/src/app/pages/tasks/widgets/tasks_summary_bar.dart';

void main() {
  group('TasksSummaryBar', () {
    testWidgets('renders mobile layout with summary items on narrow screen', (
      tester,
    ) async {
      tester.view.physicalSize = const Size(400, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: TasksSummaryBar(total: 10, pending: 6, completed: 4),
          ),
        ),
      );

      expect(find.text('Total'), findsOneWidget);
      expect(find.text('10'), findsOneWidget);
      expect(find.text('Pendentes'), findsOneWidget);
      expect(find.text('6'), findsOneWidget);
      expect(find.text('Concluídas'), findsOneWidget);
      expect(find.text('4'), findsOneWidget);
    });

    testWidgets('renders web layout with chips on wide screen', (tester) async {
      tester.view.physicalSize = const Size(1200, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: TasksSummaryBar(total: 5, pending: 3, completed: 2),
          ),
        ),
      );

      expect(find.text('Total'), findsOneWidget);
      expect(find.text('5'), findsOneWidget);
      expect(find.text('Pendentes'), findsOneWidget);
      expect(find.text('3'), findsOneWidget);
      expect(find.text('Concluídas'), findsOneWidget);
      expect(find.text('2'), findsOneWidget);
    });

    testWidgets('renders zero values', (tester) async {
      tester.view.physicalSize = const Size(400, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: TasksSummaryBar(total: 0, pending: 0, completed: 0),
          ),
        ),
      );

      expect(find.text('0'), findsNWidgets(3));
    });
  });
}
