import 'package:mindease_app/src/domain/entities/profile.dart';
import 'package:mindease_app/src/domain/repositories/profile_repository.dart';

class FakeProfileRepository implements ProfileRepository {
  Profile? _profile;

  @override
  Future<Profile?> loadProfile(String userEmail) async => _profile;

  @override
  Future<void> saveProfile(Profile profile) async {
    _profile = profile;
  }

  @override
  Future<void> incrementFocusMinutes(String userEmail, int minutes) async {
    final current = _profile ?? Profile(userEmail: userEmail);
    _profile = current.copyWith(
      totalFocusMinutes: current.totalFocusMinutes + minutes,
    );
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

    final current = _profile ?? Profile(userEmail: userEmail);
    _profile = current.copyWith(
      strikeDays: current.strikeDays + 1,
      lastCompletionDate: today,
    );
  }

  @override
  Stream<Profile?> profileStream(String userEmail) {
    return Stream.value(_profile);
  }

  @override
  Future<void> completeMission(
    String userEmail,
    String missionId,
    DateTime? lastCompletionDate,
  ) async {
    final current = _profile ?? Profile(userEmail: userEmail);
    _profile = current.copyWith(
      totalMissions: current.totalMissions + 1,
      completedMissions: [...current.completedMissions, missionId],
    );
    await updateStreak(userEmail, lastCompletionDate);
  }
}
