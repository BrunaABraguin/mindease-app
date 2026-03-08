import 'package:flutter_test/flutter_test.dart';
import 'package:mindease_app/src/domain/entities/timer_entity.dart';

void main() {
  group('TimerEntity', () {
    test('should create a valid instance', () {
      final timer = TimerEntity(
        durations: const TimerDurations(
          focus: 25,
          shortBreak: 5,
          longBreak: 15,
        ),
        currentCycle: 1,
        totalCycles: 4,
        remainingSeconds: 1500,
        completedSessions: 0,
        currentModeIndex: 0,
      );
      expect(timer.durations.focus, 25);
      expect(timer.durations.shortBreak, 5);
      expect(timer.durations.longBreak, 15);
      expect(timer.currentCycle, 1);
      expect(timer.totalCycles, 4);
      expect(timer.remainingSeconds, 1500);
      expect(timer.completedSessions, 0);
      expect(timer.currentModeIndex, 0);
    });

    test('copyWith should update fields', () {
      final timer = TimerEntity(
        durations: const TimerDurations(
          focus: 25,
          shortBreak: 5,
          longBreak: 15,
        ),
        currentCycle: 1,
        totalCycles: 4,
        remainingSeconds: 1500,
        completedSessions: 0,
        currentModeIndex: 0,
      );
      final updated = timer.copyWith(
        durations: const TimerDurations(
          focus: 30,
          shortBreak: 10,
          longBreak: 20,
        ),
        currentCycle: 2,
        totalCycles: 6,
        remainingSeconds: 1200,
        completedSessions: 1,
        currentModeIndex: 1,
      );
      expect(updated.durations.focus, 30);
      expect(updated.durations.shortBreak, 10);
      expect(updated.durations.longBreak, 20);
      expect(updated.currentCycle, 2);
      expect(updated.totalCycles, 6);
      expect(updated.remainingSeconds, 1200);
      expect(updated.completedSessions, 1);
      expect(updated.currentModeIndex, 1);
    });

    test('copyWith should not mutate original instance', () {
      final timer = TimerEntity(
        durations: const TimerDurations(
          focus: 25,
          shortBreak: 5,
          longBreak: 15,
        ),
        currentCycle: 1,
        totalCycles: 4,
        remainingSeconds: 1500,
        completedSessions: 0,
        currentModeIndex: 0,
      );
      final updated = timer.copyWith(
        durations: const TimerDurations(
          focus: 99,
          shortBreak: 5,
          longBreak: 15,
        ),
      );
      // Original instance remains unchanged
      expect(timer.durations.focus, 25);
      expect(timer.durations.shortBreak, 5);
      expect(timer.durations.longBreak, 15);
      expect(timer.currentCycle, 1);
      expect(timer.totalCycles, 4);
      expect(timer.remainingSeconds, 1500);
      expect(timer.completedSessions, 0);
      expect(timer.currentModeIndex, 0);
      // Updated instance has the new value
      expect(updated.durations.focus, 99);
    });

    test('copyWith should keep original values if not provided', () {
      final timer = TimerEntity(
        durations: const TimerDurations(
          focus: 25,
          shortBreak: 5,
          longBreak: 15,
        ),
        currentCycle: 1,
        totalCycles: 4,
        remainingSeconds: 1500,
        completedSessions: 0,
        currentModeIndex: 0,
      );
      final updated = timer.copyWith();
      expect(updated.durations.focus, 25);
      expect(updated.durations.shortBreak, 5);
      expect(updated.durations.longBreak, 15);
      expect(updated.currentCycle, 1);
      expect(updated.totalCycles, 4);
      expect(updated.remainingSeconds, 1500);
      expect(updated.completedSessions, 0);
      expect(updated.currentModeIndex, 0);
    });

    test('should handle zero and negative values', () {
      final timer = TimerEntity(
        durations: const TimerDurations(focus: 0, shortBreak: -5, longBreak: 0),
        currentCycle: -1,
        totalCycles: 0,
        remainingSeconds: -100,
        completedSessions: -2,
        currentModeIndex: -1,
      );
      expect(timer.durations.focus, 0);
      expect(timer.durations.shortBreak, -5);
      expect(timer.durations.longBreak, 0);
      expect(timer.currentCycle, -1);
      expect(timer.totalCycles, 0);
      expect(timer.remainingSeconds, -100);
      expect(timer.completedSessions, -2);
      expect(timer.currentModeIndex, -1);
    });

    test('should handle large integer values', () {
      const maxInt = 9223372036854775807;
      final timer = TimerEntity(
        durations: const TimerDurations(
          focus: maxInt,
          shortBreak: maxInt,
          longBreak: maxInt,
        ),
        currentCycle: maxInt,
        totalCycles: maxInt,
        remainingSeconds: maxInt,
        completedSessions: maxInt,
        currentModeIndex: maxInt,
      );
      expect(timer.durations.focus, maxInt);
      expect(timer.durations.shortBreak, maxInt);
      expect(timer.durations.longBreak, maxInt);
      expect(timer.currentCycle, maxInt);
      expect(timer.totalCycles, maxInt);
      expect(timer.remainingSeconds, maxInt);
      expect(timer.completedSessions, maxInt);
      expect(timer.currentModeIndex, maxInt);
    });

    test('toString returns correct format', () {
      final timer = TimerEntity(
        durations: const TimerDurations(
          focus: 25,
          shortBreak: 5,
          longBreak: 15,
        ),
        currentCycle: 1,
        totalCycles: 4,
        remainingSeconds: 1500,
        completedSessions: 0,
        currentModeIndex: 0,
      );
      expect(
        timer.toString(),
        'TimerEntity(durations: TimerDurations(focus: 25, shortBreak: 5, longBreak: 15), currentCycle: 1, totalCycles: 4, remainingSeconds: 1500, completedSessions: 0, currentModeIndex: 0, isRunning: false)',
      );
    });

    test('equality and hashCode', () {
      final timer1 = TimerEntity(
        durations: const TimerDurations(
          focus: 25,
          shortBreak: 5,
          longBreak: 15,
        ),
        currentCycle: 1,
        totalCycles: 4,
        remainingSeconds: 1500,
        completedSessions: 0,
        currentModeIndex: 0,
      );
      final timer2 = TimerEntity(
        durations: const TimerDurations(
          focus: 25,
          shortBreak: 5,
          longBreak: 15,
        ),
        currentCycle: 1,
        totalCycles: 4,
        remainingSeconds: 1500,
        completedSessions: 0,
        currentModeIndex: 0,
      );
      final timer3 = timer1.copyWith(
        durations: const TimerDurations(
          focus: 30,
          shortBreak: 5,
          longBreak: 15,
        ),
      );
      expect(timer1, equals(timer2));
      expect(timer1.hashCode, equals(timer2.hashCode));
      expect(timer1, isNot(equals(timer3)));
    });
  });
}
