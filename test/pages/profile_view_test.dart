import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mindease_app/src/app/pages/profile/profile_controller.dart';
import 'package:mindease_app/src/app/pages/profile/profile_view.dart';
import 'package:mindease_app/src/data/repositories/preferences_repository.dart';
import 'package:mindease_app/src/domain/usecases/auth/get_auth_state_usecase.dart';
import 'package:mindease_app/src/domain/usecases/auth/sign_in_with_google_usecase.dart';
import 'package:mindease_app/src/domain/usecases/auth/sign_out_usecase.dart';
import '../mocks/mock_auth_repository_impl.dart';

void main() {
  testWidgets('ProfileView renders preferences', (tester) async {
    final mockAuthRepository = MockAuthRepositoryImpl();

    final profileCubit = ProfileCubit(
      preferencesRepository: PreferencesRepository(),
      getAuthState: GetAuthStateUseCase(mockAuthRepository),
      signInWithGoogle: SignInWithGoogleUseCase(mockAuthRepository),
      signOut: SignOutUseCase(mockAuthRepository),
    );

    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider<ProfileCubit>(
          create: (_) => profileCubit,
          child: const ProfileView(),
        ),
      ),
    );
    expect(find.byType(ProfileView), findsOneWidget);
    expect(find.text('CONFIGURAÇÕES'), findsOneWidget);
    expect(find.text('Modo escuro'), findsOneWidget);
    expect(find.text('Mostrar ícone de ajuda'), findsOneWidget);
    expect(find.text('Mostrar animações'), findsOneWidget);
  });
}
