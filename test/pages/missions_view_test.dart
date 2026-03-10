import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mindease_app/src/app/pages/missions/missions_view.dart';
import 'package:mindease_app/src/app/pages/profile/profile_controller.dart';
import 'package:mindease_app/src/app/utils/app_constants.dart';
import 'package:mindease_app/src/domain/entities/mission.dart';

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

  group('MissionsPage', () {
    testWidgets('deve renderizar título e contador de missões', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<ProfileCubit>.value(
            value: profileCubit,
            child: const MissionsPage(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text(AppStrings.missions), findsOneWidget);
      expect(
        find.text(AppStrings.missionsProgress(0, totalMissionsCount)),
        findsOneWidget,
      );
    });

    testWidgets('deve renderizar seções de missões', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<ProfileCubit>.value(
            value: profileCubit,
            child: const MissionsPage(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      for (final section in appMissions) {
        expect(find.text(section.title.toUpperCase()), findsOneWidget);
      }
    });
  });
}
