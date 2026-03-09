import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mindease_app/src/app/pages/profile/profile_controller.dart';
import 'package:mindease_app/src/app/pages/timer/timer_view.dart';
import 'package:mindease_app/src/data/repositories/timer_repository.dart';

import '../mocks/fake_auth_usecases.dart';
import '../mocks/fake_profile_repository.dart';
import '../mocks/mock_preferences_repository.dart';

void main() {
  testWidgets('TimerPage renders TimerView', (tester) async {
    final profileCubit = ProfileCubit(
      preferencesRepository: MockPreferencesRepository(),
      profileRepository: FakeProfileRepository(),
      getAuthState: FakeGetAuthStateUseCase(),
      signInWithGoogle: FakeSignInWithGoogleUseCase(),
      signOut: FakeSignOutUseCase(),
    );
    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider<ProfileCubit>.value(
          value: profileCubit,
          child: TimerPage(timerRepository: TimerRepository()),
        ),
      ),
    );
    expect(find.byType(TimerPage), findsOneWidget);
    expect(find.byType(TimerView), findsOneWidget);
  });
}
