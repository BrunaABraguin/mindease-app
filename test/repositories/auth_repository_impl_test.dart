import 'package:flutter_test/flutter_test.dart';
import 'package:mindease_app/src/domain/entities/auth_user.dart';
import 'package:mindease_app/src/domain/repositories/auth_repository.dart';

import '../mocks/fake_auth_usecases.dart';

void main() {
  group('AuthRepository contract via FakeAuthRepository', () {
    late AuthRepository repo;

    setUp(() {
      repo = FakeAuthRepository();
    });

    test('currentUser returns null when not logged in', () {
      expect(repo.currentUser, isNull);
    });

    test('signInWithGoogle returns null for FakeAuthRepository', () async {
      final user = await repo.signInWithGoogle();
      expect(user, isNull);
    });

    test('signOut completes without error', () async {
      await repo.signOut();
    });

    test('authStateChanges is empty stream', () {
      expect(repo.authStateChanges, emitsDone);
    });
  });

  group('AuthRepository contract via LoggedInFakeAuthRepository', () {
    late AuthRepository repo;

    setUp(() {
      repo = LoggedInFakeAuthRepository();
    });

    test('currentUser returns AuthUser when logged in', () {
      final user = repo.currentUser;
      expect(user, isNotNull);
      expect(user, isA<AuthUser>());
      expect(user!.uid, 'test-uid');
      expect(user.email, 'test@test.com');
    });

    test('signInWithGoogle returns AuthUser', () async {
      final user = await repo.signInWithGoogle();
      expect(user, isNotNull);
      expect(user!.uid, 'test-uid');
    });

    test('authStateChanges emits the current user', () async {
      final user = await repo.authStateChanges.first;
      expect(user, isNotNull);
      expect(user!.uid, 'test-uid');
    });
  });
}
