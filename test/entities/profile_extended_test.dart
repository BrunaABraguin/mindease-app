import 'package:flutter_test/flutter_test.dart';
import 'package:mindease_app/src/domain/entities/profile.dart';

void main() {
  group('Profile additional coverage', () {
    test('copyWith with only userEmail changes userEmail', () {
      const profile = Profile(
        userEmail: 'a@b.com',
        strikeDays: 3,
        totalFocusMinutes: 50,
        totalTasks: 2,
        totalMissions: 1,
        completedMissions: ['m1'],
        lastCompletionDate: null,
      );
      final copy = profile.copyWith(userEmail: 'new@b.com');
      expect(copy.userEmail, 'new@b.com');
      expect(copy.strikeDays, 3);
      expect(copy.totalFocusMinutes, 50);
      expect(copy.totalTasks, 2);
      expect(copy.totalMissions, 1);
      expect(copy.completedMissions, ['m1']);
      expect(copy.lastCompletionDate, isNull);
    });

    test('copyWith with lastCompletionDate', () {
      const profile = Profile(userEmail: 'a@b.com');
      final copy = profile.copyWith(lastCompletionDate: DateTime(2025, 12, 25));
      expect(copy.lastCompletionDate, DateTime(2025, 12, 25));
    });

    test('fromMap with invalid lastCompletionDate string', () {
      final profile = Profile.fromMap({
        'userEmail': 'a@b.com',
        'lastCompletionDate': 'not-a-date',
      });
      expect(profile.lastCompletionDate, isNull);
    });

    test('equality differs when completedMissions have different lengths', () {
      const a = Profile(userEmail: 'a@b.com', completedMissions: ['m1']);
      const b = Profile(userEmail: 'a@b.com', completedMissions: ['m1', 'm2']);
      expect(a, isNot(equals(b)));
    });

    test('hashCode differs for different profiles', () {
      const a = Profile(userEmail: 'a@b.com', strikeDays: 1);
      const b = Profile(userEmail: 'a@b.com', strikeDays: 2);
      // Different hashCodes (in general, not guaranteed but likely)
      expect(a.hashCode != b.hashCode, isTrue);
    });

    test('equality with different totalTasks', () {
      const a = Profile(userEmail: 'a@b.com', totalTasks: 1);
      const b = Profile(userEmail: 'a@b.com', totalTasks: 2);
      expect(a, isNot(equals(b)));
    });

    test('equality with different totalMissions', () {
      const a = Profile(userEmail: 'a@b.com', totalMissions: 1);
      const b = Profile(userEmail: 'a@b.com', totalMissions: 2);
      expect(a, isNot(equals(b)));
    });

    test('equality with different totalFocusMinutes', () {
      const a = Profile(userEmail: 'a@b.com', totalFocusMinutes: 10);
      const b = Profile(userEmail: 'a@b.com', totalFocusMinutes: 20);
      expect(a, isNot(equals(b)));
    });

    test('equality with different lastCompletionDate', () {
      final a = Profile(
        userEmail: 'a@b.com',
        lastCompletionDate: DateTime(2025, 1, 1),
      );
      final b = Profile(
        userEmail: 'a@b.com',
        lastCompletionDate: DateTime(2025, 1, 2),
      );
      expect(a, isNot(equals(b)));
    });

    test('toMap and fromMap roundtrip with all fields', () {
      final original = Profile(
        userEmail: 'round@trip.com',
        strikeDays: 10,
        totalFocusMinutes: 500,
        totalTasks: 25,
        totalMissions: 5,
        completedMissions: const ['a', 'b', 'c'],
        lastCompletionDate: DateTime(2025, 6, 15),
      );
      final map = original.toMap();
      final restored = Profile.fromMap(map);
      expect(restored.userEmail, original.userEmail);
      expect(restored.strikeDays, original.strikeDays);
      expect(restored.totalFocusMinutes, original.totalFocusMinutes);
      expect(restored.totalTasks, original.totalTasks);
      expect(restored.totalMissions, original.totalMissions);
      expect(restored.completedMissions, original.completedMissions);
    });
  });
}
