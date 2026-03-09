import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mindease_app/src/app/navigator.dart';
import 'package:mindease_app/src/app/pages/profile/profile_controller.dart';
import 'package:mindease_app/src/data/repositories/timer_repository.dart';
import '../mocks/fake_auth_usecases.dart';
import '../mocks/mock_preferences_repository.dart';

void main() {
  testWidgets('AppNavigator renders and switches tabs', (tester) async {
    final profileCubit = ProfileCubit(
      preferencesRepository: MockPreferencesRepository(),
      getAuthState: FakeGetAuthStateUseCase(),
      signInWithGoogle: FakeSignInWithGoogleUseCase(),
      signOut: FakeSignOutUseCase(),
    );
    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider<ProfileCubit>.value(
          value: profileCubit,
          child: AppNavigator(timerRepository: TimerRepository()),
        ),
      ),
    );
    expect(find.byType(AppNavigator), findsOneWidget);
    // Timer tab
    expect(find.text('Timer'), findsWidgets);
    await tester.tap(find.text('Hábitos').first);
    await tester.pumpAndSettle();
    expect(find.text('Hábitos'), findsWidgets);

    await tester.tap(find.text('Missões').first);
    await tester.pumpAndSettle();
    expect(find.text('Missões'), findsWidgets);
    await tester.tap(find.text('Tarefas').first);
    await tester.pumpAndSettle();
    expect(find.text('Tarefas'), findsWidgets);
    await tester.tap(find.text('Perfil').first);
    await tester.pumpAndSettle();
    expect(find.text('Perfil'), findsWidgets);
  });
}
