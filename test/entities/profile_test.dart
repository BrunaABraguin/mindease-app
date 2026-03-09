import 'package:flutter_test/flutter_test.dart';
import 'package:mindease_app/src/domain/entities/profile.dart';

void main() {
  group('Profile', () {
    test('constructor sets default values', () {
      const profile = Profile(userEmail: 'test@test.com');
      expect(profile.userEmail, 'test@test.com');
      expect(profile.strikeDays, 0);
      expect(profile.totalFocusMinutes, 0);
      expect(profile.totalTasks, 0);
      expect(profile.totalMissions, 0);
      expect(profile.completedMissions, isEmpty);
      expect(profile.lastCompletionDate, isNull);
    });

    test('fromMap creates profile from map', () {
      final map = {
        'userEmail': 'user@test.com',
        'strikeDays': 5,
        'totalFocusMinutes': 120,
        'totalTasks': 10,
        'totalMissions': 3,
        'completedMissions': ['m1', 'm2'],
        'lastCompletionDate': '2025-01-15T00:00:00.000',
      };
      final profile = Profile.fromMap(map);
      expect(profile.userEmail, 'user@test.com');
      expect(profile.strikeDays, 5);
      expect(profile.totalFocusMinutes, 120);
      expect(profile.totalTasks, 10);
      expect(profile.totalMissions, 3);
      expect(profile.completedMissions, ['m1', 'm2']);
      expect(
        profile.lastCompletionDate,
        DateTime.parse('2025-01-15T00:00:00.000'),
      );
    });

    test('fromMap handles missing fields', () {
      final profile = Profile.fromMap({});
      expect(profile.userEmail, '');
      expect(profile.strikeDays, 0);
      expect(profile.totalFocusMinutes, 0);
      expect(profile.totalTasks, 0);
      expect(profile.totalMissions, 0);
      expect(profile.completedMissions, isEmpty);
      expect(profile.lastCompletionDate, isNull);
    });

    test('fromMap handles null lastCompletionDate', () {
      final profile = Profile.fromMap({
        'userEmail': 'a@b.com',
        'lastCompletionDate': null,
      });
      expect(profile.lastCompletionDate, isNull);
    });

    test('toMap converts profile to map', () {
      final date = DateTime(2025, 3);
      final profile = Profile(
        userEmail: 'u@t.com',
        strikeDays: 2,
        totalFocusMinutes: 60,
        totalTasks: 5,
        totalMissions: 1,
        completedMissions: const ['m1'],
        lastCompletionDate: date,
      );
      final map = profile.toMap();
      expect(map['userEmail'], 'u@t.com');
      expect(map['strikeDays'], 2);
      expect(map['totalFocusMinutes'], 60);
      expect(map['totalTasks'], 5);
      expect(map['totalMissions'], 1);
      expect(map['completedMissions'], ['m1']);
      expect(map['lastCompletionDate'], date.toIso8601String());
    });

    test('toMap with null lastCompletionDate', () {
      const profile = Profile(userEmail: 'a@b.com');
      final map = profile.toMap();
      expect(map['lastCompletionDate'], isNull);
    });

    test('copyWith creates modified copy', () {
      const profile = Profile(userEmail: 'a@b.com', strikeDays: 1);
      final copy = profile.copyWith(
        strikeDays: 5,
        totalFocusMinutes: 100,
        totalTasks: 10,
        totalMissions: 3,
        completedMissions: ['new'],
        lastCompletionDate: DateTime(2025, 6),
      );
      expect(copy.userEmail, 'a@b.com');
      expect(copy.strikeDays, 5);
      expect(copy.totalFocusMinutes, 100);
      expect(copy.totalTasks, 10);
      expect(copy.totalMissions, 3);
      expect(copy.completedMissions, ['new']);
      expect(copy.lastCompletionDate, DateTime(2025, 6));
    });

    test('copyWith preserves unmodified fields', () {
      final profile = Profile(
        userEmail: 'a@b.com',
        strikeDays: 3,
        totalFocusMinutes: 50,
        totalTasks: 2,
        totalMissions: 1,
        completedMissions: const ['m1'],
        lastCompletionDate: DateTime(2025),
      );
      final copy = profile.copyWith(userEmail: 'new@b.com');
      expect(copy.userEmail, 'new@b.com');
      expect(copy.strikeDays, 3);
      expect(copy.totalFocusMinutes, 50);
    });

    group('formattedFocusTime', () {
      test('returns minutes only when < 60', () {
        const profile = Profile(userEmail: '', totalFocusMinutes: 45);
        expect(profile.formattedFocusTime, '45m');
      });

      test('returns hours only when exact hours', () {
        const profile = Profile(userEmail: '', totalFocusMinutes: 120);
        expect(profile.formattedFocusTime, '2h');
      });

      test('returns hours and minutes', () {
        const profile = Profile(userEmail: '', totalFocusMinutes: 90);
        expect(profile.formattedFocusTime, '1h 30m');
      });

      test('returns 0m for zero minutes', () {
        const profile = Profile(userEmail: '');
        expect(profile.formattedFocusTime, '0m');
      });
    });

    group('equality', () {
      test('equal profiles are equal', () {
        const a = Profile(userEmail: 'a@b.com', strikeDays: 1);
        const b = Profile(userEmail: 'a@b.com', strikeDays: 1);
        expect(a, equals(b));
      });

      test('different profiles are not equal', () {
        const a = Profile(userEmail: 'a@b.com', strikeDays: 1);
        const b = Profile(userEmail: 'a@b.com', strikeDays: 2);
        expect(a, isNot(equals(b)));
      });

      test('identical returns true', () {
        const profile = Profile(userEmail: 'a@b.com');
        expect(profile == profile, isTrue);
      });

      test('different type returns false', () {
        const profile = Profile(userEmail: 'a@b.com');
        expect(profile == 'not a profile', isFalse);
      });
    });

    group('hashCode', () {
      test('same profiles have same hashCode', () {
        const a = Profile(userEmail: 'a@b.com', strikeDays: 1);
        const b = Profile(userEmail: 'a@b.com', strikeDays: 1);
        expect(a.hashCode, equals(b.hashCode));
      });
    });
  });
}
