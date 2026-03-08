import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:mindease_app/src/domain/entities/auth_user.dart';
import 'package:mindease_app/src/domain/repositories/auth_repository.dart';

class SignInWithGoogleUseCase extends FutureUseCase<AuthUser?, void> {
  SignInWithGoogleUseCase(this._repository);
  final AuthRepository _repository;

  @override
  Future<AuthUser?> buildUseCaseFuture(void params) =>
      _repository.signInWithGoogle();
}
