import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mindease_app/src/app/pages/profile/profile_controller.dart';
import 'package:mindease_app/src/app/pages/profile/profile_view.dart';
import 'package:mindease_app/src/domain/entities/auth_user.dart';

import '../mocks/configurable_auth.dart';
import '../mocks/fake_profile_repository.dart';
import '../mocks/mock_preferences_repository.dart';

void main() {
  group('ProfileView with logged-in user', () {
    testWidgets('renders statistics section and sign out when user is set', (
      tester,
    ) async {
      final authRepo = ConfigurableAuthRepository(
        userToReturn: const AuthUser(
          uid: '1',
          email: 'test@test.com',
          displayName: 'Test User',
          photoURL: '',
        ),
      );
      final cubit = ProfileCubit(
        preferencesRepository: MockPreferencesRepository(),
        profileRepository: FakeProfileRepository(),
        getAuthState: ConfigurableGetAuthStateUseCase(authRepo),
        signInWithGoogle: ConfigurableSignInWithGoogleUseCase(authRepo),
        signOut: ConfigurableSignOutUseCase(authRepo),
      );

      // Sign in to populate state.user
      await cubit.signInWithGoogle();

      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<ProfileCubit>.value(
            value: cubit,
            child: const ProfileView(),
          ),
        ),
      );
      await tester.pump();

      // Should show statistics section
      expect(find.text('ESTATÍSTICAS'), findsOneWidget);
      // Should show settings
      expect(find.text('CONFIGURAÇÕES'), findsOneWidget);

      cubit.close();
      authRepo.dispose();
    });

    testWidgets('renders Google sign-in button when no user', (tester) async {
      final authRepo = ConfigurableAuthRepository();
      final cubit = ProfileCubit(
        preferencesRepository: MockPreferencesRepository(),
        profileRepository: FakeProfileRepository(),
        getAuthState: ConfigurableGetAuthStateUseCase(authRepo),
        signInWithGoogle: ConfigurableSignInWithGoogleUseCase(authRepo),
        signOut: ConfigurableSignOutUseCase(authRepo),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<ProfileCubit>.value(
            value: cubit,
            child: const ProfileView(),
          ),
        ),
      );
      await tester.pump();

      // Should show google sign-in button text
      expect(find.textContaining('Google'), findsOneWidget);

      cubit.close();
      authRepo.dispose();
    });
  });
}
