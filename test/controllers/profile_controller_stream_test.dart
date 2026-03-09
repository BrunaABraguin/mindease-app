import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:mindease_app/src/app/pages/profile/profile_controller.dart';
import 'package:mindease_app/src/domain/entities/auth_user.dart';
import 'package:mindease_app/src/domain/entities/profile.dart';
import 'package:mindease_app/src/domain/repositories/profile_repository.dart';

import '../mocks/configurable_auth.dart';
import '../mocks/mock_preferences_repository.dart';

/// A profile repository that exposes a StreamController for testing
/// stream behavior including errors.
class StreamableProfileRepository implements ProfileRepository {
  final Map<String, StreamController<Profile?>> _controllers = {};
  int incrementCalls = 0;
  int updateStreakCalls = 0;

  StreamController<Profile?> controllerFor(String email) {
    return _controllers.putIfAbsent(
      email,
      () => StreamController<Profile?>.broadcast(),
    );
  }

  @override
  Stream<Profile?> profileStream(String userEmail) {
    return controllerFor(userEmail).stream;
  }

  @override
  Future<Profile?> loadProfile(String userEmail) async => null;

  @override
  Future<void> saveProfile(Profile profile) async {}

  @override
  Future<void> incrementFocusMinutes(String userEmail, int minutes) async {
    incrementCalls++;
  }

  @override
  Future<void> updateStreak(
    String userEmail,
    DateTime? lastCompletionDate,
  ) async {
    updateStreakCalls++;
  }

  void dispose() {
    for (final c in _controllers.values) {
      c.close();
    }
  }
}

void main() {
  group('ProfileCubit auth and profile stream', () {
    late ConfigurableAuthRepository authRepo;
    late MockPreferencesRepository prefsRepo;
    late StreamableProfileRepository profileRepo;
    late ProfileCubit cubit;

    setUp(() {
      authRepo = ConfigurableAuthRepository();
      prefsRepo = MockPreferencesRepository();
      profileRepo = StreamableProfileRepository();
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
      profileRepo.dispose();
    });

    test('emits profile when auth user emits with email', () async {
      const user = AuthUser(
        uid: '1',
        email: 'test@test.com',
        displayName: 'Test',
      );
      authRepo.emitUser(user);
      await Future.delayed(const Duration(milliseconds: 50));

      // Now emit a profile via the stream
      profileRepo.controllerFor('test@test.com').add(
        const Profile(userEmail: 'test@test.com', strikeDays: 7),
      );
      await Future.delayed(const Duration(milliseconds: 50));

      expect(cubit.state.profile, isNotNull);
      expect(cubit.state.profile!.strikeDays, 7);
    });

    test('emits profile with default when stream emits null', () async {
      const user = AuthUser(uid: '1', email: 'null@test.com');
      authRepo.emitUser(user);
      await Future.delayed(const Duration(milliseconds: 50));

      profileRepo.controllerFor('null@test.com').add(null);
      await Future.delayed(const Duration(milliseconds: 50));

      expect(cubit.state.profile, isNotNull);
      expect(cubit.state.profile!.userEmail, 'null@test.com');
    });

    test('clears profile when user email is null', () async {
      // First set a user
      authRepo.userToReturn = const AuthUser(
        uid: '1',
        email: 'test@test.com',
      );
      await cubit.signInWithGoogle();
      await Future.delayed(const Duration(milliseconds: 50));

      // Now emit user without email (null email triggers profile clear)
      authRepo.emitUser(const AuthUser(uid: '2'));
      await Future.delayed(const Duration(milliseconds: 50));

      expect(cubit.state.profile, isNull);
    });

    test('handles stream error gracefully', () async {
      const user = AuthUser(uid: '1', email: 'error@test.com');
      authRepo.emitUser(user);
      await Future.delayed(const Duration(milliseconds: 50));

      // Emit an error on the profile stream
      profileRepo.controllerFor('error@test.com').addError(
        Exception('Firestore error'),
      );
      await Future.delayed(const Duration(milliseconds: 50));

      // Should not crash - cubit should still be open
      expect(cubit.isClosed, isFalse);
    });

    test('addFocusMinutes calls repository methods', () async {
      final stateWithProfile = cubit.state.copyWith(
        profile: const Profile(userEmail: 'focus@test.com'),
      );
      cubit.emit(stateWithProfile);

      await cubit.addFocusMinutes(25);

      expect(profileRepo.incrementCalls, 1);
      expect(profileRepo.updateStreakCalls, 1);
    });

    test('addFocusMinutes does nothing when profile is null', () async {
      await cubit.addFocusMinutes(25);
      expect(profileRepo.incrementCalls, 0);
      expect(profileRepo.updateStreakCalls, 0);
    });
  });
}
