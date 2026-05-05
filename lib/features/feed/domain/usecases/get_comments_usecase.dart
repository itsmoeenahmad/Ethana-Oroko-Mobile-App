import '../entities/comment_entity.dart';
import '../repositories/feed_repository.dart';

class GetCommentsUseCase {
  final FeedRepository _repository;

  GetCommentsUseCase(this._repository);

  Future<List<CommentEntity>> call(String postId) {
    return _repository.getComments(postId);
  }
}
