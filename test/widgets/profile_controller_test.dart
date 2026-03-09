import 'package:flutter_test/flutter_test.dart';
import 'package:mindease_app/src/app/pages/profile/profile_controller.dart';
import 'package:mindease_app/src/domain/entities/preferences.dart';

import '../mocks/fake_auth_usecases.dart';
import '../mocks/fake_profile_repository.dart';
import '../mocks/mock_preferences_repository.dart';

void main() {
  group('ProfileCubit', () {
    late MockPreferencesRepository repo;
    late ProfileCubit cubit;
    setUp(() {
      repo = MockPreferencesRepository();
      cubit = ProfileCubit(
        preferencesRepository: repo,
        profileRepository: FakeProfileRepository(),
        getAuthState: FakeGetAuthStateUseCase(),
        signInWithGoogle: FakeSignInWithGoogleUseCase(),
        signOut: FakeSignOutUseCase(),
      );
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
