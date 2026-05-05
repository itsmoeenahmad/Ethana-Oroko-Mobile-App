import 'package:get_it/get_it.dart';
import 'domain/usecases/get_profile_usecase.dart';
import 'domain/repositories/profile_repository.dart';
import 'domain/usecases/get_user_stats_usecase.dart';
import 'presentation/providers/profile_provider.dart';
import 'data/repositories/profile_repository_impl.dart';
import 'domain/usecases/get_current_profile_usecase.dart';
import 'data/datasources/profile_remote_data_source.dart';

class ProfileDi {
  static void init(GetIt di) {
    // --- Data Sources ---
    di.registerLazySingleton<ProfileRemoteDataSource>(
      () => ProfileRemoteDataSourceImpl(di()),
    );

    // --- Repositories ---
    di.registerLazySingleton<ProfileRepository>(
      () => ProfileRepositoryImpl(di(), di(), di()),
    );

    // --- Use Cases ---
    di.registerLazySingleton(() => GetProfileUseCase(di()));
    di.registerLazySingleton(() => GetCurrentProfileUseCase(di()));
    di.registerLazySingleton(() => GetUserStatsUseCase(di()));

    // --- Providers ---
    di.registerFactory(() => ProfileProvider(di(), di(), di(), di()));
  }
}
