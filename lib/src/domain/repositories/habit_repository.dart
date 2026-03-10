import 'package:mindease_app/src/domain/entities/habit.dart';

abstract class HabitRepository {
  Future<List<Habit>> loadHabits(String userEmail);
  Future<Habit> addHabit(Habit habit);
  Future<void> updateHabit(Habit habit);
  Future<void> deleteHabit(String habitId);
  Future<void> toggleRecord(String habitId, DateTime date);
  Stream<List<Habit>> habitsStream(String userEmail);
}
