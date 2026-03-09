import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:mindease_app/src/domain/entities/auth_user.dart';
import 'package:mindease_app/src/domain/repositories/auth_repository.dart';
import 'package:mindease_app/src/domain/usecases/auth/get_auth_state_usecase.dart';

class _FakeAuthRepository implements AuthRepository {
  final StreamController<AuthUser?> _controller =
      StreamController<AuthUser?>.broadcast();

  @override
  AuthUser? get currentUser => null;

  @override
  Stream<AuthUser?> get authStateChanges => _controller.stream;

  @override
  Future<AuthUser?> signInWithGoogle() async => null;

  @override
  Future<void> signOut() async {}

  void emitUser(AuthUser? user) => _controller.add(user);

  void dispose() => _controller.close();
}

void main() {
  group('GetAuthStateUseCase', () {
    late _FakeAuthRepository repository;
    late GetAuthStateUseCase useCase;

    setUp(() {
      repository = _FakeAuthRepository();
      useCase = GetAuthStateUseCase(repository);
    });

    tearDown(() {
      repository.dispose();
    });

    test('should return auth state stream from repository', () async {
      final stream = await useCase.buildUseCaseStream(null);

      const user = AuthUser(
        uid: '123',
        email: 'test@test.com',
        displayName: 'Test User',
      );

      expectLater(stream, emitsInOrder([user, null]));

      repository.emitUser(user);
      repository.emitUser(null);
    });

    test('should emit nothing when no auth state changes', () async {
      final stream = await useCase.buildUseCaseStream(null);

      expectLater(stream, emitsDone);

      repository.dispose();
    });
  });
}
