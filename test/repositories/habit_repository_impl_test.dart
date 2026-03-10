import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mindease_app/src/data/repositories/habit_repository_impl.dart';
import 'package:mindease_app/src/domain/entities/habit.dart';

void main() {
  late FakeFirebaseFirestore fakeFirestore;
  late HabitRepositoryImpl repository;

  setUp(() {
    fakeFirestore = FakeFirebaseFirestore();
    repository = HabitRepositoryImpl(firestore: fakeFirestore);
  });

  group('HabitRepositoryImpl', () {
    group('addHabit', () {
      test('adds habit and returns it with generated id', () async {
        const habit = Habit(
          id: '',
          userEmail: 'user@test.com',
          name: 'Skincare dia',
        );

        final saved = await repository.addHabit(habit);
        expect(saved.id, isNotEmpty);
        expect(saved.name, 'Skincare dia');
        expect(saved.userEmail, 'user@test.com');
      });
    });

    group('loadHabits', () {
      test('returns empty list when no habits exist', () async {
        final result = await repository.loadHabits('user@test.com');
        expect(result, isEmpty);
      });

      test('returns habits for the given user email', () async {
        await fakeFirestore.collection('habits').add({
          'userEmail': 'user@test.com',
          'name': 'Skincare',
          'records': [],
        });
        await fakeFirestore.collection('habits').add({
          'userEmail': 'other@test.com',
          'name': 'Other habit',
          'records': [],
        });

        final result = await repository.loadHabits('user@test.com');
        expect(result.length, 1);
        expect(result.first.name, 'Skincare');
      });
    });

    group('updateHabit', () {
      test('updates the habit name', () async {
        final docRef = await fakeFirestore.collection('habits').add({
          'userEmail': 'user@test.com',
          'name': 'Old Name',
          'records': [],
        });

        final habit = Habit(
          id: docRef.id,
          userEmail: 'user@test.com',
          name: 'New Name',
        );

        await repository.updateHabit(habit);

        final doc = await fakeFirestore.collection('habits').doc(docRef.id).get();
        expect(doc.data()!['name'], 'New Name');
      });
    });

    group('deleteHabit', () {
      test('deletes the habit document', () async {
        final docRef = await fakeFirestore.collection('habits').add({
          'userEmail': 'user@test.com',
          'name': 'To Delete',
          'records': [],
        });

        await repository.deleteHabit(docRef.id);

        final doc = await fakeFirestore.collection('habits').doc(docRef.id).get();
        expect(doc.exists, isFalse);
      });
    });

    group('toggleRecord', () {
      test('adds record when not present', () async {
        final docRef = await fakeFirestore.collection('habits').add({
          'userEmail': 'user@test.com',
          'name': 'Test',
          'records': [],
        });

        await repository.toggleRecord(docRef.id, DateTime(2026, 3, 4));

        final doc = await fakeFirestore.collection('habits').doc(docRef.id).get();
        final records = doc.data()!['records'] as List;
        expect(records.length, 1);
      });

      test('removes record when already present', () async {
        final docRef = await fakeFirestore.collection('habits').add({
          'userEmail': 'user@test.com',
          'name': 'Test',
          'records': ['2026-03-04T00:00:00.000'],
        });

        await repository.toggleRecord(docRef.id, DateTime(2026, 3, 4));

        final doc = await fakeFirestore.collection('habits').doc(docRef.id).get();
        final records = doc.data()!['records'] as List;
        expect(records, isEmpty);
      });

      test('does nothing for non-existent habit', () async {
        // Should not throw
        await repository.toggleRecord('nonexistent', DateTime(2026, 3, 4));
      });
    });

    group('habitsStream', () {
      test('emits habits for the given user', () async {
        await fakeFirestore.collection('habits').add({
          'userEmail': 'user@test.com',
          'name': 'Habit 1',
          'records': [],
        });

        final stream = repository.habitsStream('user@test.com');
        final first = await stream.first;
        expect(first.length, 1);
        expect(first.first.name, 'Habit 1');
      });
    });
  });
}
