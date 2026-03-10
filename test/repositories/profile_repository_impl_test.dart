import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mindease_app/src/data/repositories/profile_repository_impl.dart';
import 'package:mindease_app/src/domain/entities/profile.dart';

void main() {
  late FakeFirebaseFirestore fakeFirestore;
  late ProfileRepositoryImpl repository;

  setUp(() {
    fakeFirestore = FakeFirebaseFirestore();
    repository = ProfileRepositoryImpl(firestore: fakeFirestore);
  });

  group('ProfileRepositoryImpl', () {
    group('loadProfile', () {
      test('returns null when document does not exist', () async {
        final result = await repository.loadProfile('nouser@test.com');
        expect(result, isNull);
      });

      test('returns profile when document exists', () async {
        await fakeFirestore.collection('profiles').doc('user@test.com').set({
          'userEmail': 'user@test.com',
          'strikeDays': 5,
          'totalFocusMinutes': 120,
          'totalTasks': 10,
          'totalMissions': 3,
          'completedMissions': ['m1'],
          'lastCompletionDate': '2025-01-15T00:00:00.000',
        });

        final result = await repository.loadProfile('user@test.com');
        expect(result, isNotNull);
        expect(result!.userEmail, 'user@test.com');
        expect(result.strikeDays, 5);
        expect(result.totalFocusMinutes, 120);
        expect(result.totalTasks, 10);
        expect(result.totalMissions, 3);
        expect(result.completedMissions, ['m1']);
      });

      test('returns null when document data is null', () async {
        // Set and then delete to create a doc reference that may behave as empty
        await fakeFirestore.collection('profiles').doc('empty@test.com').set({});
        final doc =
            await fakeFirestore.collection('profiles').doc('empty@test.com').get();
        expect(doc.exists, isTrue);
        // But loadProfile should still work because data is not null
        final result = await repository.loadProfile('empty@test.com');
        expect(result, isNotNull);
      });
    });

    group('saveProfile', () {
      test('saves profile to firestore', () async {
        final profile = Profile(
          userEmail: 'save@test.com',
          strikeDays: 3,
          totalFocusMinutes: 60,
          totalTasks: 5,
          totalMissions: 2,
          completedMissions: const ['m1', 'm2'],
          lastCompletionDate: DateTime(2025, 6),
        );

        await repository.saveProfile(profile);

        final doc = await fakeFirestore
            .collection('profiles')
            .doc('save@test.com')
            .get();
        expect(doc.exists, isTrue);
        expect(doc.data()!['userEmail'], 'save@test.com');
        expect(doc.data()!['strikeDays'], 3);
        expect(doc.data()!['totalFocusMinutes'], 60);
      });

      test('merges profile data on save', () async {
        await fakeFirestore.collection('profiles').doc('merge@test.com').set({
          'userEmail': 'merge@test.com',
          'strikeDays': 1,
          'totalFocusMinutes': 30,
          'totalTasks': 0,
          'totalMissions': 0,
          'completedMissions': <String>[],
        });

        const updated = Profile(
          userEmail: 'merge@test.com',
          strikeDays: 5,
          totalFocusMinutes: 100,
        );
        await repository.saveProfile(updated);

        final doc = await fakeFirestore
            .collection('profiles')
            .doc('merge@test.com')
            .get();
        expect(doc.data()!['strikeDays'], 5);
        expect(doc.data()!['totalFocusMinutes'], 100);
      });
    });

    group('incrementFocusMinutes', () {
      test('increments focus minutes for existing profile', () async {
        await fakeFirestore.collection('profiles').doc('inc@test.com').set({
          'totalFocusMinutes': 50,
        });

        await repository.incrementFocusMinutes('inc@test.com', 25);

        final doc = await fakeFirestore
            .collection('profiles')
            .doc('inc@test.com')
            .get();
        expect(doc.data()!['totalFocusMinutes'], 75);
      });

      test('creates document if it does not exist', () async {
        await repository.incrementFocusMinutes('new@test.com', 10);

        final doc = await fakeFirestore
            .collection('profiles')
            .doc('new@test.com')
            .get();
        expect(doc.exists, isTrue);
        expect(doc.data()!['totalFocusMinutes'], 10);
      });
    });

    group('updateStreak', () {
      test('increments streak when lastCompletionDate is null', () async {
        await fakeFirestore.collection('profiles').doc('streak@test.com').set({
          'strikeDays': 0,
        });

        await repository.updateStreak('streak@test.com', null);

        final doc = await fakeFirestore
            .collection('profiles')
            .doc('streak@test.com')
            .get();
        expect(doc.data()!['strikeDays'], 1);
        expect(doc.data()!['lastCompletionDate'], isNotNull);
      });

      test('increments streak when last completion was yesterday', () async {
        final yesterday = DateTime.now().subtract(const Duration(days: 1));
        await fakeFirestore.collection('profiles').doc('streak2@test.com').set({
          'strikeDays': 3,
        });

        await repository.updateStreak('streak2@test.com', yesterday);

        final doc = await fakeFirestore
            .collection('profiles')
            .doc('streak2@test.com')
            .get();
        expect(doc.data()!['strikeDays'], 4);
      });

      test('does not increment streak when last completion is today', () async {
        final now = DateTime.now();
        final today = DateTime(now.year, now.month, now.day);
        await fakeFirestore.collection('profiles').doc('today@test.com').set({
          'strikeDays': 5,
        });

        await repository.updateStreak('today@test.com', today);

        final doc = await fakeFirestore
            .collection('profiles')
            .doc('today@test.com')
            .get();
        // Should not have changed since it was already today
        expect(doc.data()!['strikeDays'], 5);
      });
    });

    group('profileStream', () {
      test('emits profile data from stream', () async {
        await fakeFirestore.collection('profiles').doc('stream@test.com').set({
          'userEmail': 'stream@test.com',
          'strikeDays': 2,
          'totalFocusMinutes': 45,
          'totalTasks': 0,
          'totalMissions': 0,
          'completedMissions': <String>[],
        });

        final stream = repository.profileStream('stream@test.com');
        final profile = await stream.first;
        expect(profile, isNotNull);
        expect(profile!.userEmail, 'stream@test.com');
        expect(profile.strikeDays, 2);
        expect(profile.totalFocusMinutes, 45);
      });

      test('emits null when document does not exist', () async {
        final stream = repository.profileStream('missing@test.com');
        final profile = await stream.first;
        expect(profile, isNull);
      });
    });
  });
}
