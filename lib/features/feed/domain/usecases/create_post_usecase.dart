import 'package:etanaorokoapp/core/errors/app_failures.dart';

import '../entities/post_entity.dart';
import '../repositories/feed_repository.dart';

class CreatePostUseCase {
  final FeedRepository _repository;

  CreatePostUseCase(this._repository);

  static const int maxContentLength = 2000;

  Future<PostEntity> call(String content) {
    final trimmed = content.trim();

    if (trimmed.isEmpty) {
      throw const ValidationFailure(message: 'Post content cannot be empty.');
    }
    if (trimmed.length > maxContentLength) {
      throw const ValidationFailure(
        message: 'Post content is too long. Maximum 2000 characters.',
      );
    }

    return _repository.createPost(trimmed);
  }
}
