import 'package:flutter_test/flutter_test.dart';
import 'package:mindease_app/src/app/pages/profile/profile_controller.dart';
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

void main() {
  group('ProfileCubit', () {
    late MockPreferencesRepository repo;
    late ProfileCubit cubit;
    setUp(() {
      repo = MockPreferencesRepository();
      cubit = ProfileCubit(preferencesRepository: repo);
    });

    test('initial state loads preferences', () async {
      await Future.delayed(Duration.zero); // allow async init
      expect(cubit.state.preferences, Preferences.defaultValues());
    });

    test('setDarkTheme updates preferences', () async {
      await cubit.setDarkTheme(true);
      expect(cubit.state.preferences.darkTheme, true);
    });

    test('setShowHelpIcon updates preferences', () async {
      await cubit.setShowHelpIcon(false);
      expect(cubit.state.preferences.showHelpIcons, false);
    });

    test('setShowAnimations updates preferences', () async {
      await cubit.setShowAnimations(false);
      expect(cubit.state.preferences.showAnimations, false);
    });
  });
}
