import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mindease_app/src/data/repositories/timer_repository.dart'
    as repo;
import 'package:mindease_app/src/domain/entities/timer_entity.dart';

class TimerCubit extends Cubit<TimerEntity> {
  int getTotalSeconds([TimerEntity? timer]) {
    final t = timer ?? state;
    if (t.currentModeIndex == 1) {
      return t.durations.shortBreak;
    } else if (t.currentModeIndex == 2) {
      return t.durations.longBreak;
    }
    return t.durations.focus;
  }

  TimerCubit({required this.timerRepository})
    : super(
        TimerEntity(
          durations: const TimerDurations(
            focus: 25 * 60,
            shortBreak: 5 * 60,
            longBreak: 15 * 60,
          ),
          currentCycle: 1,
          totalCycles: 4,
          completedSessions: 0,
          currentModeIndex: 0,
        ),
      ) {
    _loadTimerEntity();
  }
  int _getTotalSecondsForMode([int? modeIndex]) {
    final idx = modeIndex ?? state.currentModeIndex;
    if (idx == 1) {
      return state.durations.shortBreak;
    } else if (idx == 2) {
      return state.durations.longBreak;
    }
    return state.durations.focus;
  }

  Future<void> startPauseTimer() async {
    if (state.isRunning == true) {
      final updatedState = state.copyWith(isRunning: false);
      emit(updatedState);
      // Salva imediatamente ao pausar/parar
      await timerRepository.saveTimerEntity(updatedState);
      return;
    }
    final int total = _getTotalSecondsForMode();
    int remaining = state.remainingSeconds ?? total;
    int tickCount = 0;
    // Marca como rodando
    emit(state.copyWith(isRunning: true));
    while (remaining > 0 && state.isRunning == true) {
      await Future.delayed(const Duration(seconds: 1));
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

  void resetTimer() {
    final int total = _getTotalSecondsForMode();
    final updatedState = state.copyWith(
      remainingSeconds: total,
      isRunning: false,
    );
    emit(updatedState);
    timerRepository.saveTimerEntity(updatedState);
  }

  final repo.TimerRepository timerRepository;

  Future<void> _loadTimerEntity() async {
    final loaded = await timerRepository.loadTimerEntity();
    if (loaded != null) {
      emit(loaded);
    }
  }

  Future<void> updateCurrentModeIndex(int index) async {
    final int total = _getTotalSecondsForMode(index);
    final updatedState = state.copyWith(
      currentModeIndex: index,
      remainingSeconds: total,
      isRunning: false,
    );
    emit(updatedState);
    await timerRepository.saveTimerEntity(updatedState);
  }
}
