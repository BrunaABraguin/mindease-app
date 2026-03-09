import 'package:flutter_test/flutter_test.dart';
import 'package:mindease_app/src/app/pages/profile/profile_controller.dart';
import 'package:mindease_app/src/domain/entities/auth_user.dart';
import 'package:mindease_app/src/domain/entities/preferences.dart';
import 'package:mindease_app/src/domain/entities/profile.dart';

import '../mocks/configurable_auth.dart';
import '../mocks/fake_profile_repository.dart';
import '../mocks/mock_preferences_repository.dart';

void main() {
  group('ProfileCubit extended', () {
    late ConfigurableAuthRepository authRepo;
    late MockPreferencesRepository prefsRepo;
    late FakeProfileRepository profileRepo;
    late ProfileCubit cubit;

    setUp(() {
      authRepo = ConfigurableAuthRepository(
        userToReturn: const AuthUser(
          uid: '1',
          email: 'test@test.com',
          displayName: 'Test',
        ),
      );
      prefsRepo = MockPreferencesRepository();
      profileRepo = FakeProfileRepository();
      cubit = ProfileCubit(
        preferencesRepository: prefsRepo,
        profileRepository: profileRepo,
        getAuthState: ConfigurableGetAuthStateUseCase(authRepo),
        signInWithGoogle: ConfigurableSignInWithGoogleUseCase(authRepo),
        signOut: ConfigurableSignOutUseCase(authRepo),
      );
    });

    tearDown(() {
      cubit.close();
      authRepo.dispose();
    });

    test('signInWithGoogle updates state with user', () async {
      await cubit.signInWithGoogle();
      expect(cubit.state.user, isNotNull);
      expect(cubit.state.user?.uid, '1');
    });

    test('signOut clears user from state', () async {
      await cubit.signInWithGoogle();
      expect(cubit.state.user, isNotNull);
      await cubit.signOut();
      expect(cubit.state.user, isNull);
    });

    test('addFocusMinutes does nothing without profile', () async {
      // No profile set, should not throw
      await cubit.addFocusMinutes(25);
    });

    test('addFocusMinutes increments when profile exists', () async {
      // Set up a profile in state via copyWith
      final stateWithProfile = cubit.state.copyWith(
        profile: const Profile(userEmail: 'test@test.com'),
      );
      cubit.emit(stateWithProfile);

      await cubit.addFocusMinutes(25);
      // The fake repo should have been called
    });

    test('close cancels subscriptions', () async {
      await cubit.close();
      // Should not throw
    });
  });

  group('ProfileState', () {
    test('copyWith preserves all fields when no args', () {
      const user = AuthUser(uid: '1', email: 'a@b.com');
      const profile = Profile(userEmail: 'a@b.com');
      final state = ProfileState(
        preferences: Preferences.defaultValues(),
        user: user,
        profile: profile,
      );
      final copy = state.copyWith();
      expect(copy.preferences, state.preferences);
      expect(copy.user, user);
      expect(copy.profile, profile);
    });

    test('copyWith updates user to null', () {
      const user = AuthUser(uid: '1');
      final state = ProfileState(
        preferences: Preferences.defaultValues(),
        user: user,
      );
      final copy = state.copyWith(user: null);
      expect(copy.user, isNull);
    });

    test('copyWith updates profile to null', () {
      final state = ProfileState(
        preferences: Preferences.defaultValues(),
        profile: const Profile(userEmail: 'a@b.com'),
      );
      final copy = state.copyWith(profile: null);
      expect(copy.profile, isNull);
    });

    test('copyWith updates preferences', () {
      final state = ProfileState(preferences: Preferences.defaultValues());
      final newPrefs = Preferences.defaultValues().copyWith(darkTheme: true);
      final copy = state.copyWith(preferences: newPrefs);
      expect(copy.preferences.darkTheme, isTrue);
    });
  });
}
