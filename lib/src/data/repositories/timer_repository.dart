import 'dart:convert';

import 'package:mindease_app/src/domain/entities/timer_entity.dart';
import 'package:mindease_app/src/domain/repositories/timer_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TimerRepository implements TimerRepositoryBase {
  @override
  Future<void> clearTimerEntity() async {
    final prefs = await _prefsFuture;
    await prefs.remove(_prefsTimerKey);
  }

  static const _prefsTimerKey = 'timer_entity';
  final Future<SharedPreferences> _prefsFuture =
      SharedPreferences.getInstance();

  @override
  Future<void> saveTimerEntity(TimerEntity timer) async {
    final prefs = await _prefsFuture;
    final timerMap = {
      'durations': {
        'focus': timer.durations.focus,
        'shortBreak': timer.durations.shortBreak,
        'longBreak': timer.durations.longBreak,
      },
      'currentCycle': timer.currentCycle,
      'totalCycles': timer.totalCycles,
      'remainingSeconds': timer.remainingSeconds,
      'completedSessions': timer.completedSessions,
      'currentModeIndex': timer.currentModeIndex,
    };
    await prefs.setString(_prefsTimerKey, jsonEncode(timerMap));
  }

  @override
  Future<TimerEntity?> loadTimerEntity() async {
    final prefs = await _prefsFuture;
    final jsonString = prefs.getString(_prefsTimerKey);
    if (jsonString == null) return null;

    try {
      final dynamic decoded = jsonDecode(jsonString);
      if (decoded is! Map<String, dynamic>) {
        return null;
      }
      final map = decoded;
      final durationsMap = map['durations'] as Map<String, dynamic>?;
      if (durationsMap == null ||
          durationsMap['focus'] is! int ||
          durationsMap['shortBreak'] is! int ||
          durationsMap['longBreak'] is! int ||
          map['currentCycle'] is! int ||
          map['totalCycles'] is! int ||
          map['completedSessions'] is! int ||
          map['currentModeIndex'] is! int) {
        return null;
      }

      final remainingSecondsValue = map['remainingSeconds'];
      if (remainingSecondsValue != null && remainingSecondsValue is! int) {
        return null;
      }
      return TimerEntity(
        durations: TimerDurations(
          focus: durationsMap['focus'] as int,
          shortBreak: durationsMap['shortBreak'] as int,
          longBreak: durationsMap['longBreak'] as int,
        ),
        currentCycle: map['currentCycle'] as int,
        totalCycles: map['totalCycles'] as int,
        remainingSeconds: remainingSecondsValue as int?,
        completedSessions: map['completedSessions'] as int,
        currentModeIndex: map['currentModeIndex'] as int,
      );
    } on Exception {
      return null;
    }
  }
}
