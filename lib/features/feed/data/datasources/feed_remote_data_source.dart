import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:etanaorokoapp/core/services/firebase/firestore_service.dart';
import '../models/post_model.dart';
import '../models/comment_model.dart';

abstract class FeedRemoteDataSource {
  Future<List<PostModel>> getPosts({
    int limit,
    DocumentSnapshot? lastDocument,
  });
  Future<PostModel> createPost(
    String content,
    String userId,
    String userName,
    String? userPhotoUrl,
  );
  Future<void> addLike(String postId, String userId);
  Future<void> removeLike(String postId, String userId);
  Future<bool> hasUserLiked(String postId, String userId);
  Future<List<CommentModel>> getComments(String postId);
  Future<CommentModel> addComment(
    String postId,
    String content,
    String userId,
    String userName,
    String? userPhotoUrl,
  );
  Future<List<PostModel>> getUserPosts(String userId);
}

class FeedRemoteDataSourceImpl implements FeedRemoteDataSource {
  final FirestoreService _firestoreService;

  FeedRemoteDataSourceImpl(this._firestoreService);

  @override
  Future<List<PostModel>> getPosts({
    int limit = 20,
    DocumentSnapshot? lastDocument,
  }) async {
    Query<Map<String, dynamic>> query = _firestoreService.postsCollection
        .orderBy('createdAt', descending: true)
        .limit(limit);

    if (lastDocument != null) {
      query = query.startAfterDocument(lastDocument);
    }

    final snapshot = await query.get();
    return snapshot.docs
        .map((doc) => PostModel.fromFirestore(doc))
        .toList();
  }

  @override
  Future<PostModel> createPost(
    String content,
    String userId,
    String userName,
    String? userPhotoUrl,
  ) async {
    final docRef = _firestoreService.postsCollection.doc();
    final postData = {
      'id': docRef.id,
      'userId': userId,
      'userName': userName,
      'userPhotoUrl': userPhotoUrl,
      'content': content,
      'likesCount': 0,
      'commentsCount': 0,
      'createdAt': FieldValue.serverTimestamp(),
    };

    await docRef.set(postData);

    // Read back to get the server timestamp resolved
    final doc = await docRef.get();
    return PostModel.fromFirestore(doc);
  }

  @override
  Future<void> addLike(String postId, String userId) async {
    final batch = _firestoreService.firestore.batch();

    final likeRef =
        _firestoreService.likesCollection(postId).doc(userId);
    batch.set(likeRef, {
      'userId': userId,
      'createdAt': FieldValue.serverTimestamp(),
    });

    final postRef = _firestoreService.postsCollection.doc(postId);
    batch.update(postRef, {'likesCount': FieldValue.increment(1)});

    await batch.commit();
  }

  @override
  Future<void> removeLike(String postId, String userId) async {
    final batch = _firestoreService.firestore.batch();

    final likeRef =
        _firestoreService.likesCollection(postId).doc(userId);
    batch.delete(likeRef);

    final postRef = _firestoreService.postsCollection.doc(postId);
    batch.update(postRef, {'likesCount': FieldValue.increment(-1)});

    await batch.commit();
  }

  @override
  Future<bool> hasUserLiked(String postId, String userId) async {
    final doc = await _firestoreService
        .likesCollection(postId)
        .doc(userId)
        .get();
    return doc.exists;
  }

  @override
  Future<List<CommentModel>> getComments(String postId) async {
    final snapshot = await _firestoreService
        .commentsCollection(postId)
        .orderBy('createdAt')
        .get();

    return snapshot.docs
        .map((doc) => CommentModel.fromFirestore(doc, postId))
        .toList();
  }

  @override
  Future<CommentModel> addComment(
    String postId,
    String content,
    String userId,
    String userName,
    String? userPhotoUrl,
  ) async {
    final batch = _firestoreService.firestore.batch();

    final commentRef = _firestoreService.commentsCollection(postId).doc();
    final commentData = {
      'id': commentRef.id,
      'userId': userId,
      'userName': userName,
      'userPhotoUrl': userPhotoUrl,
      'content': content,
      'createdAt': FieldValue.serverTimestamp(),
    };
    batch.set(commentRef, commentData);

    final postRef = _firestoreService.postsCollection.doc(postId);
    batch.update(postRef, {'commentsCount': FieldValue.increment(1)});

    await batch.commit();

    // Return constructed model directly — reading back after batch commit
    // is unreliable because the server timestamp may not have resolved yet.
    return CommentModel(
      id: commentRef.id,
      postId: postId,
      userId: userId,
      userName: userName,
      userPhotoUrl: userPhotoUrl,
      content: content,
      createdAt: DateTime.now(),
    );
  }

  @override
  Future<List<PostModel>> getUserPosts(String userId) async {
    final snapshot = await _firestoreService.postsCollection
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .get();

    return snapshot.docs
        .map((doc) => PostModel.fromFirestore(doc))
        .toList();
  }
}
