import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mindease_app/src/domain/entities/timer_entity.dart';
import 'package:mindease_app/src/domain/usecases/timer_mode_usecases.dart';

class TimerCubit extends Cubit<TimerEntity> {

  TimerCubit({
    required this.getCurrentModeIndexUseCase,
    required this.setCurrentModeIndexUseCase,
  }) : super(
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
    _loadCurrentModeIndex();
  }
  final GetCurrentModeIndexUseCase getCurrentModeIndexUseCase;
  final SetCurrentModeIndexUseCase setCurrentModeIndexUseCase;

  Future<void> _loadCurrentModeIndex() async {
    final index = await getCurrentModeIndexUseCase();
    if (index != null) {
      emit(state.copyWith(currentModeIndex: index));
    }
  }

  Future<void> setCurrentModeIndex(int index) async {
    emit(state.copyWith(currentModeIndex: index));
    await setCurrentModeIndexUseCase(index);
  }
}
