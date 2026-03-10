import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:mindease_app/src/app/navigator.dart';
import 'package:mindease_app/src/app/pages/profile/profile_controller.dart';
import 'package:mindease_app/src/data/repositories/timer_repository.dart';
import '../mocks/fake_auth_usecases.dart';
import '../mocks/fake_habit_repository.dart';
import '../mocks/fake_profile_repository.dart';
import '../mocks/fake_task_repository.dart';
import '../mocks/mock_preferences_repository.dart';

void main() {
  setUpAll(() async {
    await initializeDateFormatting('pt_BR');
  });

  testWidgets('AppNavigator renders and switches tabs', (tester) async {
    final profileCubit = ProfileCubit(
      preferencesRepository: MockPreferencesRepository(),
      profileRepository: FakeProfileRepository(),
      getAuthState: FakeGetAuthStateUseCase(),
      signInWithGoogle: FakeSignInWithGoogleUseCase(),
      signOut: FakeSignOutUseCase(),
    );
    final fakeHabitRepo = FakeHabitRepository();
    final fakeTaskRepo = FakeTaskRepository();
    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider<ProfileCubit>.value(
          value: profileCubit,
          child: AppNavigator(
            timerRepository: TimerRepository(),
            habitRepository: fakeHabitRepo,
            taskRepository: fakeTaskRepo,
          ),
        ),
      ),
    );
    expect(find.byType(AppNavigator), findsOneWidget);
    // Timer tab
    expect(find.text('Timer'), findsWidgets);
    // Use pump() instead of pumpAndSettle() because the timer page has a
    // repeating blink animation that keeps running when preserved via
    // IndexedStack, preventing pumpAndSettle from completing.
    await tester.tap(find.text('Hábitos').first);
    await tester.pump();
    expect(find.text('Hábitos'), findsWidgets);

    await tester.tap(find.text('Missões').first);
    await tester.pump();
    expect(find.text('Missões'), findsWidgets);
    await tester.tap(find.text('Tarefas').first);
    await tester.pump();
    expect(find.text('Tarefas'), findsWidgets);
    await tester.tap(find.text('Perfil').first);
    await tester.pump();
    expect(find.text('Perfil'), findsWidgets);
  });
}
