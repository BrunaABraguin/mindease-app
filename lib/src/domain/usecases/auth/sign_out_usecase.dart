import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:mindease_app/src/domain/repositories/auth_repository.dart';

class SignOutUseCase extends CompletableFutureUseCase<void> {
  SignOutUseCase(this._repository);
  final AuthRepository _repository;

  @override
  Future<void> buildUseCaseFuture(void params) => _repository.signOut();
}
