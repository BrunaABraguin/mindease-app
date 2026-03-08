import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mindease_app/src/data/repositories/timer_repository.dart'
    as repo;
import 'package:mindease_app/src/domain/entities/timer_entity.dart';

class TimerCubit extends Cubit<TimerEntity> {
  TimerCubit({required this.timerRepository})
    : super(
        TimerEntity(
          focusTime: 25 * 60,
          breakTime: 5 * 60,
          longBreakTime: 15 * 60,
          currentCycle: 1,
          totalCycles: 4,
          completedSessions: 0,
          currentModeIndex: 0,
        ),
      ) {
    _loadTimerEntity();
  }
  final repo.TimerRepository timerRepository;

  Future<void> _loadTimerEntity() async {
    final loaded = await timerRepository.loadTimerEntity();
    if (loaded != null) {
      emit(loaded);
    }
  }

  Future<void> updateCurrentModeIndex(int index) async {
    final updatedState = state.copyWith(currentModeIndex: index);
    emit(updatedState);
    await timerRepository.saveTimerEntity(updatedState);
  }
}
