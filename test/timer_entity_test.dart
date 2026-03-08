import 'package:flutter_test/flutter_test.dart';
import 'package:mindease_app/src/domain/entities/timer_entity.dart';

void main() {
  group('TimerEntity', () {
    test('should create a valid instance', () {
      final timer = TimerEntity(
        focusTime: 25,
        breakTime: 5,
        longBreakTime: 15,
        currentCycle: 1,
        totalCycles: 4,
        remainingSeconds: 1500,
        completedSessions: 0,
        currentModeIndex: 0,
      );
      expect(timer.focusTime, 25);
      expect(timer.breakTime, 5);
      expect(timer.longBreakTime, 15);
      expect(timer.currentCycle, 1);
      expect(timer.totalCycles, 4);
      expect(timer.remainingSeconds, 1500);
      expect(timer.completedSessions, 0);
      expect(timer.currentModeIndex, 0);
    });

    test('copyWith should update fields', () {
      final timer = TimerEntity(
        focusTime: 25,
        breakTime: 5,
        longBreakTime: 15,
        currentCycle: 1,
        totalCycles: 4,
        remainingSeconds: 1500,
        completedSessions: 0,
        currentModeIndex: 0,
      );
      final updated = timer.copyWith(
        focusTime: 30,
        breakTime: 10,
        longBreakTime: 20,
        currentCycle: 2,
        totalCycles: 6,
        remainingSeconds: 1200,
        completedSessions: 1,
        currentModeIndex: 1,
      );
      expect(updated.focusTime, 30);
      expect(updated.breakTime, 10);
      expect(updated.longBreakTime, 20);
      expect(updated.currentCycle, 2);
      expect(updated.totalCycles, 6);
      expect(updated.remainingSeconds, 1200);
      expect(updated.completedSessions, 1);
      expect(updated.currentModeIndex, 1);
    });

    test('copyWith should not mutate original instance', () {
      final timer = TimerEntity(
        focusTime: 25,
        breakTime: 5,
        longBreakTime: 15,
        currentCycle: 1,
        totalCycles: 4,
        remainingSeconds: 1500,
        completedSessions: 0,
        currentModeIndex: 0,
      );
      final updated = timer.copyWith(focusTime: 99);
      // Original instance remains unchanged
      expect(timer.focusTime, 25);
      expect(timer.breakTime, 5);
      expect(timer.longBreakTime, 15);
      expect(timer.currentCycle, 1);
      expect(timer.totalCycles, 4);
      expect(timer.remainingSeconds, 1500);
      expect(timer.completedSessions, 0);
      expect(timer.currentModeIndex, 0);
      // Updated instance has the new value
      expect(updated.focusTime, 99);
    });

    test('copyWith should keep original values if not provided', () {
      final timer = TimerEntity(
        focusTime: 25,
        breakTime: 5,
        longBreakTime: 15,
        currentCycle: 1,
        totalCycles: 4,
        remainingSeconds: 1500,
        completedSessions: 0,
        currentModeIndex: 0,
      );
      final updated = timer.copyWith();
      expect(updated.focusTime, 25);
      expect(updated.breakTime, 5);
      expect(updated.longBreakTime, 15);
      expect(updated.currentCycle, 1);
      expect(updated.totalCycles, 4);
      expect(updated.remainingSeconds, 1500);
      expect(updated.completedSessions, 0);
      expect(updated.currentModeIndex, 0);
    });

    test('should handle zero and negative values', () {
      final timer = TimerEntity(
        focusTime: 0,
        breakTime: -5,
        longBreakTime: 0,
        currentCycle: -1,
        totalCycles: 0,
        remainingSeconds: -100,
        completedSessions: -2,
        currentModeIndex: -1,
      );
      expect(timer.focusTime, 0);
      expect(timer.breakTime, -5);
      expect(timer.longBreakTime, 0);
      expect(timer.currentCycle, -1);
      expect(timer.totalCycles, 0);
      expect(timer.remainingSeconds, -100);
      expect(timer.completedSessions, -2);
      expect(timer.currentModeIndex, -1);
    });

    test('should handle large integer values', () {
      const maxInt = 9223372036854775807;
      final timer = TimerEntity(
        focusTime: maxInt,
        breakTime: maxInt,
        longBreakTime: maxInt,
        currentCycle: maxInt,
        totalCycles: maxInt,
        remainingSeconds: maxInt,
        completedSessions: maxInt,
        currentModeIndex: maxInt,
      );
      expect(timer.focusTime, maxInt);
      expect(timer.breakTime, maxInt);
      expect(timer.longBreakTime, maxInt);
      expect(timer.currentCycle, maxInt);
      expect(timer.totalCycles, maxInt);
      expect(timer.remainingSeconds, maxInt);
      expect(timer.completedSessions, maxInt);
      expect(timer.currentModeIndex, maxInt);
    });
  });
}
