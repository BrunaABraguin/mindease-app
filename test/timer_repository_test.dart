import 'package:flutter_test/flutter_test.dart';
import 'package:mindease_app/src/data/repositories/timer_repository.dart';
import 'package:mindease_app/src/domain/entities/timer_entity.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('TimerRepository', () {
    late TimerRepository repository;
    late TimerEntity timer;

    setUp(() {
      SharedPreferences.setMockInitialValues({});
      repository = TimerRepository();
      timer = TimerEntity(
        durations: const TimerDurations(
          focus: 1500,
          shortBreak: 300,
          longBreak: 900,
        ),
        currentCycle: 2,
        totalCycles: 4,
        remainingSeconds: 1200,
        completedSessions: 1,
        currentModeIndex: 0,
      );
    });

    test('should save and load TimerEntity', () async {
      await repository.saveTimerEntity(timer);
      final loaded = await repository.loadTimerEntity();
      expect(loaded, isNotNull);
      expect(loaded!.durations.focus, timer.durations.focus);
      expect(loaded.durations.shortBreak, timer.durations.shortBreak);
      expect(loaded.durations.longBreak, timer.durations.longBreak);
      expect(loaded.currentCycle, timer.currentCycle);
      expect(loaded.totalCycles, timer.totalCycles);
      expect(loaded.remainingSeconds, timer.remainingSeconds);
      expect(loaded.completedSessions, timer.completedSessions);
      expect(loaded.currentModeIndex, timer.currentModeIndex);
    });

    test('should return null if nothing saved', () async {
      final loaded = await repository.loadTimerEntity();
      expect(loaded, isNull);
    });
  });
}
