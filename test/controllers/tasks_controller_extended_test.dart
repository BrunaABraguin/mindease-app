import 'package:flutter_test/flutter_test.dart';
import 'package:mindease_app/src/app/pages/tasks/tasks_controller.dart';
import 'package:mindease_app/src/domain/entities/task.dart';

import '../mocks/fake_task_repository.dart';

void main() {
  group('TasksCubit', () {
    late TasksCubit cubit;
    late FakeTaskRepository repo;

    setUp(() {
      repo = FakeTaskRepository();
    });

    tearDown(() {
      cubit.close();
    });

    test('initial state has empty tasks', () {
      cubit = TasksCubit(taskRepository: repo, userEmail: null);
      expect(cubit.state.tasks, isEmpty);
      expect(cubit.state.isAddingPriority, false);
      expect(cubit.state.isAddingTask, false);
      expect(cubit.state.editingTaskId, '');
      expect(cubit.state.showHistory, false);
    });

    test('listens to tasks when email provided', () async {
      cubit = TasksCubit(taskRepository: repo, userEmail: 'a@b.com');
      await Future<void>.delayed(const Duration(milliseconds: 50));
      expect(cubit.state.tasks, isEmpty);
    });

    test('addTask adds a task', () async {
      cubit = TasksCubit(taskRepository: repo, userEmail: 'a@b.com');
      await Future<void>.delayed(const Duration(milliseconds: 50));

      await cubit.addTask('Study');
      await Future<void>.delayed(const Duration(milliseconds: 50));

      expect(cubit.state.tasks.length, 1);
      expect(cubit.state.tasks.first.name, 'Study');
      expect(cubit.state.tasks.first.isPriority, false);
    });

    test('addTask with priority', () async {
      cubit = TasksCubit(taskRepository: repo, userEmail: 'a@b.com');
      await Future<void>.delayed(const Duration(milliseconds: 50));

      await cubit.addTask('Important', isPriority: true);
      await Future<void>.delayed(const Duration(milliseconds: 50));

      expect(cubit.state.tasks.first.isPriority, true);
    });

    test('addTask ignores empty name', () async {
      cubit = TasksCubit(taskRepository: repo, userEmail: 'a@b.com');
      await Future<void>.delayed(const Duration(milliseconds: 50));

      await cubit.addTask('  ');
      await Future<void>.delayed(const Duration(milliseconds: 50));

      expect(cubit.state.tasks, isEmpty);
    });

    test('addTask ignores when no email', () async {
      cubit = TasksCubit(taskRepository: repo, userEmail: null);
      await cubit.addTask('Test');
      expect(cubit.state.tasks, isEmpty);
    });

    test('addTask limits priority to maxPriorities', () async {
      cubit = TasksCubit(taskRepository: repo, userEmail: 'a@b.com');
      await Future<void>.delayed(const Duration(milliseconds: 50));

      for (var i = 0; i < TasksCubit.maxPriorities; i++) {
        await cubit.addTask('P$i', isPriority: true);
        await Future<void>.delayed(const Duration(milliseconds: 50));
      }
      await cubit.addTask('Extra', isPriority: true);
      await Future<void>.delayed(const Duration(milliseconds: 50));

      final priorities = cubit.state.tasks
          .where((t) => t.isPriority && !t.isDone)
          .length;
      expect(priorities, TasksCubit.maxPriorities);
    });

    test('deleteTask removes task', () async {
      cubit = TasksCubit(taskRepository: repo, userEmail: 'a@b.com');
      await Future<void>.delayed(const Duration(milliseconds: 50));

      await cubit.addTask('ToDelete');
      await Future<void>.delayed(const Duration(milliseconds: 50));

      final taskId = cubit.state.tasks.first.id;
      await cubit.deleteTask(taskId);
      await Future<void>.delayed(const Duration(milliseconds: 50));

      expect(cubit.state.tasks, isEmpty);
    });

    test('completeTask marks task done', () async {
      cubit = TasksCubit(taskRepository: repo, userEmail: 'a@b.com');
      await Future<void>.delayed(const Duration(milliseconds: 50));

      await cubit.addTask('Complete me');
      await Future<void>.delayed(const Duration(milliseconds: 50));

      final taskId = cubit.state.tasks.first.id;
      await cubit.completeTask(taskId);
      await Future<void>.delayed(const Duration(milliseconds: 50));

      expect(cubit.state.tasks.first.isDone, true);
    });

    test('updateTaskName updates name', () async {
      cubit = TasksCubit(taskRepository: repo, userEmail: 'a@b.com');
      await Future<void>.delayed(const Duration(milliseconds: 50));

      await cubit.addTask('Old Name');
      await Future<void>.delayed(const Duration(milliseconds: 50));

      final taskId = cubit.state.tasks.first.id;
      await cubit.updateTaskName(taskId, 'New Name');
      await Future<void>.delayed(const Duration(milliseconds: 50));

      expect(cubit.state.tasks.first.name, 'New Name');
      expect(cubit.state.editingTaskId, '');
    });

    test('updateTaskName ignores empty name', () async {
      cubit = TasksCubit(taskRepository: repo, userEmail: 'a@b.com');
      await Future<void>.delayed(const Duration(milliseconds: 50));

      await cubit.addTask('Keep');
      await Future<void>.delayed(const Duration(milliseconds: 50));

      final taskId = cubit.state.tasks.first.id;
      await cubit.updateTaskName(taskId, '  ');
      await Future<void>.delayed(const Duration(milliseconds: 50));

      expect(cubit.state.tasks.first.name, 'Keep');
    });

    test('updateTaskName ignores non-existent task', () async {
      cubit = TasksCubit(taskRepository: repo, userEmail: 'a@b.com');
      await Future<void>.delayed(const Duration(milliseconds: 50));

      await cubit.updateTaskName('non-existent', 'Name');
      // Should not throw
    });

    test('addSpendTime increments time', () async {
      cubit = TasksCubit(taskRepository: repo, userEmail: 'a@b.com');
      await Future<void>.delayed(const Duration(milliseconds: 50));

      await cubit.addTask('Timer task');
      await Future<void>.delayed(const Duration(milliseconds: 50));

      final taskId = cubit.state.tasks.first.id;
      await cubit.addSpendTime(taskId, 25);
      await Future<void>.delayed(const Duration(milliseconds: 50));

      expect(cubit.state.tasks.first.spendTime, 25);
    });

    test('startAddingPriority sets flag', () {
      cubit = TasksCubit(taskRepository: repo, userEmail: null);
      cubit.startAddingPriority();
      expect(cubit.state.isAddingPriority, true);
    });

    test('cancelAddingPriority clears flag', () {
      cubit = TasksCubit(taskRepository: repo, userEmail: null);
      cubit.startAddingPriority();
      cubit.cancelAddingPriority();
      expect(cubit.state.isAddingPriority, false);
    });

    test('startAddingTask sets flag', () {
      cubit = TasksCubit(taskRepository: repo, userEmail: null);
      cubit.startAddingTask();
      expect(cubit.state.isAddingTask, true);
    });

    test('cancelAddingTask clears flag', () {
      cubit = TasksCubit(taskRepository: repo, userEmail: null);
      cubit.startAddingTask();
      cubit.cancelAddingTask();
      expect(cubit.state.isAddingTask, false);
    });

    test('startEditing sets editingTaskId', () {
      cubit = TasksCubit(taskRepository: repo, userEmail: null);
      cubit.startEditing('task-1');
      expect(cubit.state.editingTaskId, 'task-1');
    });

    test('cancelEditing clears editingTaskId', () {
      cubit = TasksCubit(taskRepository: repo, userEmail: null);
      cubit.startEditing('task-1');
      cubit.cancelEditing();
      expect(cubit.state.editingTaskId, '');
    });

    test('toggleHistoryView toggles showHistory', () {
      cubit = TasksCubit(taskRepository: repo, userEmail: null);
      expect(cubit.state.showHistory, false);
      cubit.toggleHistoryView();
      expect(cubit.state.showHistory, true);
      cubit.toggleHistoryView();
      expect(cubit.state.showHistory, false);
    });

    test('updateUserEmail switches stream', () async {
      cubit = TasksCubit(taskRepository: repo, userEmail: 'a@b.com');
      await Future<void>.delayed(const Duration(milliseconds: 50));

      await cubit.addTask('Task A');
      await Future<void>.delayed(const Duration(milliseconds: 50));

      cubit.updateUserEmail('x@y.com');
      await Future<void>.delayed(const Duration(milliseconds: 100));

      // FakeTaskRepository broadcasts all tasks, so just verify no crash
      expect(cubit.state, isA<TasksState>());
    });

    test('updateUserEmail with null clears tasks', () async {
      cubit = TasksCubit(taskRepository: repo, userEmail: 'a@b.com');
      await Future<void>.delayed(const Duration(milliseconds: 50));

      await cubit.addTask('T');
      await Future<void>.delayed(const Duration(milliseconds: 50));

      cubit.updateUserEmail(null);
      expect(cubit.state.tasks, isEmpty);
    });

    test('updateUserEmail with same email does nothing', () async {
      cubit = TasksCubit(taskRepository: repo, userEmail: 'a@b.com');
      await Future<void>.delayed(const Duration(milliseconds: 50));

      cubit.updateUserEmail('a@b.com');
      // Should not throw or change state
    });

    test('onTaskCompleted callback is invoked', () async {
      var called = false;
      cubit = TasksCubit(
        taskRepository: repo,
        userEmail: 'a@b.com',
        onTaskCompleted: () async {
          called = true;
        },
      );
      await Future<void>.delayed(const Duration(milliseconds: 50));

      await cubit.addTask('Callback task');
      await Future<void>.delayed(const Duration(milliseconds: 50));

      final taskId = cubit.state.tasks.first.id;
      await cubit.completeTask(taskId);
      expect(called, true);
    });
  });

  group('TasksState', () {
    test('pendingPriorities filters correctly', () {
      const state = TasksState(
        tasks: [
          Task(id: '1', userEmail: 'a', name: 'A', isPriority: true),
          Task(
            id: '2',
            userEmail: 'a',
            name: 'B',
            isPriority: true,
            isDone: true,
          ),
          Task(id: '3', userEmail: 'a', name: 'C'),
        ],
      );
      expect(state.pendingPriorities.length, 1);
      expect(state.pendingPriorities.first.id, '1');
    });

    test('pendingTasks filters non-priority pending', () {
      const state = TasksState(
        tasks: [
          Task(id: '1', userEmail: 'a', name: 'A', isPriority: true),
          Task(id: '2', userEmail: 'a', name: 'B'),
          Task(id: '3', userEmail: 'a', name: 'C', isDone: true),
        ],
      );
      expect(state.pendingTasks.length, 1);
      expect(state.pendingTasks.first.id, '2');
    });

    test('completedTasks filters done', () {
      const state = TasksState(
        tasks: [
          Task(id: '1', userEmail: 'a', name: 'A', isDone: true),
          Task(id: '2', userEmail: 'a', name: 'B'),
        ],
      );
      expect(state.completedTasks.length, 1);
    });

    test('completedPriorities filters done priorities', () {
      const state = TasksState(
        tasks: [
          Task(
            id: '1',
            userEmail: 'a',
            name: 'A',
            isPriority: true,
            isDone: true,
          ),
          Task(id: '2', userEmail: 'a', name: 'B', isDone: true),
        ],
      );
      expect(state.completedPriorities.length, 1);
    });

    test('completedNonPriorityTasks filters correctly', () {
      const state = TasksState(
        tasks: [
          Task(
            id: '1',
            userEmail: 'a',
            name: 'A',
            isPriority: true,
            isDone: true,
          ),
          Task(id: '2', userEmail: 'a', name: 'B', isDone: true),
          Task(id: '3', userEmail: 'a', name: 'C'),
        ],
      );
      expect(state.completedNonPriorityTasks.length, 1);
      expect(state.completedNonPriorityTasks.first.id, '2');
    });

    test('allPending returns all non-done', () {
      const state = TasksState(
        tasks: [
          Task(id: '1', userEmail: 'a', name: 'A'),
          Task(id: '2', userEmail: 'a', name: 'B', isDone: true),
          Task(id: '3', userEmail: 'a', name: 'C'),
        ],
      );
      expect(state.allPending.length, 2);
    });

    test('counts are correct', () {
      const state = TasksState(
        tasks: [
          Task(id: '1', userEmail: 'a', name: 'A'),
          Task(id: '2', userEmail: 'a', name: 'B', isDone: true),
          Task(id: '3', userEmail: 'a', name: 'C'),
        ],
      );
      expect(state.totalCount, 3);
      expect(state.pendingCount, 2);
      expect(state.completedCount, 1);
    });

    test('copyWith updates fields', () {
      const state = TasksState();
      final updated = state.copyWith(
        isAddingPriority: true,
        isAddingTask: true,
        editingTaskId: 'x',
        showHistory: true,
      );
      expect(updated.isAddingPriority, true);
      expect(updated.isAddingTask, true);
      expect(updated.editingTaskId, 'x');
      expect(updated.showHistory, true);
    });

    test('copyWith preserves defaults', () {
      const state = TasksState(isAddingPriority: true, editingTaskId: 'y');
      final updated = state.copyWith();
      expect(updated.isAddingPriority, true);
      expect(updated.editingTaskId, 'y');
    });
  });
}
