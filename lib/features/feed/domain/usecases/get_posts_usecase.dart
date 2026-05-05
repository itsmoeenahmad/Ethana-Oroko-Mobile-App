import '../entities/post_entity.dart';
import '../repositories/feed_repository.dart';

class GetPostsUseCase {
  final FeedRepository _repository;

  GetPostsUseCase(this._repository);

  Future<List<PostEntity>> call({int limit = 20, PostEntity? lastPost}) {
    return _repository.getPosts(limit: limit, lastPost: lastPost);
  }
}
