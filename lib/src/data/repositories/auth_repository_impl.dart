import 'package:mindease_app/src/data/helpers/auth_remote_datasource.dart';
import 'package:mindease_app/src/domain/entities/auth_user.dart';
import 'package:mindease_app/src/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl({AuthRemoteDataSource? remote})
    : _remote = remote ?? AuthRemoteDataSource();
  final AuthRemoteDataSource _remote;

  @override
  AuthUser? get currentUser => _remote.currentUser == null
      ? null
      : _fromFirebaseUser(_remote.currentUser!);

  @override
  Stream<AuthUser?> get authStateChanges => _remote.authStateChanges.map(
    (user) => user == null ? null : _fromFirebaseUser(user),
  );

  @override
  Future<AuthUser?> signInWithGoogle() async {
    final userCred = await _remote.signInWithGoogle();
    if (userCred?.user == null) return null;
    return _fromFirebaseUser(userCred!.user!);
  }

  @override
  Future<void> signOut() => _remote.signOut();

  AuthUser _fromFirebaseUser(dynamic user) => AuthUser(
    uid: user.uid,
    email: user.email,
    displayName: user.displayName,
    photoURL: user.photoURL,
  );
}
