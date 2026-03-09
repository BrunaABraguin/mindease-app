import 'dart:developer' as developer;

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:mindease_app/firebase_options.dart';
import 'package:mindease_app/src/app/navigator.dart';
import 'package:mindease_app/src/app/pages/profile/profile_controller.dart';
import 'package:mindease_app/src/data/di/auth_di.dart';
import 'package:mindease_app/src/data/repositories/preferences_repository.dart';
import 'package:mindease_app/src/data/repositories/timer_repository.dart'
    as repo;
import 'package:mindease_app/theme.dart';

Future<void> main() async {
  try {
    WidgetsFlutterBinding.ensureInitialized();
    await dotenv.load(fileName: "env");
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    Bloc.observer = const AppBlocObserver();

    runApp(const Mindease());
  } on Object catch (error, stack) {
    developer.log('[Bootstrap error] $error\n$stack', name: 'Bootstrap');
    runApp(
      MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          body: Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Text(
                'Erro ao inicializar o app:\n$error',
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class AppBlocObserver extends BlocObserver {
  const AppBlocObserver();

  @override
  void onChange(BlocBase<dynamic> bloc, Change<dynamic> change) {
    super.onChange(bloc, change);
    if (bloc is Cubit) {
      developer.log(change.toString(), name: 'BlocChange');
    }
  }

  @override
  void onTransition(
    Bloc<dynamic, dynamic> bloc,
    Transition<dynamic, dynamic> transition,
  ) {
    super.onTransition(bloc, transition);
    developer.log(transition.toString(), name: 'BlocTransition');
  }
}

class Mindease extends StatelessWidget {
  const Mindease({super.key});

  @override
  Widget build(BuildContext context) {
    final preferencesRepository = PreferencesRepository();
    final timerRepository = repo.TimerRepository();
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider.value(value: preferencesRepository),
        RepositoryProvider.value(value: timerRepository),
      ],
      child: BlocProvider<ProfileCubit>(
        create: (_) => ProfileCubit(
          preferencesRepository: preferencesRepository,
          getAuthState: getAuthStateUseCase,
          signInWithGoogle: signInWithGoogleUseCase,
          signOut: signOutUseCase,
        ),
        child: const AppView(),
      ),
    );
  }
}

class AppView extends StatelessWidget {
  const AppView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileCubit, ProfileState>(
      builder: (context, state) {
        final isDark = state.preferences.darkTheme;
        final timerRepository = context.read<repo.TimerRepository>();
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: isDark ? AppTheme.darkTheme : AppTheme.lightTheme,
          home: AppNavigator(timerRepository: timerRepository),
        );
      },
    );
  }
}
