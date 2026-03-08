import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mindease_app/src/app/pages/profile/profile_controller.dart';
import 'package:mindease_app/src/app/pages/profile/profile_view.dart';
import 'package:mindease_app/src/data/repositories/preferences_repository.dart';

class MockProfileCubit extends ProfileCubit {
  MockProfileCubit()
      : super(preferencesRepository: PreferencesRepository());
}

void main() {
  testWidgets('ProfileView renders preferences', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider<ProfileCubit>(
          create: (_) => MockProfileCubit(),
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
