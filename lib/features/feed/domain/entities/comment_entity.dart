/// Represents a single comment on a post.
///
/// Fields mirror the Firestore `posts/{postId}/comments/{commentId}` schema.
class CommentEntity {
  final String id;
  final String postId;
  final String userId;
  final String userName;
  final String? userPhotoUrl;
  final String content;
  final DateTime createdAt;

  const CommentEntity({
    required this.id,
    required this.postId,
    required this.userId,
    required this.userName,
    this.userPhotoUrl,
    required this.content,
    required this.createdAt,
  });
}
