import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mindease_app/src/app/utils/timer_input_parser.dart';
import 'package:mindease_app/src/data/repositories/timer_repository.dart'
    as repo;
import 'package:mindease_app/src/domain/entities/timer_entity.dart';

class TimerCubit extends Cubit<TimerEntity> {
  TimerCubit({
    required this.timerRepository,
    this.tickDuration = const Duration(seconds: 1),
  }) : super(
         TimerEntity(
           durations: const TimerDurations(
             focus: 25 * Duration.secondsPerMinute,
             shortBreak: 5 * Duration.secondsPerMinute,
             longBreak: 15 * Duration.secondsPerMinute,
           ),
           currentCycle: 1,
           totalCycles: 4,
           completedSessions: 0,
           currentModeIndex: 0,
         ),
       ) {
    _loadTimerEntity();
  }
  final Duration tickDuration;
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
    int tickCount = 0;
    // Marca como rodando
    emit(state.copyWith(isRunning: true));
    while (remaining > 0 && state.isRunning == true) {
      await Future.delayed(tickDuration);
      if (state.isRunning != true) break;
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
    // Salva ao terminar
    await timerRepository.saveTimerEntity(stoppedState);
    // Timer terminou, pode adicionar lógica extra aqui se quiser
  }

  void setTimerFromInput(String value) {
    final total = parseTimerInput(value);
    if (total != null) {
      setTimerSeconds(total);
    }
  }

  void setTimerSeconds(int seconds) {
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
      case 0:
        if (delta < 0 && durations.focus < Duration.secondsPerMinute) {
          return;
        }
        newDurations = durations.copyWith(focus: durations.focus + delta);
        newRemaining = (state.remainingSeconds ?? durations.focus) + delta;
        break;
      case 1:
        if (delta < 0 && durations.shortBreak < Duration.secondsPerMinute) {
          return;
        }
        newDurations = durations.copyWith(
          shortBreak: durations.shortBreak + delta,
        );
        newRemaining = (state.remainingSeconds ?? durations.shortBreak) + delta;
        break;
      case 2:
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
      emit(loaded);
    }
  }

  final repo.TimerRepository timerRepository;
  int getTotalSeconds({TimerEntity? timer, int? modeIndex}) {
    final t = timer ?? state;
    final idx = modeIndex ?? t.currentModeIndex;
    if (idx == 1) {
      return t.durations.shortBreak;
    } else if (idx == 2) {
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
