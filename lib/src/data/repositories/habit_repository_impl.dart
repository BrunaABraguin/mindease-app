import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mindease_app/src/domain/entities/habit.dart';
import 'package:mindease_app/src/domain/repositories/habit_repository.dart';

class HabitRepositoryImpl implements HabitRepository {
  HabitRepositoryImpl({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> get _collection =>
      _firestore.collection('habits');

  @override
  Future<List<Habit>> loadHabits(String userEmail) async {
    final snapshot =
        await _collection.where('userEmail', isEqualTo: userEmail).get();
    return snapshot.docs
        .map((doc) => Habit.fromMap(doc.data(), id: doc.id))
        .toList();
  }

  @override
  Future<Habit> addHabit(Habit habit) async {
    final docRef = await _collection.add(habit.toMap());
    return habit.copyWith(id: docRef.id);
  }

  @override
  Future<void> updateHabit(Habit habit) async {
    await _collection.doc(habit.id).update(habit.toMap());
  }

  @override
  Future<void> deleteHabit(String habitId) async {
    await _collection.doc(habitId).delete();
  }

  @override
  Future<void> toggleRecord(String habitId, DateTime date) async {
    final doc = await _collection.doc(habitId).get();
    if (!doc.exists || doc.data() == null) return;

    final habit = Habit.fromMap(doc.data()!, id: doc.id);
    final day = DateTime(date.year, date.month, date.day);

    final hasRecord = habit.hasRecordOn(day);
    List<DateTime> updatedRecords;

    if (hasRecord) {
      updatedRecords = habit.records
          .where((r) => DateTime(r.year, r.month, r.day) != day)
          .toList();
    } else {
      updatedRecords = [...habit.records, day];
    }

    await _collection.doc(habitId).update({
      'records': updatedRecords.map((d) => d.toIso8601String()).toList(),
    });
  }

  @override
  Stream<List<Habit>> habitsStream(String userEmail) {
    return _collection
        .where('userEmail', isEqualTo: userEmail)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Habit.fromMap(doc.data(), id: doc.id))
            .toList());
  }
}
