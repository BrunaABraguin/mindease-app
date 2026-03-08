import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mindease_app/src/data/repositories/preferences_repository.dart';
import 'package:mindease_app/src/domain/entities/preferences.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit({required PreferencesRepository preferencesRepository})
    : _repo = preferencesRepository,
      super(ProfileState(preferences: Preferences.defaultValues())) {
    _loadPreferences();
  }
  final PreferencesRepository _repo;

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
}

class ProfileState {
  const ProfileState({required this.preferences});
  final Preferences preferences;

  ProfileState copyWith({Preferences? preferences}) {
    return ProfileState(preferences: preferences ?? this.preferences);
  }
}
