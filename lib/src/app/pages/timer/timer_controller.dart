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
  // Timer mode indices for clarity
  static const int modeFocus = 0;
  static const int modeShortBreak = 1;
  static const int modeLongBreak = 2;

  static const int maxCycles = 10;
  static const Duration defaultTickDuration = Duration(seconds: 1);
  void updateCurrentCycle(int newCurrent) {
    if (newCurrent < 0 || newCurrent > maxCycles) return;
    final updatedState = state.copyWith(currentCycle: newCurrent);
    emit(updatedState);
    timerRepository.saveTimerEntity(updatedState);
  }

  void updateTotalCycles(int newTotal) {
    if (newTotal < 1 || newTotal > maxCycles) return;
    emit(state.copyWith(totalCycles: newTotal));
    timerRepository.saveTimerEntity(state.copyWith(totalCycles: newTotal));
  }

  final Duration tickDuration;
  final Future<void> Function(int focusMinutes)? onFocusSessionCompleted;
  void resetTimer() {
    final int total = getTotalSeconds();
    final updatedState = state.copyWith(
      remainingSeconds: total,
      isRunning: false,
    );
    emit(updatedState);
    timerRepository.saveTimerEntity(updatedState);
  }

  Future<void> startPauseTimer() async {
    if (state.isRunning == true) {
      final updatedState = state.copyWith(isRunning: false);
      emit(updatedState);
      // Salva imediatamente ao pausar/parar
      await timerRepository.saveTimerEntity(updatedState);
      return;
    }
    final int total = getTotalSeconds();
    int remaining = state.remainingSeconds ?? total;
    // Se estiver zerado ou nulo, define para o valor padrão
    if (remaining == 0) {
      remaining = total;
      final updatedState = state.copyWith(remainingSeconds: remaining);
      emit(updatedState);
      await timerRepository.saveTimerEntity(updatedState);
    }
    int tickCount = 0;
    // Marca como rodando
    emit(state.copyWith(isRunning: true));
    bool completedNormally = true;
    while (remaining > 0 && state.isRunning == true) {
      await Future.delayed(tickDuration);
      if (state.isRunning != true) {
        completedNormally = false;
        break;
      }
      remaining--;
      tickCount++;
      final updatedState = state.copyWith(remainingSeconds: remaining);
      emit(updatedState);
      // Salva a cada 5 segundos
      if (tickCount % 5 == 0) {
        await timerRepository.saveTimerEntity(updatedState);
      }
    }
    // Marca como parado
    final stoppedState = state.copyWith(isRunning: false);
    emit(stoppedState);
    await timerRepository.saveTimerEntity(stoppedState);

    // Só incrementa currentCycle se terminou normalmente
    if (completedNormally) {
      // Se for pausa (shortBreak ou longBreak), zera o currentCycle
      if (state.currentModeIndex == modeShortBreak ||
          state.currentModeIndex == modeLongBreak) {
        final updatedState = state.copyWith(currentCycle: 0);
        emit(updatedState);
        await timerRepository.saveTimerEntity(updatedState);
      } else if (state.currentCycle < state.totalCycles) {
        final focusMinutes = state.durations.focus ~/ Duration.secondsPerMinute;
        await onFocusSessionCompleted?.call(focusMinutes);

        final incrementedCycle = state.currentCycle + 1;
        final updatedState = state.copyWith(currentCycle: incrementedCycle);
        emit(updatedState);
        await timerRepository.saveTimerEntity(updatedState);
      }
    }
    // Timer terminou, pode adicionar lógica extra aqui se quiser
  }

  void setTimerFromInput(String value) {
    final total = parseTimerInput(value);
    if (total != null) {
      setTimerSeconds(total);
    }
  }

  /// Permanently updates the duration for the current mode and sets
  /// [remainingSeconds] to [seconds]. The new duration is persisted, so
  /// subsequent resets will use this value.
  void setTimerSeconds(int seconds) {
    final durations = state.durations;
    TimerDurations newDurations;
    switch (state.currentModeIndex) {
      case modeShortBreak:
        newDurations = durations.copyWith(shortBreak: seconds);
        break;
      case modeLongBreak:
        newDurations = durations.copyWith(longBreak: seconds);
        break;
      default:
        newDurations = durations.copyWith(focus: seconds);
        break;
    }
    final updatedState = state.copyWith(
      durations: newDurations,
      remainingSeconds: seconds,
      isRunning: false,
    );
    emit(updatedState);
    timerRepository.saveTimerEntity(updatedState);
  }

  /// Sets [remainingSeconds] without changing the saved mode duration.
  /// Use this for one-off countdown adjustments that should not persist
  /// across resets.
  void overrideRemainingSeconds(int seconds) {
    final updatedState = state.copyWith(
      remainingSeconds: seconds,
      isRunning: false,
    );
    emit(updatedState);
    timerRepository.saveTimerEntity(updatedState);
  }

  void decrementSessionDuration() {
    _changeSessionDuration(-Duration.secondsPerMinute);
  }

  void incrementSessionDuration() {
    _changeSessionDuration(Duration.secondsPerMinute);
  }

  void _changeSessionDuration(int delta) {
    final idx = state.currentModeIndex;
    final durations = state.durations;
    TimerDurations newDurations;
    int? newRemaining;
    switch (idx) {
      case modeFocus:
        if (delta < 0 && durations.focus < Duration.secondsPerMinute) {
          return;
        }
        newDurations = durations.copyWith(focus: durations.focus + delta);
        newRemaining = (state.remainingSeconds ?? durations.focus) + delta;
        break;
      case modeShortBreak:
        if (delta < 0 && durations.shortBreak < Duration.secondsPerMinute) {
          return;
        }
        newDurations = durations.copyWith(
          shortBreak: durations.shortBreak + delta,
        );
        newRemaining = (state.remainingSeconds ?? durations.shortBreak) + delta;
        break;
      case modeLongBreak:
        if (delta < 0 && durations.longBreak < Duration.secondsPerMinute) {
          return;
        }
        newDurations = durations.copyWith(
          longBreak: durations.longBreak + delta,
        );
        newRemaining = (state.remainingSeconds ?? durations.longBreak) + delta;
        break;
      default:
        return;
    }
    if (delta < 0 && newRemaining < 0) newRemaining = 0;
    final updatedState = state.copyWith(
      durations: newDurations,
      remainingSeconds: newRemaining,
    );
    emit(updatedState);
    timerRepository.saveTimerEntity(updatedState);
  }

  Future<void> _loadTimerEntity() async {
    final loaded = await timerRepository.loadTimerEntity();
    if (loaded != null) {
      final durations = loaded.durations;
      final corrected = TimerDurations(
        focus: durations.focus >= 0
            ? durations.focus
            : TimerDurations.defaultFocus,
        shortBreak: durations.shortBreak >= 0
            ? durations.shortBreak
            : TimerDurations.defaultShortBreak,
        longBreak: durations.longBreak >= 0
            ? durations.longBreak
            : TimerDurations.defaultLongBreak,
      );
      var correctedState = loaded.copyWith(durations: corrected);
      if (!correctedState.isRunning &&
          (correctedState.remainingSeconds == null ||
              correctedState.remainingSeconds == 0)) {
        final total = getTotalSeconds(timer: correctedState);
        correctedState = correctedState.copyWith(remainingSeconds: total);
      }
      emit(correctedState);
    }
  }

  final repo.TimerRepository timerRepository;
  int getTotalSeconds({TimerEntity? timer, int? modeIndex}) {
    final t = timer ?? state;
    final idx = modeIndex ?? t.currentModeIndex;
    if (idx == modeShortBreak) {
      return t.durations.shortBreak;
    } else if (idx == modeLongBreak) {
      return t.durations.longBreak;
    }
    return t.durations.focus;
  }

  Future<void> updateCurrentModeIndex(int index) async {
    final int total = getTotalSeconds(modeIndex: index);
    final updatedState = state.copyWith(
      currentModeIndex: index,
      remainingSeconds: total,
      isRunning: false,
    );
    emit(updatedState);
    await timerRepository.saveTimerEntity(updatedState);
  }
}
