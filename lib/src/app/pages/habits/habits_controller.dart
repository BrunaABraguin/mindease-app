import 'dart:async';
import 'dart:developer' as developer;

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mindease_app/src/app/utils/mission_checker.dart';
import 'package:mindease_app/src/domain/entities/habit.dart';
import 'package:mindease_app/src/domain/repositories/habit_repository.dart';

class HabitsCubit extends Cubit<HabitsState> {
  HabitsCubit({
    required HabitRepository habitRepository,
    required String? userEmail,
    this.onMissionTriggered,
  }) : _habitRepository = habitRepository,
       _userEmail = userEmail,
       super(const HabitsState()) {
    if (!_hasValidEmail) {
      developer.log(
        'HabitsCubit initialized without a user email. Habits will not be '
        'loaded until a valid email is provided via updateUserEmail.',
        name: 'HabitsCubit',
      );
    }
    _init();
  }

  final HabitRepository _habitRepository;
  String? _userEmail;
  StreamSubscription<List<Habit>>? _habitsSubscription;
  final Future<void> Function(String missionId)? onMissionTriggered;

  bool get _hasValidEmail => _userEmail != null && _userEmail!.isNotEmpty;

  void _init() {
    emit(state.copyWith(selectedDate: DateTime.now()));
    if (_hasValidEmail) {
      _listenHabits();
    }
  }

  void updateUserEmail(String? email) {
    if (email == _userEmail) return;
    _userEmail = email;
    _habitsSubscription?.cancel();
    if (email != null && email.isNotEmpty) {
      _listenHabits();
    } else {
      emit(state.copyWith(habits: []));
    }
  }

  void _listenHabits() {
    _habitsSubscription?.cancel();
    _habitsSubscription = _habitRepository
        .habitsStream(_userEmail!)
        .listen(
          (habits) {
            emit(state.copyWith(habits: habits));
          },
          onError: (error, stackTrace) {
            developer.log(
              'Error in habitsStream for $_userEmail: $error',
              name: 'HabitsCubit',
              error: error,
              stackTrace: stackTrace,
            );
          },
        );
  }

  void selectDate(DateTime date) {
    emit(state.copyWith(selectedDate: date));
  }

  Future<void> addHabit(String name) async {
    if (!_hasValidEmail) return;
    if (name.trim().isEmpty) return;

    emit(state.copyWith(isLoading: true));
    final habit = Habit(id: '', userEmail: _userEmail!, name: name.trim());
    await _habitRepository.addHabit(habit);
    emit(state.copyWith(isAdding: false, isLoading: false));
    await onMissionTriggered?.call('habits_create_first');
  }

  Future<void> updateHabitName(String habitId, String newName) async {
    if (newName.trim().isEmpty) return;

    final habit = state.habits.firstWhere(
      (h) => h.id == habitId,
      orElse: () => const Habit(id: '', userEmail: '', name: ''),
    );
    if (habit.id.isEmpty) return;

    emit(state.copyWith(isLoading: true));
    await _habitRepository.updateHabit(habit.copyWith(name: newName.trim()));
    emit(state.copyWith(editingHabitId: '', isLoading: false));
  }

  Future<void> deleteHabit(String habitId) async {
    emit(state.copyWith(isLoading: true));
    await _habitRepository.deleteHabit(habitId);
    emit(state.copyWith(deletingHabitId: '', isLoading: false));
  }

  Future<void> toggleRecord(String habitId, DateTime date) async {
    final habit = state.habits.firstWhere(
      (h) => h.id == habitId,
      orElse: () => const Habit(id: '', userEmail: '', name: ''),
    );
    final isCompleting = habit.id.isNotEmpty && !habit.hasRecordOn(date);

    await _habitRepository.toggleRecord(habitId, date);

    if (isCompleting) {
      await onMissionTriggered?.call('habits_complete_one');
      final updatedRecords = [...habit.records, date];
      if (MissionChecker.hasStreak(updatedRecords, 3)) {
        await onMissionTriggered?.call('habits_streak_3');
      }
    }
  }

  void startAdding() {
    emit(state.copyWith(isAdding: true));
  }

  void cancelAdding() {
    emit(state.copyWith(isAdding: false));
  }

  void startDeleting(String habitId) {
    emit(state.copyWith(deletingHabitId: habitId));
  }

  void cancelDeleting() {
    emit(state.copyWith(deletingHabitId: ''));
  }

  void startEditing(String habitId) {
    emit(state.copyWith(editingHabitId: habitId));
  }

  void cancelEditing() {
    emit(state.copyWith(editingHabitId: ''));
  }

  @override
  Future<void> close() async {
    await _habitsSubscription?.cancel();
    return super.close();
  }
}

class HabitsState {
  const HabitsState({
    this.habits = const [],
    this.selectedDate,
    this.isAdding = false,
    this.deletingHabitId = '',
    this.editingHabitId = '',
    this.isLoading = false,
  });

  final List<Habit> habits;
  final DateTime? selectedDate;
  final bool isAdding;
  final String deletingHabitId;
  final String editingHabitId;
  final bool isLoading;

  static const Object _notSpecified = Object();

  HabitsState copyWith({
    List<Habit>? habits,
    DateTime? selectedDate,
    bool? isAdding,
    Object? deletingHabitId = _notSpecified,
    Object? editingHabitId = _notSpecified,
    bool? isLoading,
  }) {
    return HabitsState(
      habits: habits ?? this.habits,
      selectedDate: selectedDate ?? this.selectedDate,
      isAdding: isAdding ?? this.isAdding,
      deletingHabitId: identical(deletingHabitId, _notSpecified)
          ? this.deletingHabitId
          : deletingHabitId as String,
      editingHabitId: identical(editingHabitId, _notSpecified)
          ? this.editingHabitId
          : editingHabitId as String,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}
