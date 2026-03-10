import 'package:flutter_test/flutter_test.dart';
import 'package:mindease_app/src/domain/entities/auth_user.dart';

void main() {
  group('AuthUser', () {
    test('equality with same fields', () {
      const a = AuthUser(
        uid: '1',
        email: 'a@b.com',
        displayName: 'A',
        photoURL: 'url',
      );
      const b = AuthUser(
        uid: '1',
        email: 'a@b.com',
        displayName: 'A',
        photoURL: 'url',
      );
      expect(a, equals(b));
    });

    test('inequality with different uid', () {
      const a = AuthUser(uid: '1', email: 'a@b.com');
      const b = AuthUser(uid: '2', email: 'a@b.com');
      expect(a, isNot(equals(b)));
    });

    test('identical returns true', () {
      const user = AuthUser(uid: '1');
      expect(user == user, isTrue);
    });

    test('hashCode is consistent', () {
      const a = AuthUser(uid: '1', email: 'a@b.com');
      const b = AuthUser(uid: '1', email: 'a@b.com');
      expect(a.hashCode, equals(b.hashCode));
    });

    test('handles null optional fields', () {
      const user = AuthUser(uid: '1');
      expect(user.email, isNull);
      expect(user.displayName, isNull);
      expect(user.photoURL, isNull);
    });

    test('equality with null fields', () {
      const a = AuthUser(uid: '1');
      const b = AuthUser(uid: '1');
      expect(a, equals(b));
    });

    test('inequality with different optional fields', () {
      const a = AuthUser(uid: '1', email: 'a@b.com');
      const b = AuthUser(uid: '1', email: 'c@d.com');
      expect(a, isNot(equals(b)));
    });

    test('equality passes through all fields (non-const)', () {
      // Non-const to avoid identical() short-circuit
      // ignore: prefer_const_constructors
      final a = AuthUser(
        uid: '1',
        email: 'a@b.com',
        displayName: 'A',
        photoURL: 'url',
      );
      // ignore: prefer_const_constructors
      final b = AuthUser(
        uid: '1',
        email: 'a@b.com',
        displayName: 'A',
        photoURL: 'url',
      );
      expect(a == b, isTrue);
    });

    test('inequality with same uid different displayName', () {
      // ignore: prefer_const_constructors
      final a = AuthUser(uid: '1', email: 'a@b.com', displayName: 'A');
      // ignore: prefer_const_constructors
      final b = AuthUser(uid: '1', email: 'a@b.com', displayName: 'B');
      expect(a == b, isFalse);
    });
  });
}
