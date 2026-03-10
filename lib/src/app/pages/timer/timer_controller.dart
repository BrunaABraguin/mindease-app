import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mindease_app/src/app/utils/timer_input_parser.dart';
import 'package:mindease_app/src/data/repositories/timer_repository.dart'
    as repo;
import 'package:mindease_app/src/domain/entities/timer_entity.dart';

class TimerCubit extends Cubit<TimerEntity> {
  TimerCubit({
    required this.timerRepository,
    this.tickDuration = defaultTickDuration,
    this.onFocusSessionCompleted,
    this.onMissionTriggered,
    this.onTaskFocusCompleted,
  }) : super(
         TimerEntity(
           durations: TimerDurations.defaults,
           currentCycle: 0,
           totalCycles: 4,
           remainingSeconds: TimerDurations.defaultFocus,
           completedSessions: 0,
           currentModeIndex: 0,
         ),
       ) {
    _loadTimerEntity();
  }

  static const int modeFocus = 0;
  static const int modeShortBreak = 1;
  static const int modeLongBreak = 2;
  static const int maxCycles = 10;
  static const Duration defaultTickDuration = Duration(seconds: 1);

  final repo.TimerRepository timerRepository;
  final Duration tickDuration;
  final Future<void> Function(int focusMinutes)? onFocusSessionCompleted;
  final Future<void> Function(String missionId)? onMissionTriggered;
  final Future<void> Function(String taskId, int minutes)? onTaskFocusCompleted;

  String? selectedTaskId;

  // --- Ciclos ---
  void updateCurrentCycle(int newCurrent) {
    if (!_isValidCycle(newCurrent)) return;
    _emitAndSave(state.copyWith(currentCycle: newCurrent));
  }

  void updateTotalCycles(int newTotal) {
    if (!_isValidTotalCycles(newTotal)) return;
    _emitAndSave(state.copyWith(totalCycles: newTotal));
  }

  bool _isValidCycle(int value) => value >= 0 && value <= maxCycles;
  bool _isValidTotalCycles(int value) => value >= 1 && value <= maxCycles;

  // --- Timer control ---
  void resetTimer() {
    final total = getTotalSeconds();
    _emitAndSave(state.copyWith(remainingSeconds: total, isRunning: false));
  }

  Future<void> startPauseTimer() async {
    if (state.isRunning) {
      _emitAndSave(state.copyWith(isRunning: false));
      return;
    }
    await _runTimer();
  }

  Future<void> _runTimer() async {
    int remaining = state.remainingSeconds ?? getTotalSeconds();
    if (remaining == 0) {
      remaining = getTotalSeconds();
      _emitAndSave(state.copyWith(remainingSeconds: remaining));
    }
    emit(state.copyWith(isRunning: true));
    bool completedNormally = true;
    int tickCount = 0;

    while (remaining > 0 && state.isRunning) {
      await Future.delayed(tickDuration);
      if (!state.isRunning) {
        completedNormally = false;
        break;
      }
      remaining--;
      tickCount++;
      _emitAndSave(
        state.copyWith(remainingSeconds: remaining),
        saveEvery: tickCount % 5 == 0,
      );
    }
    _emitAndSave(state.copyWith(isRunning: false));

    if (completedNormally) await _handleSessionCompletion();
  }

  Future<void> _handleSessionCompletion() async {
    if (_isBreakMode(state.currentModeIndex)) {
      _emitAndSave(state.copyWith(currentCycle: 0));
    } else if (state.currentCycle < state.totalCycles) {
      final focusMinutes = state.durations.focus ~/ Duration.secondsPerMinute;
      await onFocusSessionCompleted?.call(focusMinutes);

      if (selectedTaskId != null) {
        await onTaskFocusCompleted?.call(selectedTaskId!, focusMinutes);
      }

      final incrementedCycle = state.currentCycle + 1;
      _emitAndSave(state.copyWith(currentCycle: incrementedCycle));
      if (incrementedCycle >= state.totalCycles) {
        await onMissionTriggered?.call('timer_long_break');
      }
    }
  }

  bool _isBreakMode(int mode) =>
      mode == modeShortBreak || mode == modeLongBreak;

  // --- Timer value ---
  void setTimerFromInput(String value) {
    final total = parseTimerInput(value);
    if (total != null) setTimerSeconds(total);
  }

  void setTimerSeconds(int seconds) {
    final newDurations = _updatedDurationsForCurrentMode(seconds);
    _emitAndSave(
      state.copyWith(
        durations: newDurations,
        remainingSeconds: seconds,
        isRunning: false,
      ),
    );
  }

  void overrideRemainingSeconds(int seconds) {
    _emitAndSave(state.copyWith(remainingSeconds: seconds, isRunning: false));
  }

  TimerDurations _updatedDurationsForCurrentMode(int seconds) {
    final d = state.durations;
    switch (state.currentModeIndex) {
      case modeShortBreak:
        return d.copyWith(shortBreak: seconds);
      case modeLongBreak:
        return d.copyWith(longBreak: seconds);
      default:
        return d.copyWith(focus: seconds);
    }
  }

  // --- Session duration controls ---
  void decrementSessionDuration() =>
      _changeSessionDuration(-Duration.secondsPerMinute);
  void incrementSessionDuration() =>
      _changeSessionDuration(Duration.secondsPerMinute);

  void _changeSessionDuration(int delta) {
    final idx = state.currentModeIndex;
    final d = state.durations;
    TimerDurations newDurations;
    int? newRemaining;
    if (delta < 0 && _isAtMinDuration(idx, d)) return;

    switch (idx) {
      case modeFocus:
        newDurations = d.copyWith(focus: d.focus + delta);
        newRemaining = (state.remainingSeconds ?? d.focus) + delta;
        break;
      case modeShortBreak:
        newDurations = d.copyWith(shortBreak: d.shortBreak + delta);
        newRemaining = (state.remainingSeconds ?? d.shortBreak) + delta;
        break;
      case modeLongBreak:
        newDurations = d.copyWith(longBreak: d.longBreak + delta);
        newRemaining = (state.remainingSeconds ?? d.longBreak) + delta;
        break;
      default:
        return;
    }
    if (delta < 0 && newRemaining < 0) newRemaining = 0;
    _emitAndSave(
      state.copyWith(durations: newDurations, remainingSeconds: newRemaining),
    );
  }

  bool _isAtMinDuration(int idx, TimerDurations d) {
    switch (idx) {
      case modeFocus:
        return d.focus < Duration.secondsPerMinute;
      case modeShortBreak:
        return d.shortBreak < Duration.secondsPerMinute;
      case modeLongBreak:
        return d.longBreak < Duration.secondsPerMinute;
      default:
        return true;
    }
  }

  // --- Persistence ---
  Future<void> _loadTimerEntity() async {
    final loaded = await timerRepository.loadTimerEntity();
    if (loaded == null) return;
    final corrected = _correctDurations(loaded.durations);
    var correctedState = loaded.copyWith(durations: corrected);
    if (!correctedState.isRunning &&
        (correctedState.remainingSeconds == null ||
            correctedState.remainingSeconds == 0)) {
      final total = getTotalSeconds(timer: correctedState);
      correctedState = correctedState.copyWith(remainingSeconds: total);
    }
    emit(correctedState);
  }

  TimerDurations _correctDurations(TimerDurations d) => TimerDurations(
    focus: d.focus >= 0 ? d.focus : TimerDurations.defaultFocus,
    shortBreak: d.shortBreak >= 0
        ? d.shortBreak
        : TimerDurations.defaultShortBreak,
    longBreak: d.longBreak >= 0 ? d.longBreak : TimerDurations.defaultLongBreak,
  );

  void _emitAndSave(TimerEntity newState, {bool saveEvery = true}) {
    emit(newState);
    if (saveEvery) timerRepository.saveTimerEntity(newState);
  }

  // --- Getters ---
  int getTotalSeconds({TimerEntity? timer, int? modeIndex}) {
    final t = timer ?? state;
    final idx = modeIndex ?? t.currentModeIndex;
    if (idx == modeShortBreak) return t.durations.shortBreak;
    if (idx == modeLongBreak) return t.durations.longBreak;
    return t.durations.focus;
  }

  Future<void> updateCurrentModeIndex(int index) async {
    final total = getTotalSeconds(modeIndex: index);
    final updatedState = state.copyWith(
      currentModeIndex: index,
      remainingSeconds: total,
      isRunning: false,
    );
    _emitAndSave(updatedState);
  }
}
