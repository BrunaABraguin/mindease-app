import 'package:mindease_app/src/domain/entities/profile.dart';

abstract class ProfileRepository {
  Future<Profile?> loadProfile(String userEmail);
  Future<void> saveProfile(Profile profile);
  Future<void> incrementFocusMinutes(String userEmail, int minutes);
  Future<void> updateStreak(String userEmail, DateTime? lastCompletionDate);
  Future<void> completeMission(
    String userEmail,
    String missionId,
    DateTime? lastCompletionDate,
  );
  Future<void> incrementTotalTasks(String userEmail);
  Stream<Profile?> profileStream(String userEmail);
}
