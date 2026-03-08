import 'package:flutter_test/flutter_test.dart';
import 'package:mindease_app/src/domain/entities/auth_user.dart';

void main() {
  group('AuthUser', () {
    test('equality and hashCode', () {
      final user1 = AuthUser(
        uid: '1',
        email: 'a@b.com',
        displayName: 'A',
        photoURL: 'url',
      );
      final user2 = AuthUser(
        uid: '1',
        email: 'a@b.com',
        displayName: 'A',
        photoURL: 'url',
      );
      final user3 = AuthUser(uid: '2');
      expect(user1, equals(user2));
      expect(user1.hashCode, equals(user2.hashCode));
      expect(user1, isNot(equals(user3)));
    });
  });
}
