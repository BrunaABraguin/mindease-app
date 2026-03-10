import 'package:flutter_test/flutter_test.dart';
import 'package:mindease_app/src/app/utils/mission_checker.dart';
import 'package:mindease_app/src/domain/entities/profile.dart';

void main() {
  group('MissionChecker.isMission', () {
    test('returns true for valid mission IDs', () {
      expect(MissionChecker.isMission('timer_first_session'), isTrue);
      expect(MissionChecker.isMission('timer_30_min'), isTrue);
      expect(MissionChecker.isMission('timer_long_break'), isTrue);
      expect(MissionChecker.isMission('habits_create_first'), isTrue);
      expect(MissionChecker.isMission('habits_complete_one'), isTrue);
      expect(MissionChecker.isMission('habits_streak_3'), isTrue);
      expect(MissionChecker.isMission('tasks_create_first'), isTrue);
      expect(MissionChecker.isMission('tasks_complete_one'), isTrue);
      expect(MissionChecker.isMission('tasks_complete_5'), isTrue);
      expect(MissionChecker.isMission('profile_login'), isTrue);
      expect(MissionChecker.isMission('profile_dark_theme'), isTrue);
    });

    test('returns false for unknown IDs', () {
      expect(MissionChecker.isMission('unknown_mission'), isFalse);
      expect(MissionChecker.isMission(''), isFalse);
    });
  });

  group('MissionChecker.shouldComplete', () {
    test('returns true for valid uncompleted mission', () {
      const profile = Profile(userEmail: 'a@b.com');
      expect(
        MissionChecker.shouldComplete(profile, 'timer_first_session'),
        isTrue,
      );
    });

    test('returns false for already completed mission', () {
      const profile = Profile(
        userEmail: 'a@b.com',
        completedMissions: ['timer_first_session'],
      );
      expect(
        MissionChecker.shouldComplete(profile, 'timer_first_session'),
        isFalse,
      );
    });

    test('returns false for invalid mission ID', () {
      const profile = Profile(userEmail: 'a@b.com');
      expect(MissionChecker.shouldComplete(profile, 'invalid'), isFalse);
    });
  });

  group('MissionChecker.hasStreak', () {
    test('returns false for fewer records than required', () {
      expect(MissionChecker.hasStreak([], 3), isFalse);
      expect(
        MissionChecker.hasStreak([DateTime(2026, 3)], 3),
        isFalse,
      );
    });

    test('returns true for consecutive days', () {
      final records = [
        DateTime(2026, 3),
        DateTime(2026, 3, 2),
        DateTime(2026, 3, 3),
      ];
      expect(MissionChecker.hasStreak(records, 3), isTrue);
    });

    test('returns false for non-consecutive days', () {
      final records = [
        DateTime(2026, 3),
        DateTime(2026, 3, 3),
        DateTime(2026, 3, 5),
      ];
      expect(MissionChecker.hasStreak(records, 3), isFalse);
    });

    test('returns true when streak exists in middle of records', () {
      final records = [
        DateTime(2026, 3),
        DateTime(2026, 3, 5),
        DateTime(2026, 3, 6),
        DateTime(2026, 3, 7),
      ];
      expect(MissionChecker.hasStreak(records, 3), isTrue);
    });

    test('handles duplicate dates', () {
      final records = [
        DateTime(2026, 3),
        DateTime(2026, 3),
        DateTime(2026, 3, 2),
        DateTime(2026, 3, 3),
      ];
      expect(MissionChecker.hasStreak(records, 3), isTrue);
    });

    test('handles unsorted records', () {
      final records = [
        DateTime(2026, 3, 3),
        DateTime(2026, 3),
        DateTime(2026, 3, 2),
      ];
      expect(MissionChecker.hasStreak(records, 3), isTrue);
    });
  });
}
