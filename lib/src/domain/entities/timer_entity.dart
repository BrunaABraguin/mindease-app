class TimerDurations {
  const TimerDurations({
    required this.focus,
    required this.shortBreak,
    required this.longBreak,
  });
  final int focus;
  final int shortBreak;
  final int longBreak;

  TimerDurations copyWith({int? focus, int? shortBreak, int? longBreak}) {
    return TimerDurations(
      focus: focus ?? this.focus,
      shortBreak: shortBreak ?? this.shortBreak,
      longBreak: longBreak ?? this.longBreak,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TimerDurations &&
          runtimeType == other.runtimeType &&
          focus == other.focus &&
          shortBreak == other.shortBreak &&
          longBreak == other.longBreak;

  @override
  int get hashCode => focus.hashCode ^ shortBreak.hashCode ^ longBreak.hashCode;

  @override
  String toString() =>
      'TimerDurations(focus: $focus, shortBreak: $shortBreak, longBreak: $longBreak)';
}

class TimerEntity {
  TimerEntity({
    required this.durations,
    required this.currentCycle,
    required this.totalCycles,
    this.remainingSeconds,
    required this.completedSessions,
    required this.currentModeIndex,
    this.isRunning = false,
  });

  final TimerDurations durations;
  final int currentCycle;
  final int totalCycles;
  final int? remainingSeconds;
  final int completedSessions;
  final int currentModeIndex;
  final bool isRunning;

  TimerEntity copyWith({
    TimerDurations? durations,
    int? currentCycle,
    int? totalCycles,
    Object? remainingSeconds = _noValue,
    int? completedSessions,
    int? currentModeIndex,
    bool? isRunning,
  }) {
    final int effectiveCurrentCycle = currentCycle ?? this.currentCycle;
    return TimerEntity(
      durations: durations ?? this.durations,
      currentCycle: effectiveCurrentCycle < 0 ? 0 : effectiveCurrentCycle,
      totalCycles: totalCycles ?? this.totalCycles,
      remainingSeconds: remainingSeconds == _noValue
          ? this.remainingSeconds
          : remainingSeconds as int?,
      completedSessions: completedSessions ?? this.completedSessions,
      currentModeIndex: currentModeIndex ?? this.currentModeIndex,
      isRunning: isRunning ?? this.isRunning,
    );
  }

  static const Object _noValue = Object();

  @override
  String toString() {
    return 'TimerEntity(durations: $durations, currentCycle: $currentCycle, totalCycles: $totalCycles, remainingSeconds: $remainingSeconds, completedSessions: $completedSessions, currentModeIndex: $currentModeIndex, isRunning: $isRunning)';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TimerEntity &&
          runtimeType == other.runtimeType &&
          durations == other.durations &&
          currentCycle == other.currentCycle &&
          totalCycles == other.totalCycles &&
          remainingSeconds == other.remainingSeconds &&
          completedSessions == other.completedSessions &&
          currentModeIndex == other.currentModeIndex &&
          isRunning == other.isRunning;

  @override
  int get hashCode =>
      durations.hashCode ^
      currentCycle.hashCode ^
      totalCycles.hashCode ^
      (remainingSeconds?.hashCode ?? 0) ^
      completedSessions.hashCode ^
      currentModeIndex.hashCode ^
      isRunning.hashCode;
}
