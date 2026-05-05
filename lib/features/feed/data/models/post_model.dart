import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/entities/post_entity.dart';

class PostModel extends PostEntity {
  const PostModel({
    required super.id,
    required super.userId,
    required super.userName,
    super.userPhotoUrl,
    required super.content,
    required super.createdAt,
    super.updatedAt,
    super.likesCount,
    super.commentsCount,
    super.isLiked,
  });

  factory PostModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> doc, {
    bool isLiked = false,
  }) {
    final data = doc.data()!;
    return PostModel(
      id: data['id'] as String,
      userId: data['userId'] as String,
      userName: data['userName'] as String,
      userPhotoUrl: data['userPhotoUrl'] as String?,
      content: data['content'] as String,
      createdAt: data['createdAt'] != null
          ? (data['createdAt'] as Timestamp).toDate()
          : DateTime.now(),
      updatedAt: data['updatedAt'] != null
          ? (data['updatedAt'] as Timestamp).toDate()
          : null,
      likesCount: (data['likesCount'] as num?)?.toInt() ?? 0,
      commentsCount: (data['commentsCount'] as num?)?.toInt() ?? 0,
      isLiked: isLiked,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'id': id,
      'userId': userId,
      'userName': userName,
      'userPhotoUrl': userPhotoUrl,
      'content': content,
      'likesCount': likesCount,
      'commentsCount': commentsCount,
      'createdAt': FieldValue.serverTimestamp(),
    };
  }

  factory PostModel.fromEntity(PostEntity entity) {
    return PostModel(
      id: entity.id,
      userId: entity.userId,
      userName: entity.userName,
      userPhotoUrl: entity.userPhotoUrl,
      content: entity.content,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
      likesCount: entity.likesCount,
      commentsCount: entity.commentsCount,
      isLiked: entity.isLiked,
    );
  }

  PostModel copyWithLiked(bool liked) {
    return PostModel(
      id: id,
      userId: userId,
      userName: userName,
      userPhotoUrl: userPhotoUrl,
      content: content,
      createdAt: createdAt,
      updatedAt: updatedAt,
      likesCount: likesCount,
      commentsCount: commentsCount,
      isLiked: liked,
    );
  }
}
