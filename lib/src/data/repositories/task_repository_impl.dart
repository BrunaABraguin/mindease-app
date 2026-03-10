import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mindease_app/src/domain/entities/task.dart';
import 'package:mindease_app/src/domain/repositories/task_repository.dart';

class TaskRepositoryImpl implements TaskRepository {
  TaskRepositoryImpl({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> get _collection =>
      _firestore.collection('tasks');

  @override
  Future<List<Task>> loadTasks(String userEmail) async {
    final snapshot = await _collection
        .where('userEmail', isEqualTo: userEmail)
        .get();
    return snapshot.docs
        .map((doc) => Task.fromMap(doc.data(), id: doc.id))
        .toList();
  }

  @override
  Future<Task> addTask(Task task) async {
    final docRef = await _collection.add(task.toMap());
    return task.copyWith(id: docRef.id);
  }

  @override
  Future<void> updateTask(Task task) async {
    await _collection.doc(task.id).update(task.toMap());
  }

  @override
  Future<void> deleteTask(String taskId) async {
    await _collection.doc(taskId).delete();
  }

  @override
  Future<void> completeTask(String taskId) async {
    await _collection.doc(taskId).update({
      'isDone': true,
      'completedAt': DateTime.now().toIso8601String(),
    });
  }

  @override
  Future<void> updateSpendTime(String taskId, int minutes) async {
    await _collection.doc(taskId).update({
      'spendTime': FieldValue.increment(minutes),
    });
  }

  @override
  Stream<List<Task>> tasksStream(String userEmail) {
    return _collection
        .where('userEmail', isEqualTo: userEmail)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => Task.fromMap(doc.data(), id: doc.id))
              .toList(),
        );
  }
}
