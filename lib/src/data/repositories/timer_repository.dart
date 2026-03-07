import 'package:mindease_app/src/domain/repositories/timer_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TimerRepository implements TimerRepositoryBase {
  static const _prefsKey = 'timer_current_mode_index';
  final Future<SharedPreferences> _prefsFuture =
      SharedPreferences.getInstance();

  @override
  Future<int?> getCurrentModeIndex() async {
    final prefs = await _prefsFuture;
    return prefs.getInt(_prefsKey);
  }

  @override
  Future<void> setCurrentModeIndex(int index) async {
    final prefs = await _prefsFuture;
    await prefs.setInt(_prefsKey, index);
  }
}
