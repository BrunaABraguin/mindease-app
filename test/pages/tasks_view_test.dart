import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mindease_app/src/app/pages/profile/profile_controller.dart';
import 'package:mindease_app/src/app/pages/tasks/tasks_view.dart';
import 'package:mindease_app/src/app/utils/app_constants.dart';

import '../mocks/fake_auth_usecases.dart';
import '../mocks/fake_profile_repository.dart';
import '../mocks/mock_preferences_repository.dart';

void main() {
  late ProfileCubit profileCubit;

  setUp(() {
    profileCubit = ProfileCubit(
      preferencesRepository: MockPreferencesRepository(),
      profileRepository: FakeProfileRepository(),
      getAuthState: LoggedInFakeGetAuthStateUseCase(),
      signInWithGoogle: FakeSignInWithGoogleUseCase(),
      signOut: FakeSignOutUseCase(),
    );
  });

  group('TasksPage', () {
    testWidgets('deve renderizar ícone e texto de tarefas', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<ProfileCubit>.value(
            value: profileCubit,
            child: const TasksPage(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byIcon(AppIcons.tasks), findsOneWidget);
      expect(find.text(AppStrings.tasks), findsOneWidget);
    });

    testWidgets('deve usar cor primária do tema no ícone', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
          ),
          home: BlocProvider<ProfileCubit>.value(
            value: profileCubit,
            child: const TasksPage(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      final icon = tester.widget<Icon>(find.byIcon(AppIcons.tasks));
      expect(icon.size, AppSizes.iconLarge);
    });
  });
}
