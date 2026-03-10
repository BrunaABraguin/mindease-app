class TimerDurations {
  const TimerDurations({
    required this.focus,
    required this.shortBreak,
    required this.longBreak,
  });

  static const int defaultFocus = 25 * Duration.secondsPerMinute;
  static const int defaultShortBreak = 5 * Duration.secondsPerMinute;
  static const int defaultLongBreak = 15 * Duration.secondsPerMinute;

  static const TimerDurations defaults = TimerDurations(
    focus: defaultFocus,
    shortBreak: defaultShortBreak,
    longBreak: defaultLongBreak,
  );

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

class TimerStatus {
  const TimerStatus({this.isRunning = false, this.isLoading = false});

  final bool isRunning;
  final bool isLoading;

  TimerStatus copyWith({bool? isRunning, bool? isLoading}) {
    return TimerStatus(
      isRunning: isRunning ?? this.isRunning,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TimerStatus &&
          runtimeType == other.runtimeType &&
          isRunning == other.isRunning &&
          isLoading == other.isLoading;

  @override
  int get hashCode => isRunning.hashCode ^ isLoading.hashCode;

  @override
  String toString() =>
      'TimerStatus(isRunning: $isRunning, isLoading: $isLoading)';
}

class TimerEntity {
  TimerEntity({
    required this.durations,
    required this.currentCycle,
    required this.totalCycles,
    this.remainingSeconds,
    required this.completedSessions,
    required this.currentModeIndex,
    this.status = const TimerStatus(),
  });

  final TimerDurations durations;
  final int currentCycle;
  final int totalCycles;
  final int? remainingSeconds;
  final int completedSessions;
  final int currentModeIndex;
  final TimerStatus status;

  bool get isRunning => status.isRunning;
  bool get isLoading => status.isLoading;

  TimerEntity copyWith({
    TimerDurations? durations,
    int? currentCycle,
    int? totalCycles,
    Object? remainingSeconds = _noValue,
    int? completedSessions,
    int? currentModeIndex,
    bool? isRunning,
    bool? isLoading,
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
      status: TimerStatus(
        isRunning: isRunning ?? this.isRunning,
        isLoading: isLoading ?? this.isLoading,
      ),
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
          status == other.status;

  @override
  int get hashCode =>
      durations.hashCode ^
      currentCycle.hashCode ^
      totalCycles.hashCode ^
      (remainingSeconds?.hashCode ?? 0) ^
      completedSessions.hashCode ^
      currentModeIndex.hashCode ^
      status.hashCode;
}
