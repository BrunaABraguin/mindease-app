import 'dart:convert';

import 'package:mindease_app/src/domain/entities/timer_entity.dart';
import 'package:mindease_app/src/domain/repositories/timer_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TimerRepository implements TimerRepositoryBase {
  static const _prefsTimerKey = 'timer_entity';
  final Future<SharedPreferences> _prefsFuture =
      SharedPreferences.getInstance();

  @override
  Future<void> saveTimerEntity(TimerEntity timer) async {
    final prefs = await _prefsFuture;
    final timerMap = {
      'focusTime': timer.focusTime,
      'breakTime': timer.breakTime,
      'longBreakTime': timer.longBreakTime,
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

      if (map['focusTime'] is! int ||
          map['breakTime'] is! int ||
          map['longBreakTime'] is! int ||
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
        focusTime: map['focusTime'] as int,
        breakTime: map['breakTime'] as int,
        longBreakTime: map['longBreakTime'] as int,
        currentCycle: map['currentCycle'] as int,
        totalCycles: map['totalCycles'] as int,
        remainingSeconds: remainingSecondsValue as int?,
        completedSessions: map['completedSessions'] as int,
        currentModeIndex: map['currentModeIndex'] as int,
      );
    } catch (_) {
      return null;
    }
  }
}
