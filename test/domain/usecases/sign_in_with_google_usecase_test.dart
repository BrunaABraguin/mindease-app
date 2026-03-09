import 'package:flutter_test/flutter_test.dart';
import 'package:mindease_app/src/domain/entities/auth_user.dart';
import 'package:mindease_app/src/domain/repositories/auth_repository.dart';
import 'package:mindease_app/src/domain/usecases/auth/sign_in_with_google_usecase.dart';

class _FakeAuthRepository implements AuthRepository {
  AuthUser? userToReturn;

  @override
  AuthUser? get currentUser => null;

  @override
  Stream<AuthUser?> get authStateChanges => const Stream.empty();

  @override
  Future<AuthUser?> signInWithGoogle() async => userToReturn;

  @override
  Future<void> signOut() async {}
}

void main() {
  group('SignInWithGoogleUseCase', () {
    late _FakeAuthRepository repository;
    late SignInWithGoogleUseCase useCase;

    setUp(() {
      repository = _FakeAuthRepository();
      useCase = SignInWithGoogleUseCase(repository);
    });

    test('should return user when sign in succeeds', () async {
      const user = AuthUser(
        uid: '123',
        email: 'test@test.com',
        displayName: 'Test',
      );
      repository.userToReturn = user;

      final result = await useCase.buildUseCaseFuture(null);
      expect(result, equals(user));
    });

    test('should return null when sign in is cancelled', () async {
      repository.userToReturn = null;

      final result = await useCase.buildUseCaseFuture(null);
      expect(result, isNull);
    });
  });
}
