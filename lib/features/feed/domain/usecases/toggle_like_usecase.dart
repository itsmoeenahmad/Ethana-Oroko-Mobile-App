import '../entities/post_entity.dart';
import '../repositories/feed_repository.dart';

class ToggleLikeUseCase {
  final FeedRepository _repository;

  ToggleLikeUseCase(this._repository);

  Future<PostEntity> call(String postId, bool isCurrentlyLiked) {
    return _repository.toggleLike(postId, isCurrentlyLiked);
  }
}
