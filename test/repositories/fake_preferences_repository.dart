import 'package:mindease_app/src/data/repositories/preferences_repository.dart';
import 'package:mindease_app/src/domain/entities/preferences.dart';

class FakePreferencesRepository extends PreferencesRepository {
  @override
  Future<void> savePreferences(Preferences preferences) async {}

  @override
  Future<Preferences> loadPreferences() async {
    return Preferences.defaultValues();
  }
}
