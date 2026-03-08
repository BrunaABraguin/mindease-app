import 'package:mindease_app/src/domain/entities/auth_user.dart';

abstract class AuthRepository {
  AuthUser? get currentUser;
  Stream<AuthUser?> get authStateChanges;
  Future<AuthUser?> signInWithGoogle();
  Future<void> signOut();
}
