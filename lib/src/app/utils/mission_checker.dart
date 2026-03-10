import 'package:mindease_app/src/domain/entities/mission.dart';
import 'package:mindease_app/src/domain/entities/profile.dart';

/// Utility to check whether an action corresponds to a mission
/// and whether it should be completed.
class MissionChecker {
  const MissionChecker._();

  /// Returns `true` if [missionId] is a valid mission defined in [appMissions].
  static bool isMission(String missionId) {
    return appMissions.any(
      (s) => s.missions.any((m) => m.id == missionId),
    );
  }

  /// Returns `true` if [missionId] is a valid mission that has not been
  /// completed yet by the user.
  static bool shouldComplete(Profile profile, String missionId) {
    return isMission(missionId) &&
        !profile.completedMissions.contains(missionId);
  }

  /// Returns `true` if [records] contain a streak of at least [days]
  /// consecutive calendar days.
  static bool hasStreak(List<DateTime> records, int days) {
    if (records.length < days) return false;

    // Normalize to calendar days and remove duplicates.
    final uniqueDays = records
        .map((d) => DateTime(d.year, d.month, d.day))
        .toSet();

    if (uniqueDays.length < days) return false;

    for (final day in uniqueDays) {
      // Only start counting from the beginning of a potential streak.
      final previousDay = day.subtract(const Duration(days: 1));
      if (!uniqueDays.contains(previousDay)) {
        var current = day;
        var streak = 1;

        while (streak < days &&
            uniqueDays.contains(current.add(const Duration(days: 1)))) {
          current = current.add(const Duration(days: 1));
          streak++;
        }

        if (streak >= days) {
          return true;
        }
      }
    }

    return false;
  }
}
