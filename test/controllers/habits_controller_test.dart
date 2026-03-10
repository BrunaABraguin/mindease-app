import 'package:flutter_test/flutter_test.dart';
import 'package:mindease_app/src/app/pages/habits/habits_controller.dart';
import 'package:mindease_app/src/domain/entities/habit.dart';
import '../mocks/fake_habit_repository.dart';

void main() {
  group('HabitsCubit', () {
    late FakeHabitRepository fakeRepo;
    late HabitsCubit cubit;

    setUp(() {
      fakeRepo = FakeHabitRepository();
      cubit = HabitsCubit(
        habitRepository: fakeRepo,
        userEmail: 'user@test.com',
      );
    });

    tearDown(() {
      cubit.close();
      fakeRepo.dispose();
    });

    test('initial state has selectedDate and empty habits', () {
      expect(cubit.state, isA<HabitsState>());
      expect(cubit.state.selectedDate, isNotNull);
      expect(cubit.state.habits, isEmpty);
      expect(cubit.state.isAdding, isFalse);
      expect(cubit.state.deletingHabitId, '');
      expect(cubit.state.editingHabitId, '');
    });

    test('selectDate updates selectedDate', () {
      final date = DateTime(2026, 3, 15);
      cubit.selectDate(date);
      expect(cubit.state.selectedDate, date);
    });

    test('startAdding sets isAdding to true', () {
      cubit.startAdding();
      expect(cubit.state.isAdding, isTrue);
    });

    test('cancelAdding sets isAdding to false', () {
      cubit.startAdding();
      cubit.cancelAdding();
      expect(cubit.state.isAdding, isFalse);
    });

    test('addHabit adds habit and sets isAdding to false', () async {
      cubit.startAdding();
      await cubit.addHabit('Skincare dia');

      // Wait for stream to update
      await Future.delayed(const Duration(milliseconds: 50));
      expect(cubit.state.habits.length, 1);
      expect(cubit.state.habits.first.name, 'Skincare dia');
      expect(cubit.state.habits.first.userEmail, 'user@test.com');
      expect(cubit.state.isAdding, isFalse);
    });

    test('addHabit ignores empty name', () async {
      await cubit.addHabit('   ');
      await Future.delayed(const Duration(milliseconds: 50));
      expect(cubit.state.habits, isEmpty);
    });

    test('updateHabitName updates the habit name', () async {
      await cubit.addHabit('Old Name');
      await Future.delayed(const Duration(milliseconds: 50));

      final habitId = cubit.state.habits.first.id;
      cubit.startEditing(habitId);
      expect(cubit.state.editingHabitId, habitId);

      await cubit.updateHabitName(habitId, 'New Name');
      await Future.delayed(const Duration(milliseconds: 50));

      expect(cubit.state.habits.first.name, 'New Name');
      expect(cubit.state.editingHabitId, '');
    });

    test('deleteHabit removes the habit', () async {
      await cubit.addHabit('To Delete');
      await Future.delayed(const Duration(milliseconds: 50));

      final habitId = cubit.state.habits.first.id;
      cubit.startDeleting(habitId);
      expect(cubit.state.deletingHabitId, habitId);

      await cubit.deleteHabit(habitId);
      await Future.delayed(const Duration(milliseconds: 50));

      expect(cubit.state.habits, isEmpty);
      expect(cubit.state.deletingHabitId, '');
    });

    test('toggleRecord adds and removes record for a day', () async {
      await cubit.addHabit('Exercise');
      await Future.delayed(const Duration(milliseconds: 50));

      final habitId = cubit.state.habits.first.id;
      final day = DateTime(2026, 3, 4);

      // Add record
      await cubit.toggleRecord(habitId, day);
      await Future.delayed(const Duration(milliseconds: 50));
      expect(cubit.state.habits.first.hasRecordOn(day), isTrue);

      // Remove record
      await cubit.toggleRecord(habitId, day);
      await Future.delayed(const Duration(milliseconds: 50));
      expect(cubit.state.habits.first.hasRecordOn(day), isFalse);
    });

    test('cancelDeleting clears deletingHabitId', () {
      cubit.startDeleting('some-id');
      expect(cubit.state.deletingHabitId, 'some-id');
      cubit.cancelDeleting();
      expect(cubit.state.deletingHabitId, '');
    });

    test('cancelEditing clears editingHabitId', () {
      cubit.startEditing('some-id');
      expect(cubit.state.editingHabitId, 'some-id');
      cubit.cancelEditing();
      expect(cubit.state.editingHabitId, '');
    });

    test('no operations when userEmail is null', () async {
      final nullCubit = HabitsCubit(
        habitRepository: fakeRepo,
        userEmail: null,
      );

      await nullCubit.addHabit('Test');
      await Future.delayed(const Duration(milliseconds: 50));
      expect(nullCubit.state.habits, isEmpty);

      nullCubit.close();
    });
  });

  group('HabitsState', () {
    test('copyWith preserves unspecified fields', () {
      final state = HabitsState(
        habits: const [Habit(id: '1', userEmail: 'u', name: 'Test')],
        selectedDate: DateTime(2026, 3, 8),
        isAdding: true,
        deletingHabitId: 'del',
        editingHabitId: 'edit',
      );

      final copy = state.copyWith();
      expect(copy.habits.length, 1);
      expect(copy.selectedDate, DateTime(2026, 3, 8));
      expect(copy.isAdding, isTrue);
      expect(copy.deletingHabitId, 'del');
      expect(copy.editingHabitId, 'edit');
    });

    test('copyWith updates specified fields', () {
      const state = HabitsState();
      final updated = state.copyWith(
        isAdding: true,
        deletingHabitId: 'abc',
      );
      expect(updated.isAdding, isTrue);
      expect(updated.deletingHabitId, 'abc');
    });
  });
}
