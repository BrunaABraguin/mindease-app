import 'package:mindease_app/src/domain/entities/auth_user.dart';
import 'package:mindease_app/src/domain/repositories/auth_repository.dart';
import 'package:mindease_app/src/domain/usecases/auth/get_auth_state_usecase.dart';
import 'package:mindease_app/src/domain/usecases/auth/sign_in_with_google_usecase.dart';
import 'package:mindease_app/src/domain/usecases/auth/sign_out_usecase.dart';

class FakeAuthRepository implements AuthRepository {
  @override
  AuthUser? get currentUser => null;
  @override
  Stream<AuthUser?> get authStateChanges => const Stream.empty();
  @override
  Future<AuthUser?> signInWithGoogle() async => null;
  @override
  Future<void> signOut() async {}
}

class LoggedInFakeAuthRepository implements AuthRepository {
  @override
  AuthUser? get currentUser =>
      const AuthUser(uid: 'test-uid', email: 'test@test.com');
  @override
  Stream<AuthUser?> get authStateChanges =>
      Stream.value(const AuthUser(uid: 'test-uid', email: 'test@test.com'));
  @override
  Future<AuthUser?> signInWithGoogle() async => currentUser;
  @override
  Future<void> signOut() async {}
}

class FakeGetAuthStateUseCase extends GetAuthStateUseCase {
  FakeGetAuthStateUseCase() : super(FakeAuthRepository());
}

class LoggedInFakeGetAuthStateUseCase extends GetAuthStateUseCase {
  LoggedInFakeGetAuthStateUseCase() : super(LoggedInFakeAuthRepository());
}

class FakeSignInWithGoogleUseCase extends SignInWithGoogleUseCase {
  FakeSignInWithGoogleUseCase() : super(FakeAuthRepository());
}

class FakeSignOutUseCase extends SignOutUseCase {
  FakeSignOutUseCase() : super(FakeAuthRepository());
}
