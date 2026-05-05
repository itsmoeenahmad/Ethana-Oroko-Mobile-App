import 'package:get_it/get_it.dart';
import 'domain/usecases/sign_in_usecase.dart';
import 'domain/usecases/sign_out_usecase.dart';
import 'domain/repositories/auth_repository.dart';
import 'presentation/providers/login_provider.dart';
import 'data/repositories/auth_repository_impl.dart';
import 'domain/usecases/create_account_usecase.dart';
import 'domain/usecases/get_auth_state_usecase.dart';
import 'data/datasources/auth_remote_data_source.dart';
import 'domain/usecases/sign_in_with_google_usecase.dart';
import 'presentation/providers/create_account_provider.dart';

class AuthDi {
  static void init(GetIt di) {
    // --- Data Sources ---
    di.registerLazySingleton<AuthRemoteDataSource>(
      () => AuthRemoteDataSourceImpl(di(), di()),
    );

    // --- Repositories ---
    di.registerLazySingleton<AuthRepository>(
      () => AuthRepositoryImpl(di(), di()),
    );

    // --- Use Cases ---
    di.registerLazySingleton(() => SignInUseCase(di()));
    di.registerLazySingleton(() => SignInWithGoogleUseCase(di()));
    di.registerLazySingleton(() => CreateAccountUseCase(di()));
    di.registerLazySingleton(() => SignOutUseCase(di()));
    di.registerLazySingleton(() => GetAuthStateUseCase(di()));

    // --- Providers ---
    di.registerFactory(() => LoginProvider(di(), di()));
    di.registerFactory(() => CreateAccountProvider(di()));
  }
}
