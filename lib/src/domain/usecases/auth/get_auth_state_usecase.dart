import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:mindease_app/src/domain/entities/auth_user.dart';
import 'package:mindease_app/src/domain/repositories/auth_repository.dart';

class GetAuthStateUseCase extends UseCase<AuthUser?, void> {
  GetAuthStateUseCase(this._repository);
  final AuthRepository _repository;

  @override
  Future<Stream<AuthUser?>> buildUseCaseStream(void params) async =>
      _repository.authStateChanges;
}
