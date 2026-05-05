import '../entities/post_entity.dart';
import '../entities/comment_entity.dart';

/// Contract for all feed-related operations.
///
/// Implemented by the data layer; consumed by use cases only.
abstract class FeedRepository {
  /// Fetch paginated posts, ordered by createdAt descending.
  /// Returns list of posts with [PostEntity.isLiked] set for the current user.
  Future<List<PostEntity>> getPosts({int limit = 20, PostEntity? lastPost});

  /// Create a new post. Returns the created [PostEntity].
  Future<PostEntity> createPost(String content);

  /// Toggle like on a post. Returns the updated [PostEntity].
  Future<PostEntity> toggleLike(String postId, bool isCurrentlyLiked);

  /// Get comments for a post, ordered by createdAt ascending.
  Future<List<CommentEntity>> getComments(String postId);

  /// Add a comment to a post. Returns the created [CommentEntity].
  Future<CommentEntity> addComment(String postId, String content);

  /// Get posts by a specific user.
  Future<List<PostEntity>> getUserPosts(String userId);
}
