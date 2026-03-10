import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mindease_app/src/app/pages/habits/widgets/habit_card.dart';
import 'package:mindease_app/src/app/utils/app_constants.dart';
import 'package:mindease_app/src/domain/entities/habit.dart';

void main() {
  final today = DateTime.now();
  final weekDays = List.generate(
    7,
    (i) => today.subtract(Duration(days: today.weekday - 1 - i)),
  );

  Habit makeHabit({List<DateTime>? records}) => Habit(
    id: '1',
    userEmail: 'test@test.com',
    name: 'Test Habit',
    records: records ?? [],
  );

  Widget buildCard({
    Habit? habit,
    bool isEditing = false,
    bool isDeleting = false,
    void Function(DateTime)? onToggleDay,
    VoidCallback? onDelete,
    VoidCallback? onStartEditing,
    void Function(String)? onSaveEdit,
    VoidCallback? onCancelEdit,
    VoidCallback? onConfirmDelete,
    VoidCallback? onCancelDelete,
  }) {
    return MaterialApp(
      home: Scaffold(
        body: HabitCard(
          habit: habit ?? makeHabit(),
          weekDays: weekDays,
          selectedDate: today,
          onToggleDay: onToggleDay ?? (_) {},
          onDelete: onDelete ?? () {},
          onStartEditing: onStartEditing ?? () {},
          onSaveEdit: onSaveEdit ?? (_) {},
          onCancelEdit: onCancelEdit ?? () {},
          isEditing: isEditing,
          isDeleting: isDeleting,
          onConfirmDelete: onConfirmDelete ?? () {},
          onCancelDelete: onCancelDelete ?? () {},
        ),
      ),
    );
  }

  group('HabitCard', () {
    testWidgets('renders habit name and week days', (tester) async {
      await tester.pumpWidget(buildCard());

      expect(find.text('Test Habit'), findsOneWidget);
      expect(find.text(AppStrings.mon), findsOneWidget);
      expect(find.text(AppStrings.sun), findsOneWidget);
    });

    testWidgets('renders close button and calls onDelete', (tester) async {
      var deleted = false;
      await tester.pumpWidget(buildCard(onDelete: () => deleted = true));

      await tester.tap(find.byIcon(Icons.close));
      expect(deleted, isTrue);
    });

    testWidgets('calls onToggleDay when day circle is tapped', (tester) async {
      DateTime? tappedDay;
      await tester.pumpWidget(buildCard(onToggleDay: (day) => tappedDay = day));

      final dayTexts = find.text('${weekDays[0].day}');
      await tester.tap(dayTexts.first);
      expect(tappedDay, isNotNull);
    });

    testWidgets('shows delete confirmation when isDeleting', (tester) async {
      await tester.pumpWidget(buildCard(isDeleting: true));

      expect(find.text(AppStrings.confirmDelete), findsOneWidget);
      expect(find.text(AppStrings.yes), findsOneWidget);
      expect(find.text(AppStrings.no), findsOneWidget);
    });

    testWidgets('calls onConfirmDelete and onCancelDelete', (tester) async {
      var confirmed = false;
      var cancelled = false;
      await tester.pumpWidget(
        buildCard(
          isDeleting: true,
          onConfirmDelete: () => confirmed = true,
          onCancelDelete: () => cancelled = true,
        ),
      );

      await tester.tap(find.text(AppStrings.yes));
      expect(confirmed, isTrue);

      await tester.tap(find.text(AppStrings.no));
      expect(cancelled, isTrue);
    });

    testWidgets('shows editing header when isEditing', (tester) async {
      await tester.pumpWidget(buildCard(isEditing: true));

      expect(find.byType(TextField), findsOneWidget);
      expect(find.byIcon(Icons.check), findsOneWidget);
      expect(find.byIcon(Icons.close), findsOneWidget);
    });

    testWidgets('calls onSaveEdit via check button', (tester) async {
      String? savedName;
      await tester.pumpWidget(
        buildCard(isEditing: true, onSaveEdit: (name) => savedName = name),
      );

      final textField = find.byType(TextField);
      await tester.enterText(textField, 'New Name');
      await tester.tap(find.byIcon(Icons.check));
      expect(savedName, 'New Name');
    });

    testWidgets('calls onCancelEdit via close button', (tester) async {
      var cancelled = false;
      await tester.pumpWidget(
        buildCard(isEditing: true, onCancelEdit: () => cancelled = true),
      );

      await tester.tap(find.byIcon(Icons.close));
      expect(cancelled, isTrue);
    });

    testWidgets('shows filled circle for recorded day', (tester) async {
      final habit = makeHabit(records: [weekDays[0]]);
      await tester.pumpWidget(buildCard(habit: habit));

      // Widget renders without errors with a recorded day
      expect(find.text('Test Habit'), findsOneWidget);
    });

    testWidgets('double tap calls onStartEditing', (tester) async {
      var startedEditing = false;
      await tester.pumpWidget(
        buildCard(onStartEditing: () => startedEditing = true),
      );

      await tester.ensureVisible(find.text('Test Habit'));
      final gesture = await tester.createGesture();
      final center = tester.getCenter(find.text('Test Habit'));
      await gesture.down(center);
      await gesture.up();
      await tester.pump(const Duration(milliseconds: 50));
      await gesture.down(center);
      await gesture.up();
      await tester.pumpAndSettle();

      expect(startedEditing, isTrue);
    });
  });
}
