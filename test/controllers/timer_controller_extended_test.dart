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
    cubit = TimerCubit(timerRepository: mockRepo);
  });

  tearDown(() => cubit.close());

  group('setTimerFromInput', () {
    test('sets timer from valid minutes string', () {
      cubit.setTimerFromInput('10');
      expect(cubit.state.remainingSeconds, 600);
      expect(cubit.state.durations.focus, 600);
      expect(cubit.state.isRunning, false);
    });

    test('sets timer from valid mm:ss string', () {
      cubit.setTimerFromInput('5:30');
      expect(cubit.state.remainingSeconds, 330);
      expect(cubit.state.durations.focus, 330);
    });

    test('does nothing for invalid input', () {
      final before = cubit.state;
      cubit.setTimerFromInput('abc');
      expect(cubit.state.durations.focus, before.durations.focus);
    });
  });

  group('setTimerSeconds', () {
    test('updates focus duration when in focus mode', () {
      cubit.setTimerSeconds(900);
      expect(cubit.state.durations.focus, 900);
      expect(cubit.state.remainingSeconds, 900);
      expect(cubit.state.isRunning, false);
    });

    test('updates shortBreak duration when in shortBreak mode', () async {
      await cubit.updateCurrentModeIndex(TimerCubit.modeShortBreak);
      cubit.setTimerSeconds(180);
      expect(cubit.state.durations.shortBreak, 180);
      expect(cubit.state.remainingSeconds, 180);
    });

    test('updates longBreak duration when in longBreak mode', () async {
      await cubit.updateCurrentModeIndex(TimerCubit.modeLongBreak);
      cubit.setTimerSeconds(600);
      expect(cubit.state.durations.longBreak, 600);
      expect(cubit.state.remainingSeconds, 600);
    });
  });

  group('updateCurrentCycle', () {
    test('updates current cycle to valid value', () {
      cubit.updateCurrentCycle(3);
      expect(cubit.state.currentCycle, 3);
    });

    test('ignores negative cycle value', () {
      cubit.updateCurrentCycle(2);
      cubit.updateCurrentCycle(-1);
      expect(cubit.state.currentCycle, 2);
    });

    test('ignores cycle value exceeding maxCycles', () {
      cubit.updateCurrentCycle(2);
      cubit.updateCurrentCycle(TimerCubit.maxCycles + 1);
      expect(cubit.state.currentCycle, 2);
    });
  });

  group('updateTotalCycles', () {
    test('updates total cycles to valid value', () {
      cubit.updateTotalCycles(6);
      expect(cubit.state.totalCycles, 6);
    });

    test('ignores zero total cycles', () {
      cubit.updateTotalCycles(0);
      expect(cubit.state.totalCycles, 4); // default
    });

    test('ignores total cycles exceeding maxCycles', () {
      cubit.updateTotalCycles(TimerCubit.maxCycles + 1);
      expect(cubit.state.totalCycles, 4); // default
    });
  });

  group('incrementSessionDuration', () {
    test('increments focus duration', () {
      final initialFocus = cubit.state.durations.focus;
      cubit.incrementSessionDuration();
      expect(cubit.state.durations.focus, initialFocus + 60);
    });

    test('increments shortBreak duration', () async {
      await cubit.updateCurrentModeIndex(TimerCubit.modeShortBreak);
      final initial = cubit.state.durations.shortBreak;
      cubit.incrementSessionDuration();
      expect(cubit.state.durations.shortBreak, initial + 60);
    });

    test('increments longBreak duration', () async {
      await cubit.updateCurrentModeIndex(TimerCubit.modeLongBreak);
      final initial = cubit.state.durations.longBreak;
      cubit.incrementSessionDuration();
      expect(cubit.state.durations.longBreak, initial + 60);
    });
  });

  group('_loadTimerEntity with corrected durations', () {
    test('corrects negative focus duration to default', () async {
      mockRepo.entityToLoad = TimerEntity(
        durations: const TimerDurations(
          focus: -1,
          shortBreak: 300,
          longBreak: 900,
        ),
        currentCycle: 0,
        totalCycles: 4,
        completedSessions: 0,
        currentModeIndex: 0,
      );

      final cubit2 = TimerCubit(timerRepository: mockRepo);
      await Future.delayed(const Duration(milliseconds: 50));
      expect(cubit2.state.durations.focus, TimerDurations.defaultFocus);
      expect(cubit2.state.durations.shortBreak, 300);
      expect(cubit2.state.durations.longBreak, 900);
      await cubit2.close();
    });

    test('corrects negative shortBreak duration to default', () async {
      mockRepo.entityToLoad = TimerEntity(
        durations: const TimerDurations(
          focus: 1500,
          shortBreak: -5,
          longBreak: 900,
        ),
        currentCycle: 0,
        totalCycles: 4,
        completedSessions: 0,
        currentModeIndex: 0,
      );

      final cubit2 = TimerCubit(timerRepository: mockRepo);
      await Future.delayed(const Duration(milliseconds: 50));
      expect(
        cubit2.state.durations.shortBreak,
        TimerDurations.defaultShortBreak,
      );
      await cubit2.close();
    });

    test('corrects negative longBreak duration to default', () async {
      mockRepo.entityToLoad = TimerEntity(
        durations: const TimerDurations(
          focus: 1500,
          shortBreak: 300,
          longBreak: -10,
        ),
        currentCycle: 0,
        totalCycles: 4,
        completedSessions: 0,
        currentModeIndex: 0,
      );

      final cubit2 = TimerCubit(timerRepository: mockRepo);
      await Future.delayed(const Duration(milliseconds: 50));
      expect(cubit2.state.durations.longBreak, TimerDurations.defaultLongBreak);
      await cubit2.close();
    });
  });

  group('startPauseTimer with zero remaining', () {
    test('resets remaining to total when zero and starts', () async {
      cubit.emit(
        cubit.state.copyWith(remainingSeconds: 0, status: const TimerStatus()),
      );

      final future = cubit.startPauseTimer();
      await Future.delayed(const Duration(milliseconds: 10));
      // Timer should be running with reset remaining
      expect(cubit.state.isRunning, true);

      // Stop it
      await cubit.startPauseTimer();
      await future;
    });
  });

  group('long break resets currentCycle', () {
    test('resets currentCycle after long break completes', () async {
      final breakCubit = TimerCubit(
        timerRepository: mockRepo,
        tickDuration: const Duration(milliseconds: 1),
      );
      await Future.delayed(const Duration(milliseconds: 10));

      breakCubit.emit(
        breakCubit.state.copyWith(
          remainingSeconds: 2,
          currentModeIndex: TimerCubit.modeLongBreak,
          currentCycle: 4,
        ),
      );

      await breakCubit.startPauseTimer();
      expect(breakCubit.state.currentCycle, 0);
      await breakCubit.close();
    });
  });
}
