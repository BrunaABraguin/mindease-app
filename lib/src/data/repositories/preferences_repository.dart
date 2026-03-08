import 'dart:convert';

import 'package:mindease_app/src/app/utils/app_constants.dart';
import 'package:mindease_app/src/domain/entities/preferences.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PreferencesRepository {
  static const _prefsKey = AppConstants.kPrefsKeyUserPreferences;

  Future<void> savePreferences(Preferences preferences) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_prefsKey, jsonEncode(preferences.toMap()));
  }

  Future<Preferences> loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_prefsKey);
    if (jsonString == null) {
      return Preferences.defaultValues();
    }
    try {
      final map = jsonDecode(jsonString) as Map<String, dynamic>;
      return Preferences.fromMap(map);
    } on Exception {
      return Preferences.defaultValues();
    }
  }
}
