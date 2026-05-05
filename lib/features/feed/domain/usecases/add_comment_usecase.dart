import 'package:etanaorokoapp/core/errors/app_failures.dart';

import '../entities/comment_entity.dart';
import '../repositories/feed_repository.dart';

class AddCommentUseCase {
  final FeedRepository _repository;

  AddCommentUseCase(this._repository);

  Future<CommentEntity> call(String postId, String content) {
    final trimmed = content.trim();

    if (trimmed.isEmpty) {
      throw const ValidationFailure(message: 'Comment cannot be empty.');
    }

    return _repository.addComment(postId, trimmed);
  }
}
