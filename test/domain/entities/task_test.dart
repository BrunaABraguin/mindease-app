import 'package:flutter_test/flutter_test.dart';
import 'package:mindease_app/src/domain/entities/task.dart';

void main() {
  group('Task', () {
    test('fromMap creates task with all fields', () {
      final map = {
        'userEmail': 'user@test.com',
        'name': 'Study',
        'spendTime': 25,
        'isDone': true,
        'isPriority': true,
        'completedAt': '2026-03-10T10:00:00.000',
      };
      final task = Task.fromMap(map, id: 'abc');
      expect(task.id, 'abc');
      expect(task.userEmail, 'user@test.com');
      expect(task.name, 'Study');
      expect(task.spendTime, 25);
      expect(task.isDone, true);
      expect(task.isPriority, true);
      expect(task.completedAt, DateTime(2026, 3, 10, 10));
    });

    test('fromMap uses defaults for missing fields', () {
      final task = Task.fromMap({});
      expect(task.id, '');
      expect(task.userEmail, '');
      expect(task.name, '');
      expect(task.spendTime, 0);
      expect(task.isDone, false);
      expect(task.isPriority, false);
      expect(task.completedAt, isNull);
    });

    test('fromMap uses id from map when no id parameter', () {
      final task = Task.fromMap({'id': 'map-id'});
      expect(task.id, 'map-id');
    });

    test('fromMap with null completedAt', () {
      final task = Task.fromMap({'completedAt': null});
      expect(task.completedAt, isNull);
    });

    test('toMap converts task to map', () {
      final task = Task(
        id: '1',
        userEmail: 'a@b.com',
        name: 'Test',
        spendTime: 10,
        isDone: true,
        completedAt: DateTime(2026),
      );
      final map = task.toMap();
      expect(map['userEmail'], 'a@b.com');
      expect(map['name'], 'Test');
      expect(map['spendTime'], 10);
      expect(map['isDone'], true);
      expect(map['isPriority'], false);
      expect(map['completedAt'], '2026-01-01T00:00:00.000');
    });

    test('toMap with null completedAt', () {
      const task = Task(id: '1', userEmail: 'a@b.com', name: 'T');
      expect(task.toMap()['completedAt'], isNull);
    });

    test('copyWith updates specified fields', () {
      const task = Task(id: '1', userEmail: 'a@b.com', name: 'Old');
      final updated = task.copyWith(
        name: 'New',
        isDone: true,
        spendTime: 5,
        isPriority: true,
        completedAt: DateTime(2026),
      );
      expect(updated.name, 'New');
      expect(updated.isDone, true);
      expect(updated.spendTime, 5);
      expect(updated.isPriority, true);
      expect(updated.completedAt, DateTime(2026));
      expect(updated.id, '1');
      expect(updated.userEmail, 'a@b.com');
    });

    test('copyWith preserves unmodified fields', () {
      const task = Task(
        id: '1',
        userEmail: 'a@b.com',
        name: 'T',
        spendTime: 10,
        isDone: true,
        isPriority: true,
      );
      final updated = task.copyWith();
      expect(updated.id, task.id);
      expect(updated.userEmail, task.userEmail);
      expect(updated.name, task.name);
      expect(updated.spendTime, task.spendTime);
      expect(updated.isDone, task.isDone);
      expect(updated.isPriority, task.isPriority);
    });

    test('copyWith id and userEmail', () {
      const task = Task(id: '1', userEmail: 'a@b.com', name: 'T');
      final updated = task.copyWith(id: '2', userEmail: 'x@y.com');
      expect(updated.id, '2');
      expect(updated.userEmail, 'x@y.com');
    });

    test('equality for equal tasks', () {
      const a = Task(id: '1', userEmail: 'a@b.com', name: 'T');
      const b = Task(id: '1', userEmail: 'a@b.com', name: 'T');
      expect(a, equals(b));
    });

    test('equality identical returns true', () {
      const a = Task(id: '1', userEmail: 'a@b.com', name: 'T');
      expect(a == a, isTrue);
    });

    test('equality different type returns false', () {
      const a = Task(id: '1', userEmail: 'a@b.com', name: 'T');
      // ignore: unrelated_type_equality_checks
      expect(a == 'not a task', isFalse);
    });

    test('inequality for different tasks', () {
      const a = Task(id: '1', userEmail: 'a@b.com', name: 'A');
      const b = Task(id: '2', userEmail: 'a@b.com', name: 'B');
      expect(a, isNot(equals(b)));
    });

    test('hashCode same for equal tasks', () {
      const a = Task(id: '1', userEmail: 'a@b.com', name: 'T');
      const b = Task(id: '1', userEmail: 'a@b.com', name: 'T');
      expect(a.hashCode, b.hashCode);
    });

    test('hashCode differs for different tasks', () {
      const a = Task(id: '1', userEmail: 'a@b.com', name: 'A');
      const b = Task(id: '2', userEmail: 'x@y.com', name: 'B');
      expect(a.hashCode, isNot(b.hashCode));
    });

    test('default constructor values', () {
      const task = Task(id: '', userEmail: '', name: '');
      expect(task.spendTime, 0);
      expect(task.isDone, false);
      expect(task.isPriority, false);
      expect(task.completedAt, isNull);
    });
  });
}
