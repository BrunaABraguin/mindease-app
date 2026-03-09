import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mindease_app/src/data/repositories/preferences_repository.dart';
import 'package:mindease_app/src/domain/entities/auth_user.dart';
import 'package:mindease_app/src/domain/entities/preferences.dart';
import 'package:mindease_app/src/domain/usecases/auth/get_auth_state_usecase.dart';
import 'package:mindease_app/src/domain/usecases/auth/sign_in_with_google_usecase.dart';
import 'package:mindease_app/src/domain/usecases/auth/sign_out_usecase.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit({
    required PreferencesRepository preferencesRepository,
    required GetAuthStateUseCase getAuthState,
    required SignInWithGoogleUseCase signInWithGoogle,
    required SignOutUseCase signOut,
  }) : _repo = preferencesRepository,
       _getAuthState = getAuthState,
       _signInWithGoogle = signInWithGoogle,
       _signOut = signOut,
       super(
         ProfileState(preferences: Preferences.defaultValues()),
       ) {
    _loadPreferences();
    _listenAuth();
  }
  final PreferencesRepository _repo;
  final GetAuthStateUseCase _getAuthState;
  final SignInWithGoogleUseCase _signInWithGoogle;
  final SignOutUseCase _signOut;

  StreamSubscription<AuthUser?>? _authSubscription;

  Future<void> _listenAuth() async {
    _getAuthState.buildUseCaseStream(null).then((stream) {
      _authSubscription = stream.listen((user) {
        emit(state.copyWith(user: user));
      });
    });
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

  @override
  Future<void> close() async {
    await _authSubscription?.cancel();
    return super.close();
  }
}

class ProfileState {
  const ProfileState({required this.preferences, this.user});
  final Preferences preferences;
  final AuthUser? user;

  static const Object _userNotSpecified = Object();

  ProfileState copyWith({
    Preferences? preferences,
    Object? user = _userNotSpecified,
  }) {
    return ProfileState(
      preferences: preferences ?? this.preferences,
      user: identical(user, _userNotSpecified) ? this.user : user as AuthUser?,
    );
  }
}
