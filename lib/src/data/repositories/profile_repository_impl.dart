import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mindease_app/src/domain/entities/profile.dart';
import 'package:mindease_app/src/domain/repositories/profile_repository.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  ProfileRepositoryImpl({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> get _collection =>
      _firestore.collection('profiles');

  @override
  Future<Profile?> loadProfile(String userEmail) async {
    final doc = await _collection.doc(userEmail).get();
    if (!doc.exists || doc.data() == null) return null;
    return Profile.fromMap(doc.data()!);
  }

  @override
  Future<void> saveProfile(Profile profile) async {
    await _collection
        .doc(profile.userEmail)
        .set(profile.toMap(), SetOptions(merge: true));
  }

  @override
  Future<void> incrementFocusMinutes(String userEmail, int minutes) async {
    await _collection.doc(userEmail).set({
      'totalFocusMinutes': FieldValue.increment(minutes),
    }, SetOptions(merge: true));
  }

  @override
  Future<void> updateStreak(
    String userEmail,
    DateTime? lastCompletionDate,
  ) async {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    if (lastCompletionDate != null) {
      final lastDate = DateTime(
        lastCompletionDate.year,
        lastCompletionDate.month,
        lastCompletionDate.day,
      );
      if (lastDate == today) return;
    }

    await _collection.doc(userEmail).set({
      'strikeDays': FieldValue.increment(1),
      'lastCompletionDate': today.toIso8601String(),
    }, SetOptions(merge: true));
  }

  @override
  Stream<Profile?> profileStream(String userEmail) {
    return _collection.doc(userEmail).snapshots().map((doc) {
      if (!doc.exists || doc.data() == null) return null;
      return Profile.fromMap(doc.data()!);
    });
  }

  @override
  Future<void> incrementTotalTasks(String userEmail) async {
    await _collection.doc(userEmail).set({
      'totalTasks': FieldValue.increment(1),
    }, SetOptions(merge: true));
  }

  @override
  Future<void> completeMission(
    String userEmail,
    String missionId,
    DateTime? lastCompletionDate,
  ) async {
    await _collection.doc(userEmail).set({
      'totalMissions': FieldValue.increment(1),
      'completedMissions': FieldValue.arrayUnion([missionId]),
    }, SetOptions(merge: true));
    await updateStreak(userEmail, lastCompletionDate);
  }
}
