import 'package:flutter_test/flutter_test.dart';
import 'package:mindease_app/src/data/repositories/preferences_repository.dart';
import 'package:mindease_app/src/domain/entities/preferences.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  group('PreferencesRepository', () {
    late PreferencesRepository repo;
    setUp(() {
      repo = PreferencesRepository();
      SharedPreferences.setMockInitialValues({});
    });

    test('save and load preferences', () async {
      final prefs = Preferences(
        showHelpIcons: false,
        showAnimations: true,
        darkTheme: true,
      );
      await repo.savePreferences(prefs);
      final loaded = await repo.loadPreferences();
      expect(loaded.showHelpIcons, false);
      expect(loaded.showAnimations, true);
      expect(loaded.darkTheme, true);
    });

    test('loadPreferences returns default if not set', () async {
      final loaded = await repo.loadPreferences();
      expect(loaded, Preferences.defaultValues());
    });
  });
}
