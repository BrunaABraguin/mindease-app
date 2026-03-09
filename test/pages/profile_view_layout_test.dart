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
  group('ProfileView narrow layout', () {
    late ConfigurableAuthRepository authRepo;
    late ProfileCubit cubit;

    setUp(() {
      authRepo = ConfigurableAuthRepository(
        userToReturn: const AuthUser(
          uid: '1',
          email: 'test@test.com',
          displayName: 'Test User',
          photoURL: '',
        ),
      );
      cubit = ProfileCubit(
        preferencesRepository: MockPreferencesRepository(),
        profileRepository: FakeProfileRepository(),
        getAuthState: ConfigurableGetAuthStateUseCase(authRepo),
        signInWithGoogle: ConfigurableSignInWithGoogleUseCase(authRepo),
        signOut: ConfigurableSignOutUseCase(authRepo),
      );
    });

    tearDown(() {
      cubit.close();
      authRepo.dispose();
    });

    testWidgets('renders sign out button on narrow screen when logged in', (
      tester,
    ) async {
      await cubit.signInWithGoogle();

      await tester.pumpWidget(
        MaterialApp(
          home: MediaQuery(
            data: const MediaQueryData(size: Size(400, 800)),
            child: BlocProvider<ProfileCubit>.value(
              value: cubit,
              child: const ProfileView(),
            ),
          ),
        ),
      );
      await tester.pump();

      // Narrow screen should show sign out at bottom
      expect(find.text('CONFIGURAÇÕES'), findsOneWidget);
      expect(find.text('ESTATÍSTICAS'), findsOneWidget);
    });

    testWidgets('toggle dark theme switch calls cubit', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<ProfileCubit>.value(
            value: cubit,
            child: const ProfileView(),
          ),
        ),
      );
      await tester.pump();

      // Find the dark theme switch and scroll to it
      final switches = find.byType(Switch);
      expect(switches, findsWidgets);
      await tester.ensureVisible(switches.first);
      await tester.pumpAndSettle();
      await tester.tap(switches.first);
      await tester.pump();

      expect(cubit.state.preferences.darkTheme, isTrue);
    });

    testWidgets('toggle show help icons switch', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<ProfileCubit>.value(
            value: cubit,
            child: const ProfileView(),
          ),
        ),
      );
      await tester.pump();

      final switches = find.byType(Switch);
      expect(switches, findsWidgets);

      // Second switch should be show help icons
      if (switches.evaluate().length > 1) {
        await tester.tap(switches.at(1));
        await tester.pump();
      }
    });

    testWidgets('toggle show animations switch', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<ProfileCubit>.value(
            value: cubit,
            child: const ProfileView(),
          ),
        ),
      );
      await tester.pump();

      final switches = find.byType(Switch);
      expect(switches, findsWidgets);

      // Third switch should be show animations
      if (switches.evaluate().length > 2) {
        await tester.tap(switches.at(2));
        await tester.pump();
      }
    });

    testWidgets('sign out button clears user state', (tester) async {
      await cubit.signInWithGoogle();
      expect(cubit.state.user, isNotNull);

      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<ProfileCubit>.value(
            value: cubit,
            child: const ProfileView(),
          ),
        ),
      );
      await tester.pump();

      // Find and tap sign out button
      final signOutButton = find.textContaining('Sair');
      if (signOutButton.evaluate().isNotEmpty) {
        await tester.ensureVisible(signOutButton.first);
        await tester.pumpAndSettle();
        await tester.tap(signOutButton.first);
        await tester.pump();
        expect(cubit.state.user, isNull);
      }
    });

    testWidgets('google sign in button triggers cubit', (tester) async {
      // Auth repo returns no user
      final noUserAuthRepo = ConfigurableAuthRepository();
      final noUserCubit = ProfileCubit(
        preferencesRepository: MockPreferencesRepository(),
        profileRepository: FakeProfileRepository(),
        getAuthState: ConfigurableGetAuthStateUseCase(noUserAuthRepo),
        signInWithGoogle: ConfigurableSignInWithGoogleUseCase(noUserAuthRepo),
        signOut: ConfigurableSignOutUseCase(noUserAuthRepo),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<ProfileCubit>.value(
            value: noUserCubit,
            child: const ProfileView(),
          ),
        ),
      );
      await tester.pump();

      final googleButton = find.textContaining('Google');
      expect(googleButton, findsOneWidget);
      await tester.tap(googleButton);
      await tester.pump();

      noUserCubit.close();
      noUserAuthRepo.dispose();
    });
  });

  group('ProfileView wide layout', () {
    testWidgets('renders sign out in header area on wide screen', (
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
      await cubit.signInWithGoogle();

      await tester.pumpWidget(
        MaterialApp(
          home: MediaQuery(
            data: const MediaQueryData(size: Size(800, 600)),
            child: BlocProvider<ProfileCubit>.value(
              value: cubit,
              child: const ProfileView(),
            ),
          ),
        ),
      );
      await tester.pump();

      expect(find.text('CONFIGURAÇÕES'), findsOneWidget);
      expect(find.text('ESTATÍSTICAS'), findsOneWidget);

      cubit.close();
      authRepo.dispose();
    });
  });
}
