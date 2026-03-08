import 'package:flutter_test/flutter_test.dart';
import 'package:mindease_app/src/domain/entities/preferences.dart';

void main() {
  group('Preferences', () {
    test('fromMap and toMap', () {
      final map = {
        'showHelpIcons': false,
        'showAnimations': false,
        'darkTheme': true,
      };
      final prefs = Preferences.fromMap(map);
      expect(prefs.showHelpIcons, false);
      expect(prefs.showAnimations, false);
      expect(prefs.darkTheme, true);
      expect(prefs.toMap(), map);
    });

    test('defaultValues', () {
      final prefs = Preferences.defaultValues();
      expect(prefs.showHelpIcons, true);
      expect(prefs.showAnimations, true);
      expect(prefs.darkTheme, false);
    });

    test('copyWith', () {
      final prefs = Preferences.defaultValues();
      final updated = prefs.copyWith(showHelpIcons: false);
      expect(updated.showHelpIcons, false);
      expect(updated.showAnimations, true);
      expect(updated.darkTheme, false);
    });
  });
}
