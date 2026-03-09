import 'package:mindease_app/src/data/helpers/auth_remote_datasource.dart';
import 'package:mindease_app/src/data/repositories/auth_repository_impl.dart';
import 'package:mindease_app/src/domain/usecases/auth/get_auth_state_usecase.dart';
import 'package:mindease_app/src/domain/usecases/auth/sign_in_with_google_usecase.dart';
import 'package:mindease_app/src/domain/usecases/auth/sign_out_usecase.dart';

final AuthRepositoryImpl authRepository = AuthRepositoryImpl(remote: AuthRemoteDataSource());
final GetAuthStateUseCase getAuthStateUseCase = GetAuthStateUseCase(authRepository);
final SignInWithGoogleUseCase signInWithGoogleUseCase = SignInWithGoogleUseCase(authRepository);
final SignOutUseCase signOutUseCase = SignOutUseCase(authRepository);
