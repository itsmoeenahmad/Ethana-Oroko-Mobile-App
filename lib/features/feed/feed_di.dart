import 'package:get_it/get_it.dart';
import 'domain/usecases/get_posts_usecase.dart';
import 'domain/repositories/feed_repository.dart';
import 'domain/usecases/create_post_usecase.dart';
import 'domain/usecases/toggle_like_usecase.dart';
import 'domain/usecases/add_comment_usecase.dart';
import 'domain/usecases/get_comments_usecase.dart';
import 'presentation/providers/feed_provider.dart';
import 'domain/usecases/get_user_posts_usecase.dart';
import 'data/repositories/feed_repository_impl.dart';
import 'data/datasources/feed_remote_data_source.dart';

class FeedDi {
  static void init(GetIt di) {
    // --- Data Sources ---
    di.registerLazySingleton<FeedRemoteDataSource>(
      () => FeedRemoteDataSourceImpl(di()),
    );

    // --- Repositories ---
    di.registerLazySingleton<FeedRepository>(
      () => FeedRepositoryImpl(di(), di(), di()),
    );

    // --- Use Cases ---
    di.registerLazySingleton(() => GetPostsUseCase(di()));
    di.registerLazySingleton(() => CreatePostUseCase(di()));
    di.registerLazySingleton(() => ToggleLikeUseCase(di()));
    di.registerLazySingleton(() => GetCommentsUseCase(di()));
    di.registerLazySingleton(() => AddCommentUseCase(di()));
    di.registerLazySingleton(() => GetUserPostsUseCase(di()));

    // --- Providers ---
    di.registerFactory(() => FeedProvider(di(), di(), di(), di(), di()));
  }
}
