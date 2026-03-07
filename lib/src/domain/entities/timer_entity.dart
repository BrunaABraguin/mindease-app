class TimerEntity {
  TimerEntity({
    required this.focusTime,
    required this.breakTime,
    required this.longBreakTime,
    required this.currentCycle,
    required this.totalCycles,
    this.remainingSeconds,
    required this.completedSessions,
    required this.currentModeIndex,
  });

  final int focusTime;
  final int breakTime;
  final int longBreakTime;
  final int currentCycle;
  final int totalCycles;
  final int? remainingSeconds;
  final int completedSessions;
  final int currentModeIndex;

  TimerEntity copyWith({
    int? focusTime,
    int? breakTime,
    int? longBreakTime,
    int? currentCycle,
    int? totalCycles,
    Object? remainingSeconds = _noValue,
    int? completedSessions,
    int? currentModeIndex,
  }) {
    return TimerEntity(
      focusTime: focusTime ?? this.focusTime,
      breakTime: breakTime ?? this.breakTime,
      longBreakTime: longBreakTime ?? this.longBreakTime,
      currentCycle: currentCycle ?? this.currentCycle,
      totalCycles: totalCycles ?? this.totalCycles,
      remainingSeconds: remainingSeconds == _noValue ? this.remainingSeconds : remainingSeconds as int?,
      completedSessions: completedSessions ?? this.completedSessions,
      currentModeIndex: currentModeIndex ?? this.currentModeIndex,
    );
  }

  static const Object _noValue = Object();

  @override
  String toString() {
    return 'TimerEntity(focusTime: $focusTime, breakTime: $breakTime, longBreakTime: $longBreakTime, currentCycle: $currentCycle, totalCycles: $totalCycles, remainingSeconds: $remainingSeconds, completedSessions: $completedSessions, currentModeIndex: $currentModeIndex)';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TimerEntity &&
          runtimeType == other.runtimeType &&
          focusTime == other.focusTime &&
          breakTime == other.breakTime &&
          longBreakTime == other.longBreakTime &&
          currentCycle == other.currentCycle &&
          totalCycles == other.totalCycles &&
          remainingSeconds == other.remainingSeconds &&
          completedSessions == other.completedSessions &&
          currentModeIndex == other.currentModeIndex;

  @override
  int get hashCode =>
      focusTime.hashCode ^
      breakTime.hashCode ^
      longBreakTime.hashCode ^
      currentCycle.hashCode ^
      totalCycles.hashCode ^
      (remainingSeconds?.hashCode ?? 0) ^
      completedSessions.hashCode ^
      currentModeIndex.hashCode;
}
