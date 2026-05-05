import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/entities/comment_entity.dart';

class CommentModel extends CommentEntity {
  const CommentModel({
    required super.id,
    required super.postId,
    required super.userId,
    required super.userName,
    super.userPhotoUrl,
    required super.content,
    required super.createdAt,
  });

  factory CommentModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> doc,
    String postId,
  ) {
    final data = doc.data()!;
    return CommentModel(
      id: data['id'] as String? ?? doc.id,
      postId: postId,
      userId: data['userId'] as String,
      userName: data['userName'] as String,
      userPhotoUrl: data['userPhotoUrl'] as String?,
      content: data['content'] as String,
      createdAt: data['createdAt'] != null
          ? (data['createdAt'] as Timestamp).toDate()
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'id': id,
      'userId': userId,
      'userName': userName,
      'userPhotoUrl': userPhotoUrl,
      'content': content,
      'createdAt': FieldValue.serverTimestamp(),
    };
  }
}
