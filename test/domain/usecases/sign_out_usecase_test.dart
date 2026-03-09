import 'package:flutter_test/flutter_test.dart';
import 'package:mindease_app/src/domain/entities/auth_user.dart';
import 'package:mindease_app/src/domain/repositories/auth_repository.dart';
import 'package:mindease_app/src/domain/usecases/auth/sign_out_usecase.dart';

class _FakeAuthRepository implements AuthRepository {
  bool signOutCalled = false;

  @override
  AuthUser? get currentUser => null;

  @override
  Stream<AuthUser?> get authStateChanges => const Stream.empty();

  @override
  Future<AuthUser?> signInWithGoogle() async => null;

  @override
  Future<void> signOut() async {
    signOutCalled = true;
  }
}

void main() {
  group('SignOutUseCase', () {
    late _FakeAuthRepository repository;
    late SignOutUseCase useCase;

    setUp(() {
      repository = _FakeAuthRepository();
      useCase = SignOutUseCase(repository);
    });

    test('should call signOut on repository', () async {
      await useCase.buildUseCaseFuture(null);
      expect(repository.signOutCalled, isTrue);
    });
  });
}
