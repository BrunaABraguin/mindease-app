import 'dart:async';
import 'dart:developer' as developer;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mindease_app/src/data/repositories/preferences_repository.dart';
import 'package:mindease_app/src/domain/entities/auth_user.dart';
import 'package:mindease_app/src/domain/entities/preferences.dart';
import 'package:mindease_app/src/domain/entities/profile.dart';
import 'package:mindease_app/src/domain/repositories/profile_repository.dart';
import 'package:mindease_app/src/domain/usecases/auth/get_auth_state_usecase.dart';
import 'package:mindease_app/src/domain/usecases/auth/sign_in_with_google_usecase.dart';
import 'package:mindease_app/src/domain/usecases/auth/sign_out_usecase.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit({
    required PreferencesRepository preferencesRepository,
    required ProfileRepository profileRepository,
    required GetAuthStateUseCase getAuthState,
    required SignInWithGoogleUseCase signInWithGoogle,
    required SignOutUseCase signOut,
  }) : _repo = preferencesRepository,
       _profileRepo = profileRepository,
       _getAuthState = getAuthState,
       _signInWithGoogle = signInWithGoogle,
       _signOut = signOut,
       super(ProfileState(preferences: Preferences.defaultValues())) {
    _loadPreferences();
    _listenAuth();
  }
  final PreferencesRepository _repo;
  final ProfileRepository _profileRepo;
  final GetAuthStateUseCase _getAuthState;
  final SignInWithGoogleUseCase _signInWithGoogle;
  final SignOutUseCase _signOut;

  StreamSubscription<AuthUser?>? _authSubscription;
  StreamSubscription<Profile?>? _profileSubscription;

  Future<void> _listenAuth() async {
    _getAuthState.buildUseCaseStream(null).then((stream) {
      _authSubscription = stream.listen((user) {
        emit(state.copyWith(user: user));
        _listenProfile(user?.email);
      });
    });
  }

  void _listenProfile(String? email) {
    _profileSubscription?.cancel();
    if (email == null) {
      emit(state.copyWith(profile: null));
      return;
    }
    _profileSubscription = _profileRepo
        .profileStream(email)
        .listen(
          (profile) {
            emit(state.copyWith(profile: profile ?? Profile(userEmail: email)));
          },
          onError: (error, stackTrace) {
            // Handle or log stream errors to avoid silent failures.
            developer.log(
              'Error in profileStream for $email: $error',
              name: 'ProfileCubit',
              error: error,
              stackTrace: stackTrace,
            );
          },
        );
  }

  Future<void> signInWithGoogle() async {
    final user = await _signInWithGoogle.buildUseCaseFuture(null);
    emit(state.copyWith(user: user));
  }

  Future<void> signOut() async {
    await _signOut.buildUseCaseFuture(null);
    emit(state.copyWith(user: null));
  }

  Future<void> _loadPreferences() async {
    final loaded = await _repo.loadPreferences();
    emit(state.copyWith(preferences: loaded));
  }

  Future<void> setDarkTheme(bool value) async {
    final updated = state.preferences.copyWith(darkTheme: value);
    await _repo.savePreferences(updated);
    emit(state.copyWith(preferences: updated));
  }

  Future<void> setShowHelpIcon(bool value) async {
    final updated = state.preferences.copyWith(showHelpIcons: value);
    await _repo.savePreferences(updated);
    emit(state.copyWith(preferences: updated));
  }

  Future<void> setShowAnimations(bool value) async {
    final updated = state.preferences.copyWith(showAnimations: value);
    await _repo.savePreferences(updated);
    emit(state.copyWith(preferences: updated));
  }

  Future<void> addFocusMinutes(int minutes) async {
    final profile = state.profile;
    if (profile == null) return;
    await _profileRepo.incrementFocusMinutes(profile.userEmail, minutes);
    await _profileRepo.updateStreak(
      profile.userEmail,
      profile.lastCompletionDate,
    );
  }

  @override
  Future<void> close() async {
    await _authSubscription?.cancel();
    await _profileSubscription?.cancel();
    return super.close();
  }
}

class ProfileState {
  const ProfileState({required this.preferences, this.user, this.profile});
  final Preferences preferences;
  final AuthUser? user;
  final Profile? profile;

  static const Object _userNotSpecified = Object();
  static const Object _profileNotSpecified = Object();

  ProfileState copyWith({
    Preferences? preferences,
    Object? user = _userNotSpecified,
    Object? profile = _profileNotSpecified,
  }) {
    return ProfileState(
      preferences: preferences ?? this.preferences,
      user: identical(user, _userNotSpecified) ? this.user : user as AuthUser?,
      profile: identical(profile, _profileNotSpecified)
          ? this.profile
          : profile as Profile?,
    );
  }
}
