import '../entities/post_entity.dart';
import '../repositories/feed_repository.dart';

class GetUserPostsUseCase {
  final FeedRepository _repository;

  GetUserPostsUseCase(this._repository);

  Future<List<PostEntity>> call(String userId) {
    return _repository.getUserPosts(userId);
  }
}
