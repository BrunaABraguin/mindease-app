import 'package:mindease_app/src/data/repositories/auth_repository_impl.dart';
import 'package:mindease_app/src/domain/entities/auth_user.dart';
import 'package:mockito/mockito.dart';

class MockAuthRepositoryImpl extends Mock implements AuthRepositoryImpl {
  @override
  Stream<AuthUser?> get authStateChanges => const Stream<AuthUser?>.empty();
}
