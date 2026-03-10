import 'dart:async';
import 'dart:developer' as developer;

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mindease_app/src/domain/entities/task.dart';
import 'package:mindease_app/src/domain/repositories/task_repository.dart';

class TasksCubit extends Cubit<TasksState> {
  TasksCubit({
    required TaskRepository taskRepository,
    required String? userEmail,
    this.onTaskCompleted,
  }) : _taskRepository = taskRepository,
       _userEmail = userEmail,
       super(const TasksState()) {
    if (_hasValidEmail) {
      _listenTasks();
    }
  }

  final TaskRepository _taskRepository;
  String? _userEmail;
  StreamSubscription<List<Task>>? _tasksSubscription;
  final Future<void> Function()? onTaskCompleted;

  static const int maxPriorities = 3;

  bool get _hasValidEmail => _userEmail != null && _userEmail!.isNotEmpty;

  void updateUserEmail(String? email) {
    if (email == _userEmail) return;
    _userEmail = email;
    _tasksSubscription?.cancel();
    if (email != null && email.isNotEmpty) {
      _listenTasks();
    } else {
      emit(state.copyWith(tasks: []));
    }
  }

  void _listenTasks() {
    _tasksSubscription?.cancel();
    _tasksSubscription = _taskRepository
        .tasksStream(_userEmail!)
        .listen(
          (tasks) {
            emit(state.copyWith(tasks: tasks));
          },
          onError: (error, stackTrace) {
            developer.log(
              'Error in tasksStream for $_userEmail: $error',
              name: 'TasksCubit',
              error: error,
              stackTrace: stackTrace,
            );
          },
        );
  }

  Future<void> addTask(String name, {bool isPriority = false}) async {
    if (!_hasValidEmail) return;
    if (name.trim().isEmpty) return;

    if (isPriority) {
      final currentPriorities = state.tasks
          .where((t) => t.isPriority && !t.isDone)
          .length;
      if (currentPriorities >= maxPriorities) return;
    }

    final task = Task(
      id: '',
      userEmail: _userEmail!,
      name: name.trim(),
      isPriority: isPriority,
    );
    await _taskRepository.addTask(task);
    emit(state.copyWith(isAddingPriority: false, isAddingTask: false));
  }

  Future<void> updateTaskName(String taskId, String newName) async {
    if (newName.trim().isEmpty) return;

    final task = state.tasks.firstWhere(
      (t) => t.id == taskId,
      orElse: () => const Task(id: '', userEmail: '', name: ''),
    );
    if (task.id.isEmpty) return;

    await _taskRepository.updateTask(task.copyWith(name: newName.trim()));
    emit(state.copyWith(editingTaskId: ''));
  }

  Future<void> deleteTask(String taskId) async {
    await _taskRepository.deleteTask(taskId);
  }

  Future<void> completeTask(String taskId) async {
    await _taskRepository.completeTask(taskId);
    await onTaskCompleted?.call();
  }

  Future<void> addSpendTime(String taskId, int minutes) async {
    await _taskRepository.updateSpendTime(taskId, minutes);
  }

  void startAddingPriority() {
    emit(state.copyWith(isAddingPriority: true));
  }

  void cancelAddingPriority() {
    emit(state.copyWith(isAddingPriority: false));
  }

  void startAddingTask() {
    emit(state.copyWith(isAddingTask: true));
  }

  void cancelAddingTask() {
    emit(state.copyWith(isAddingTask: false));
  }

  void startEditing(String taskId) {
    emit(state.copyWith(editingTaskId: taskId));
  }

  void cancelEditing() {
    emit(state.copyWith(editingTaskId: ''));
  }

  void toggleHistoryView() {
    emit(state.copyWith(showHistory: !state.showHistory));
  }

  @override
  Future<void> close() async {
    await _tasksSubscription?.cancel();
    return super.close();
  }
}

class TasksState {
  const TasksState({
    this.tasks = const [],
    this.isAddingPriority = false,
    this.isAddingTask = false,
    this.editingTaskId = '',
    this.showHistory = false,
  });

  final List<Task> tasks;
  final bool isAddingPriority;
  final bool isAddingTask;
  final String editingTaskId;
  final bool showHistory;

  List<Task> get pendingPriorities =>
      tasks.where((t) => t.isPriority && !t.isDone).toList();

  List<Task> get pendingTasks =>
      tasks.where((t) => !t.isPriority && !t.isDone).toList();

  List<Task> get completedTasks => tasks.where((t) => t.isDone).toList();

  List<Task> get completedPriorities =>
      tasks.where((t) => t.isPriority && t.isDone).toList();

  List<Task> get completedNonPriorityTasks =>
      tasks.where((t) => !t.isPriority && t.isDone).toList();

  List<Task> get allPending => tasks.where((t) => !t.isDone).toList();

  int get totalCount => tasks.length;
  int get pendingCount => tasks.where((t) => !t.isDone).length;
  int get completedCount => tasks.where((t) => t.isDone).length;

  static const Object _notSpecified = Object();

  TasksState copyWith({
    List<Task>? tasks,
    bool? isAddingPriority,
    bool? isAddingTask,
    Object? editingTaskId = _notSpecified,
    bool? showHistory,
  }) {
    return TasksState(
      tasks: tasks ?? this.tasks,
      isAddingPriority: isAddingPriority ?? this.isAddingPriority,
      isAddingTask: isAddingTask ?? this.isAddingTask,
      editingTaskId: identical(editingTaskId, _notSpecified)
          ? this.editingTaskId
          : editingTaskId as String,
      showHistory: showHistory ?? this.showHistory,
    );
  }
}
