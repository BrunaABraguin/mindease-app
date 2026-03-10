import 'dart:async';

import 'package:mindease_app/src/domain/entities/habit.dart';
import 'package:mindease_app/src/domain/repositories/habit_repository.dart';

class FakeHabitRepository implements HabitRepository {
  final List<Habit> _habits = [];
  final StreamController<List<Habit>> _controller =
      StreamController<List<Habit>>.broadcast();
  int _idCounter = 0;

  @override
  Future<List<Habit>> loadHabits(String userEmail) async {
    return _habits.where((h) => h.userEmail == userEmail).toList();
  }

  @override
  Future<Habit> addHabit(Habit habit) async {
    _idCounter++;
    final saved = habit.copyWith(id: 'habit_$_idCounter');
    _habits.add(saved);
    _emitHabits(saved.userEmail);
    return saved;
  }

  @override
  Future<void> updateHabit(Habit habit) async {
    final index = _habits.indexWhere((h) => h.id == habit.id);
    if (index != -1) {
      _habits[index] = habit;
      _emitHabits(habit.userEmail);
    }
  }

  @override
  Future<void> deleteHabit(String habitId) async {
    final habit = _habits.firstWhere(
      (h) => h.id == habitId,
      orElse: () => const Habit(id: '', userEmail: '', name: ''),
    );
    _habits.removeWhere((h) => h.id == habitId);
    if (habit.userEmail.isNotEmpty) {
      _emitHabits(habit.userEmail);
    }
  }

  @override
  Future<void> toggleRecord(String habitId, DateTime date) async {
    final index = _habits.indexWhere((h) => h.id == habitId);
    if (index == -1) return;

    final habit = _habits[index];
    final day = DateTime(date.year, date.month, date.day);
    final hasRecord = habit.hasRecordOn(day);

    List<DateTime> updatedRecords;
    if (hasRecord) {
      updatedRecords = habit.records
          .where((r) => DateTime(r.year, r.month, r.day) != day)
          .toList();
    } else {
      updatedRecords = [...habit.records, day];
    }

    _habits[index] = habit.copyWith(records: updatedRecords);
    _emitHabits(habit.userEmail);
  }

  @override
  Stream<List<Habit>> habitsStream(String userEmail) {
    // Emit current state first then listen for changes
    Future.microtask(() => _emitHabits(userEmail));
    return _controller.stream
        .map((all) => all.where((h) => h.userEmail == userEmail).toList());
  }

  void _emitHabits(String userEmail) {
    _controller.add(List.unmodifiable(_habits));
  }

  /// Disposes resources used by this fake repository.
  ///
  /// This method is intended for use in tests only and is not part of the
  /// [HabitRepository] interface contract in production code.
  void dispose() {
    _controller.close();
  }
}
