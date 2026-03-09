class Profile {
  const Profile({
    required this.userEmail,
    this.strikeDays = 0,
    this.totalFocusMinutes = 0,
    this.totalTasks = 0,
    this.totalMissions = 0,
    this.completedMissions = const [],
    this.lastCompletionDate,
  });

  factory Profile.fromMap(Map<String, dynamic> map) {
    return Profile(
      userEmail: map['userEmail'] as String? ?? '',
      strikeDays: map['strikeDays'] as int? ?? 0,
      totalFocusMinutes: map['totalFocusMinutes'] as int? ?? 0,
      totalTasks: map['totalTasks'] as int? ?? 0,
      totalMissions: map['totalMissions'] as int? ?? 0,
      completedMissions:
          (map['completedMissions'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      lastCompletionDate: map['lastCompletionDate'] != null
          ? DateTime.tryParse(map['lastCompletionDate'] as String)
          : null,
    );
  }

  final String userEmail;
  final int strikeDays;
  final int totalFocusMinutes;
  final int totalTasks;
  final int totalMissions;
  final List<String> completedMissions;
  final DateTime? lastCompletionDate;

  Map<String, dynamic> toMap() {
    return {
      'userEmail': userEmail,
      'strikeDays': strikeDays,
      'totalFocusMinutes': totalFocusMinutes,
      'totalTasks': totalTasks,
      'totalMissions': totalMissions,
      'completedMissions': completedMissions,
      'lastCompletionDate': lastCompletionDate?.toIso8601String(),
    };
  }

  Profile copyWith({
    String? userEmail,
    int? strikeDays,
    int? totalFocusMinutes,
    int? totalTasks,
    int? totalMissions,
    List<String>? completedMissions,
    DateTime? lastCompletionDate,
  }) {
    return Profile(
      userEmail: userEmail ?? this.userEmail,
      strikeDays: strikeDays ?? this.strikeDays,
      totalFocusMinutes: totalFocusMinutes ?? this.totalFocusMinutes,
      totalTasks: totalTasks ?? this.totalTasks,
      totalMissions: totalMissions ?? this.totalMissions,
      completedMissions: completedMissions ?? this.completedMissions,
      lastCompletionDate: lastCompletionDate ?? this.lastCompletionDate,
    );
  }

  String get formattedFocusTime {
    final hours = totalFocusMinutes ~/ 60;
    final minutes = totalFocusMinutes % 60;
    if (hours > 0 && minutes > 0) return '${hours}h ${minutes}m';
    if (hours > 0) return '${hours}h';
    return '${minutes}m';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Profile &&
          runtimeType == other.runtimeType &&
          userEmail == other.userEmail &&
          strikeDays == other.strikeDays &&
          totalFocusMinutes == other.totalFocusMinutes &&
          totalTasks == other.totalTasks &&
          totalMissions == other.totalMissions &&
          completedMissions.length == other.completedMissions.length &&
          lastCompletionDate == other.lastCompletionDate;

  @override
  int get hashCode =>
      userEmail.hashCode ^
      strikeDays.hashCode ^
      totalFocusMinutes.hashCode ^
      totalTasks.hashCode ^
      totalMissions.hashCode ^
      completedMissions.hashCode ^
      lastCompletionDate.hashCode;
}
