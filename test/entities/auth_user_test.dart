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

    test('different runtimeType returns false', () {
      const user = AuthUser(uid: '1');
      expect(user == 'string', isFalse);
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
  });
}
