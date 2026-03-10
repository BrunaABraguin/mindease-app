import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:google_sign_in/google_sign_in.dart';

/// Handles Firebase authentication, supporting Google Sign-In on both
/// mobile and web platforms.
///
/// On web, [_googleSignIn] is `null` because Google Sign-In is handled
/// directly through [FirebaseAuth.signInWithPopup] using a
/// [GoogleAuthProvider]. On mobile, a [GoogleSignIn] instance is used
/// to obtain credentials before passing them to Firebase.
class AuthRemoteDataSource {
  AuthRemoteDataSource({FirebaseAuth? firebaseAuth, GoogleSignIn? googleSignIn})
    : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance,
      _googleSignIn = googleSignIn ?? (kIsWeb ? null : GoogleSignIn());
  final FirebaseAuth _firebaseAuth;
  final GoogleSignIn? _googleSignIn;

  User? get currentUser => _firebaseAuth.currentUser;

  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  Future<UserCredential?> signInWithGoogle() async {
    if (kIsWeb) {
      final provider = GoogleAuthProvider();
      return _firebaseAuth.signInWithPopup(provider);
    }

    final googleSignIn = _googleSignIn;
    if (googleSignIn == null) return null;

    final googleUser = await googleSignIn.signIn();
    if (googleUser == null) return null;

    final googleAuth = await googleUser.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    return _firebaseAuth.signInWithCredential(credential);
  }

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
    if (!kIsWeb) await _googleSignIn?.signOut();
  }
}
