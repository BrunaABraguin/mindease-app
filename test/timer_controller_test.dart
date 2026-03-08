import 'package:flutter_test/flutter_test.dart';
import 'package:mindease_app/src/app/pages/timer/timer_controller.dart';
import 'package:mindease_app/src/data/repositories/timer_repository.dart'
    as repo;
import 'package:mindease_app/src/domain/entities/timer_entity.dart';

class MockTimerRepository implements repo.TimerRepository {
  final List<TimerEntity> savedEntities = [];
  TimerEntity? entityToLoad;

  @override
  Future<void> saveTimerEntity(TimerEntity timer) async {
    savedEntities.add(timer);
  }

  @override
  Future<TimerEntity?> loadTimerEntity() async {
    return entityToLoad;
  }

  @override
  Future<void> clearTimerEntity() async {
    savedEntities.clear();
    entityToLoad = null;
  }
}

void main() {
  late MockTimerRepository mockRepo;
  late TimerCubit cubit;

  setUp(() {
    mockRepo = MockTimerRepository();
    mockRepo.entityToLoad = null; // Estado inicial: nada salvo

    cubit = TimerCubit(timerRepository: mockRepo);
    // Não sobrescreva o estado inicial do cubit aqui!
  });

  test('initial state is correct', () {
    expect(cubit.state.currentCycle, 1);
    expect(cubit.state.totalCycles, 4);
    expect(cubit.state.completedSessions, 0);
    expect(cubit.state.currentModeIndex, 0);
    expect(cubit.state.durations.focus, 1500);
    expect(cubit.state.durations.shortBreak, 300);
    expect(cubit.state.durations.longBreak, 900);
  });

  test('getTotalSeconds returns correct values', () {
    expect(cubit.getTotalSeconds(), 1500);
    expect(cubit.getTotalSeconds(modeIndex: 1), 300);
    expect(cubit.getTotalSeconds(modeIndex: 2), 900);
  });

  test('resetTimer emits updated state and saves', () async {
    cubit.resetTimer();
    final updated = cubit.state;
    expect(updated.remainingSeconds, 1500);
    expect(updated.isRunning, false);
    expect(mockRepo.savedEntities.isNotEmpty, true);
    expect(mockRepo.savedEntities.last, isA<TimerEntity>());
  });

  test('updateCurrentModeIndex emits updated state and saves', () async {
    await cubit.updateCurrentModeIndex(1);
    final updated = cubit.state;
    expect(updated.currentModeIndex, 1);
    expect(updated.remainingSeconds, 300);
    expect(updated.isRunning, false);
    expect(mockRepo.savedEntities.isNotEmpty, true);
    expect(mockRepo.savedEntities.last, isA<TimerEntity>());
  });

  test('startPauseTimer starts and pauses timer', () async {
    // Start timer
    final future = cubit.startPauseTimer();
    await Future.delayed(const Duration(milliseconds: 5));
    expect(cubit.state.isRunning, true);

    // Pause timer
    await cubit.startPauseTimer();
    expect(cubit.state.isRunning, false);
    expect(mockRepo.savedEntities.isNotEmpty, true);
    expect(mockRepo.savedEntities.last, isA<TimerEntity>());
    await future;
  });

  test('startPauseTimer counts down and stops at zero', () async {
    // Set state with small remainingSeconds for fast test
    final initial = cubit.state.copyWith(remainingSeconds: 3, isRunning: false);
    cubit.emit(initial);

    await cubit.startPauseTimer();
    expect(cubit.state.isRunning, false);
    expect(cubit.state.remainingSeconds, 0);
    expect(mockRepo.savedEntities.isNotEmpty, true);
    expect(mockRepo.savedEntities.last, isA<TimerEntity>());
  });

  test('loadTimerEntity loads and emits saved state', () async {
    final saved = TimerEntity(
      durations: const TimerDurations(focus: 10, shortBreak: 5, longBreak: 15),
      currentCycle: 2,
      totalCycles: 4,
      completedSessions: 1,
      currentModeIndex: 1,
      remainingSeconds: 7,
    );
    mockRepo.entityToLoad = saved;

    final cubit2 = TimerCubit(
      timerRepository: mockRepo,
      tickDuration: const Duration(milliseconds: 1),
    );
    await Future.delayed(const Duration(milliseconds: 10));
    expect(cubit2.state.currentCycle, 2);
    expect(cubit2.state.remainingSeconds, 7);
  });
}
