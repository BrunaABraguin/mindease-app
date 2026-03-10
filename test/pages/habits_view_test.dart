import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:mindease_app/src/app/pages/habits/habits_view.dart';
import 'package:mindease_app/src/app/pages/profile/profile_controller.dart';
import 'package:mindease_app/src/app/widgets/login_required_message.dart';
import 'package:mindease_app/src/domain/repositories/habit_repository.dart';
import 'package:mocktail/mocktail.dart';

import '../mocks/fake_auth_usecases.dart';
import '../mocks/fake_profile_repository.dart';
import '../mocks/mock_preferences_repository.dart';

class MockHabitRepository extends Mock implements HabitRepository {}

void main() {
  setUpAll(() async {
    await initializeDateFormatting('pt_BR');
  });
  group('HabitsPage', () {
    testWidgets('deve exibir mensagem de login quando não logado', (
      tester,
    ) async {
      final profileCubit = ProfileCubit(
        preferencesRepository: MockPreferencesRepository(),
        profileRepository: FakeProfileRepository(),
        getAuthState: FakeGetAuthStateUseCase(),
        signInWithGoogle: FakeSignInWithGoogleUseCase(),
        signOut: FakeSignOutUseCase(),
      );
      final habitRepository = MockHabitRepository();
      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<ProfileCubit>.value(
            value: profileCubit,
            child: HabitsPage(habitRepository: habitRepository),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(LoginRequiredMessage), findsOneWidget);
    });

    testWidgets('deve exibir lista de hábitos quando logado', (tester) async {
      final profileCubit = ProfileCubit(
        preferencesRepository: MockPreferencesRepository(),
        profileRepository: FakeProfileRepository(),
        getAuthState: LoggedInFakeGetAuthStateUseCase(),
        signInWithGoogle: FakeSignInWithGoogleUseCase(),
        signOut: FakeSignOutUseCase(),
      );
      final habitRepository = MockHabitRepository();
      when(
        () => habitRepository.habitsStream(any()),
      ).thenAnswer((_) => Stream.value([]));
      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<ProfileCubit>.value(
            value: profileCubit,
            child: HabitsPage(habitRepository: habitRepository),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(LoginRequiredMessage), findsNothing);
    });
  });
}
