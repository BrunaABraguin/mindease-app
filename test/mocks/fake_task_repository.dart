import 'dart:async';

import 'package:mindease_app/src/domain/entities/task.dart';
import 'package:mindease_app/src/domain/repositories/task_repository.dart';

class FakeTaskRepository implements TaskRepository {
  final List<Task> _tasks = [];
  final StreamController<List<Task>> _controller =
      StreamController<List<Task>>.broadcast();
  int _idCounter = 0;

  @override
  Future<List<Task>> loadTasks(String userEmail) async {
    return _tasks.where((t) => t.userEmail == userEmail).toList();
  }

  @override
  Future<Task> addTask(Task task) async {
    _idCounter++;
    final saved = task.copyWith(id: 'task_$_idCounter');
    _tasks.add(saved);
    _emitTasks(saved.userEmail);
    return saved;
  }

  @override
  Future<void> updateTask(Task task) async {
    final index = _tasks.indexWhere((t) => t.id == task.id);
    if (index != -1) {
      _tasks[index] = task;
      _emitTasks(task.userEmail);
    }
  }

  @override
  Future<void> deleteTask(String taskId) async {
    final task = _tasks.firstWhere(
      (t) => t.id == taskId,
      orElse: () => const Task(id: '', userEmail: '', name: ''),
    );
    _tasks.removeWhere((t) => t.id == taskId);
    if (task.userEmail.isNotEmpty) {
      _emitTasks(task.userEmail);
    }
  }

  @override
  Future<void> completeTask(String taskId) async {
    final index = _tasks.indexWhere((t) => t.id == taskId);
    if (index != -1) {
      _tasks[index] = _tasks[index].copyWith(
        isDone: true,
        completedAt: DateTime.now(),
      );
      _emitTasks(_tasks[index].userEmail);
    }
  }

  @override
  Future<void> updateSpendTime(String taskId, int minutes) async {
    final index = _tasks.indexWhere((t) => t.id == taskId);
    if (index != -1) {
      _tasks[index] = _tasks[index].copyWith(
        spendTime: _tasks[index].spendTime + minutes,
      );
      _emitTasks(_tasks[index].userEmail);
    }
  }

  @override
  Stream<List<Task>> tasksStream(String userEmail) {
    _emitTasks(userEmail);
    return _controller.stream.map(
      (tasks) => tasks.where((t) => t.userEmail == userEmail).toList(),
    );
  }

  void _emitTasks(String userEmail) {
    _controller.add(List.unmodifiable(_tasks));
  }

  void dispose() {
    _controller.close();
  }
}
