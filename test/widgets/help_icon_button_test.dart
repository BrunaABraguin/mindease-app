import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mindease_app/src/app/pages/profile/profile_controller.dart';
import 'package:mindease_app/src/app/utils/help_texts.dart';
import 'package:mindease_app/src/app/widgets/help_icon_button.dart';

import '../mocks/fake_auth_usecases.dart';
import '../repositories/fake_preferences_repository.dart';

void main() {
  testWidgets('HelpIcon exibe dialog com título e descrição corretos', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider<ProfileCubit>(
          create: (_) => ProfileCubit(
            preferencesRepository: FakePreferencesRepository(),
            getAuthState: FakeGetAuthStateUseCase(),
            signInWithGoogle: FakeSignInWithGoogleUseCase(),
            signOut: FakeSignOutUseCase(),
          ),
          child: const Scaffold(
            body: HelpIconButton(
              title: HelpTexts.focusModeTitle,
              description: HelpTexts.focusModeDescription,
            ),
          ),
        ),
      ),
    );

    // O ícone deve estar presente
    expect(find.byIcon(Icons.help_outline), findsOneWidget);

    // Toca no ícone
    await tester.tap(find.byIcon(Icons.help_outline));
    await tester.pumpAndSettle();

    // O dialog deve aparecer com o título e descrição
    expect(find.text(HelpTexts.focusModeTitle), findsOneWidget);
    expect(find.text(HelpTexts.focusModeDescription), findsOneWidget);
    expect(find.text('Entendi'), findsOneWidget);
  });
}
