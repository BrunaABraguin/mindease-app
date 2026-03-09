class AuthUser {
  const AuthUser({
    required this.uid,
    this.email,
    this.displayName,
    this.photoURL,
  });
  final String uid;
  final String? email;
  final String? displayName;
  final String? photoURL;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other.runtimeType != runtimeType) return false;
    return other is AuthUser &&
        other.uid == uid &&
        other.email == email &&
        other.displayName == displayName &&
        other.photoURL == photoURL;
  }

  @override
  int get hashCode =>
      uid.hashCode ^
      (email?.hashCode ?? 0) ^
      (displayName?.hashCode ?? 0) ^
      (photoURL?.hashCode ?? 0);
}
