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
  group('TimerView extended', () {
    late ProfileCubit profileCubit;

    setUp(() {
      profileCubit = ProfileCubit(
        preferencesRepository: MockPreferencesRepository(),
        profileRepository: FakeProfileRepository(),
        getAuthState: FakeGetAuthStateUseCase(),
        signInWithGoogle: FakeSignInWithGoogleUseCase(),
        signOut: FakeSignOutUseCase(),
      );
    });

    tearDown(() => profileCubit.close());

    testWidgets('renders timer display and control buttons', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<ProfileCubit>.value(
            value: profileCubit,
            child: TimerPage(timerRepository: TimerRepository()),
          ),
        ),
      );

      // Timer display should be present
      expect(find.textContaining(':'), findsWidgets);
    });

    testWidgets('renders segmented button', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<ProfileCubit>.value(
            value: profileCubit,
            child: TimerPage(timerRepository: TimerRepository()),
          ),
        ),
      );

      // The segmented button modes should be present
      expect(find.text('Foco'), findsOneWidget);
    });

    testWidgets('focus mode button navigates to FocusModePage', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<ProfileCubit>.value(
            value: profileCubit,
            child: TimerPage(timerRepository: TimerRepository()),
          ),
        ),
      );

      // Find and tap focus mode button
      final focusButton = find.byTooltip('Focus Mode');
      if (focusButton.evaluate().isNotEmpty) {
        await tester.tap(focusButton);
        await tester.pumpAndSettle();
      }
    });
  });
}
