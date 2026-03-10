import 'package:flutter_test/flutter_test.dart';
import 'package:mindease_app/src/domain/entities/habit.dart';

void main() {
  group('Habit', () {
    test('should create a valid instance', () {
      final habit = Habit(
        id: '1',
        userEmail: 'user@test.com',
        name: 'Skincare dia',
        records: [DateTime(2026, 3, 4), DateTime(2026, 3, 5)],
      );
      expect(habit.id, '1');
      expect(habit.userEmail, 'user@test.com');
      expect(habit.name, 'Skincare dia');
      expect(habit.records.length, 2);
    });

    test('default records is empty list', () {
      const habit = Habit(id: '1', userEmail: 'u@t.com', name: 'Test');
      expect(habit.records, isEmpty);
    });

    test('fromMap creates habit from map', () {
      final map = {
        'userEmail': 'user@test.com',
        'name': 'Dormir 8h',
        'records': [
          '2026-03-04T00:00:00.000',
          '2026-03-05T00:00:00.000',
        ],
      };

      final habit = Habit.fromMap(map, id: 'doc1');
      expect(habit.id, 'doc1');
      expect(habit.userEmail, 'user@test.com');
      expect(habit.name, 'Dormir 8h');
      expect(habit.records.length, 2);
      expect(habit.records[0], DateTime(2026, 3, 4));
    });

    test('fromMap handles missing fields', () {
      final habit = Habit.fromMap({});
      expect(habit.id, '');
      expect(habit.userEmail, '');
      expect(habit.name, '');
      expect(habit.records, isEmpty);
    });

    test('toMap returns correct map', () {
      final habit = Habit(
        id: '1',
        userEmail: 'user@test.com',
        name: 'Exercício',
        records: [DateTime(2026, 3, 4)],
      );

      final map = habit.toMap();
      expect(map['userEmail'], 'user@test.com');
      expect(map['name'], 'Exercício');
      expect(map['records'], isA<List>());
      expect((map['records'] as List).length, 1);
      // id should not be in map (it's the doc id)
      expect(map.containsKey('id'), isFalse);
    });

    test('copyWith updates fields', () {
      const habit = Habit(id: '1', userEmail: 'u@t.com', name: 'Test');
      final updated = habit.copyWith(name: 'Updated');
      expect(updated.name, 'Updated');
      expect(updated.id, '1');
      expect(updated.userEmail, 'u@t.com');
    });

    test('copyWith does not mutate original', () {
      const habit = Habit(id: '1', userEmail: 'u@t.com', name: 'Test');
      habit.copyWith(name: 'Changed');
      expect(habit.name, 'Test');
    });

    test('hasRecordOn returns true for recorded day', () {
      final habit = Habit(
        id: '1',
        userEmail: 'u@t.com',
        name: 'Test',
        records: [DateTime(2026, 3, 4, 10, 30)],
      );
      expect(habit.hasRecordOn(DateTime(2026, 3, 4)), isTrue);
      expect(habit.hasRecordOn(DateTime(2026, 3, 4, 23, 59)), isTrue);
      expect(habit.hasRecordOn(DateTime(2026, 3, 5)), isFalse);
    });

    test('equality works correctly', () {
      const habit1 = Habit(id: '1', userEmail: 'u@t.com', name: 'Test');
      const habit2 = Habit(id: '1', userEmail: 'u@t.com', name: 'Test');
      const habit3 = Habit(id: '2', userEmail: 'u@t.com', name: 'Test');
      expect(habit1, equals(habit2));
      expect(habit1, isNot(equals(habit3)));
    });

    test('fromMap/toMap round trip preserves data', () {
      final original = Habit(
        id: 'doc1',
        userEmail: 'user@test.com',
        name: 'Leitura',
        records: [DateTime(2026, 3, 2), DateTime(2026, 3, 4)],
      );

      final map = original.toMap();
      final restored = Habit.fromMap(map, id: 'doc1');

      expect(restored.id, original.id);
      expect(restored.userEmail, original.userEmail);
      expect(restored.name, original.name);
      expect(restored.records.length, original.records.length);
    });
  });
}
