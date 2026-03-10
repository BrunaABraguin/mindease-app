import 'package:mindease_app/src/domain/entities/task.dart';

abstract class TaskRepository {
  Future<List<Task>> loadTasks(String userEmail);
  Future<Task> addTask(Task task);
  Future<void> updateTask(Task task);
  Future<void> deleteTask(String taskId);
  Future<void> completeTask(String taskId);
  Future<void> updateSpendTime(String taskId, int minutes);
  Stream<List<Task>> tasksStream(String userEmail);
}
