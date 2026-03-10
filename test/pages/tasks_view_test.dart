import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mindease_app/src/app/pages/profile/profile_controller.dart';
import 'package:mindease_app/src/app/pages/tasks/tasks_view.dart';

import '../mocks/fake_auth_usecases.dart';
import '../mocks/fake_profile_repository.dart';
import '../mocks/fake_task_repository.dart';
import '../mocks/mock_preferences_repository.dart';

void main() {
  late ProfileCubit profileCubit;
  late FakeTaskRepository fakeTaskRepo;

  setUp(() {
    profileCubit = ProfileCubit(
      preferencesRepository: MockPreferencesRepository(),
      profileRepository: FakeProfileRepository(),
      getAuthState: LoggedInFakeGetAuthStateUseCase(),
      signInWithGoogle: FakeSignInWithGoogleUseCase(),
      signOut: FakeSignOutUseCase(),
    );
    fakeTaskRepo = FakeTaskRepository();
  });

  group('TasksPage', () {
    testWidgets('deve renderizar summary bar quando logado', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<ProfileCubit>.value(
            value: profileCubit,
            child: TasksPage(taskRepository: fakeTaskRepo),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Prioridades'), findsOneWidget);
      expect(find.text('Tarefas'), findsOneWidget);
    });

    testWidgets('deve mostrar login message quando deslogado', (tester) async {
      final loggedOutCubit = ProfileCubit(
        preferencesRepository: MockPreferencesRepository(),
        profileRepository: FakeProfileRepository(),
        getAuthState: FakeGetAuthStateUseCase(),
        signInWithGoogle: FakeSignInWithGoogleUseCase(),
        signOut: FakeSignOutUseCase(),
      );
      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<ProfileCubit>.value(
            value: loggedOutCubit,
            child: TasksPage(taskRepository: fakeTaskRepo),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.textContaining('Faça login'), findsOneWidget);
    });
  });
}
