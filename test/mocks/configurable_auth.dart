import 'dart:async';
import 'package:mindease_app/src/domain/entities/auth_user.dart';
import 'package:mindease_app/src/domain/repositories/auth_repository.dart';
import 'package:mindease_app/src/domain/usecases/auth/get_auth_state_usecase.dart';
import 'package:mindease_app/src/domain/usecases/auth/sign_in_with_google_usecase.dart';
import 'package:mindease_app/src/domain/usecases/auth/sign_out_usecase.dart';

class ConfigurableAuthRepository implements AuthRepository {
  ConfigurableAuthRepository({this.userToReturn});

  AuthUser? userToReturn;
  final StreamController<AuthUser?> _controller =
      StreamController<AuthUser?>.broadcast();

  @override
  AuthUser? get currentUser => userToReturn;

  @override
  Stream<AuthUser?> get authStateChanges => _controller.stream;

  @override
  Future<AuthUser?> signInWithGoogle() async => userToReturn;

  @override
  Future<void> signOut() async {
    userToReturn = null;
  }

  void emitUser(AuthUser? user) => _controller.add(user);

  void dispose() => _controller.close();
}

class ConfigurableGetAuthStateUseCase extends GetAuthStateUseCase {
  ConfigurableGetAuthStateUseCase(ConfigurableAuthRepository super.repo);
}

class ConfigurableSignInWithGoogleUseCase extends SignInWithGoogleUseCase {
  ConfigurableSignInWithGoogleUseCase(ConfigurableAuthRepository super.repo);
}

class ConfigurableSignOutUseCase extends SignOutUseCase {
  ConfigurableSignOutUseCase(ConfigurableAuthRepository super.repo);
}
