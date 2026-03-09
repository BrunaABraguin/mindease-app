import 'package:mindease_app/src/data/repositories/preferences_repository.dart';
import 'package:mindease_app/src/domain/entities/preferences.dart';

class MockPreferencesRepository extends PreferencesRepository {
  Preferences? _saved;
  @override
  Future<void> savePreferences(Preferences preferences) async {
    _saved = preferences;
  }

  @override
  Future<Preferences> loadPreferences() async {
    return _saved ?? Preferences.defaultValues();
  }
}
