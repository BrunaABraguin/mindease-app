import 'package:flutter_test/flutter_test.dart';
import 'package:mindease_app/src/app/pages/timer/timer_controller.dart';
import 'package:mindease_app/src/data/repositories/timer_repository.dart';
import 'package:mindease_app/src/domain/entities/timer_entity.dart';

class MockTimerRepository implements TimerRepository {
  final List<TimerEntity> savedEntities = [];

  @override
  Future<void> saveTimerEntity(TimerEntity timer) async {
    savedEntities.add(timer);
  }

  @override
  Future<TimerEntity?> loadTimerEntity() async {
    return null;
  }
}

void main() {
  late TimerCubit cubit;
  late MockTimerRepository mockRepo;

  setUp(() {
    mockRepo = MockTimerRepository();
    cubit = TimerCubit(timerRepository: mockRepo);
  });

  test('Decrement focus mode reduces duration and remainingSeconds', () {
    cubit.emit(
      cubit.state.copyWith(
        durations: const TimerDurations(
          focus: 120,
          shortBreak: 300,
          longBreak: 900,
        ),
        currentModeIndex: 0,
        remainingSeconds: 120,
      ),
    );
    cubit.decrementSessionDuration();
    expect(cubit.state.durations.focus, 60);
    expect(cubit.state.remainingSeconds, 60);
  });

  test('Decrement shortBreak mode reduces duration and remainingSeconds', () {
    cubit.emit(
      cubit.state.copyWith(
        durations: const TimerDurations(
          focus: 1500,
          shortBreak: 120,
          longBreak: 900,
        ),
        currentModeIndex: 1,
        remainingSeconds: 120,
      ),
    );
    cubit.decrementSessionDuration();
    expect(cubit.state.durations.shortBreak, 60);
    expect(cubit.state.remainingSeconds, 60);
  });

  test('Decrement longBreak mode reduces duration and remainingSeconds', () {
    cubit.emit(
      cubit.state.copyWith(
        durations: const TimerDurations(
          focus: 1500,
          shortBreak: 300,
          longBreak: 120,
        ),
        currentModeIndex: 2,
        remainingSeconds: 120,
      ),
    );
    cubit.decrementSessionDuration();
    expect(cubit.state.durations.longBreak, 60);
    expect(cubit.state.remainingSeconds, 60);
  });

  test('Decrement does not go below 60 seconds (focus)', () {
    cubit.emit(
      cubit.state.copyWith(
        durations: const TimerDurations(
          focus: 60,
          shortBreak: 300,
          longBreak: 900,
        ),
        currentModeIndex: 0,
        remainingSeconds: 60,
      ),
    );
    cubit.decrementSessionDuration();
    expect(cubit.state.durations.focus, 0);
    expect(cubit.state.remainingSeconds, 0);
  });

  test('Decrement does not go below 60 seconds (shortBreak)', () {
    cubit.emit(
      cubit.state.copyWith(
        durations: const TimerDurations(
          focus: 1500,
          shortBreak: 60,
          longBreak: 900,
        ),
        currentModeIndex: 1,
        remainingSeconds: 60,
      ),
    );
    cubit.decrementSessionDuration();
    expect(cubit.state.durations.shortBreak, 0);
    expect(cubit.state.remainingSeconds, 0);
  });

  test('Decrement does not go below 60 seconds (longBreak)', () {
    cubit.emit(
      cubit.state.copyWith(
        durations: const TimerDurations(
          focus: 1500,
          shortBreak: 300,
          longBreak: 60,
        ),
        currentModeIndex: 2,
        remainingSeconds: 60,
      ),
    );
    cubit.decrementSessionDuration();
    expect(cubit.state.durations.longBreak, 0);
    expect(cubit.state.remainingSeconds, 0);
  });

  test('State is updated and repository is called', () {
    cubit.emit(
      cubit.state.copyWith(
        durations: const TimerDurations(
          focus: 120,
          shortBreak: 300,
          longBreak: 900,
        ),
        currentModeIndex: 0,
        remainingSeconds: 120,
      ),
    );
    cubit.decrementSessionDuration();
    expect(mockRepo.savedEntities.isNotEmpty, true);
    expect(mockRepo.savedEntities.last, isA<TimerEntity>());
  });
}
