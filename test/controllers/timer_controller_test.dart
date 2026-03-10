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
}

void main() {
  late MockTimerRepository mockRepo;
  late TimerCubit cubit;

  setUp(() {
    mockRepo = MockTimerRepository();
    mockRepo.entityToLoad = null;

    cubit = TimerCubit(timerRepository: mockRepo);
  });

  test('initial state is correct', () {
    expect(cubit.state.currentCycle, 0);
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
    await Future.delayed(const Duration(milliseconds: 100));
    expect(mockRepo.savedEntities.last, isA<TimerEntity>());
    await future;
  });

  test('startPauseTimer counts down and stops at zero', () async {
    // Set state with small remainingSeconds for fast test
    final initial = cubit.state.copyWith(
      remainingSeconds: 3,
      status: const TimerStatus(),
    );
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

  test(
    'onFocusSessionCompleted is called with correct minutes after focus session',
    () async {
      int? savedMinutes;
      final focusCubit = TimerCubit(
        timerRepository: mockRepo,
        tickDuration: const Duration(milliseconds: 1),
        onFocusSessionCompleted: (minutes) async {
          savedMinutes = minutes;
        },
      );
      await Future.delayed(const Duration(milliseconds: 10));

      // Set a short focus duration (120 seconds = 2 minutes) for fast test
      final initial = focusCubit.state.copyWith(
        durations: const TimerDurations(
          focus: 120,
          shortBreak: 60,
          longBreak: 180,
        ),
        remainingSeconds: 3,
        currentModeIndex: TimerCubit.modeFocus,
      );
      focusCubit.emit(initial);

      await focusCubit.startPauseTimer();

      expect(savedMinutes, 2);
      expect(focusCubit.state.currentCycle, 1);
    },
  );

  test(
    'overrideRemainingSeconds updates remaining without changing duration',
    () {
      cubit.overrideRemainingSeconds(600);
      expect(cubit.state.remainingSeconds, 600);
      expect(cubit.state.isRunning, false);
      // Focus duration stays at the default 1500
      expect(cubit.state.durations.focus, 1500);
      expect(mockRepo.savedEntities.last.remainingSeconds, 600);
      expect(mockRepo.savedEntities.last.durations.focus, 1500);
    },
  );

  test('resetTimer uses original duration after overrideRemainingSeconds', () {
    cubit.overrideRemainingSeconds(600);
    expect(cubit.state.remainingSeconds, 600);

    cubit.resetTimer();
    // Should reset to the original focus duration, not the overridden value
    expect(cubit.state.remainingSeconds, 1500);
    expect(cubit.state.durations.focus, 1500);
  });

  test(
    'overrideRemainingSeconds does not affect other mode durations',
    () async {
      await cubit.updateCurrentModeIndex(TimerCubit.modeShortBreak);
      cubit.overrideRemainingSeconds(120);
      expect(cubit.state.remainingSeconds, 120);
      expect(cubit.state.durations.shortBreak, 300);
      expect(cubit.state.durations.focus, 1500);
      expect(cubit.state.durations.longBreak, 900);
    },
  );

  test('onFocusSessionCompleted is not called for break sessions', () async {
    int? savedMinutes;
    final breakCubit = TimerCubit(
      timerRepository: mockRepo,
      tickDuration: const Duration(milliseconds: 1),
      onFocusSessionCompleted: (minutes) async {
        savedMinutes = minutes;
      },
    );

    // Set to short break mode
    final initial = breakCubit.state.copyWith(
      remainingSeconds: 2,
      currentModeIndex: TimerCubit.modeShortBreak,
    );
    breakCubit.emit(initial);

    await breakCubit.startPauseTimer();

    expect(savedMinutes, isNull);
  });
}
