import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:etanaorokoapp/core/errors/app_failures.dart';
import 'package:etanaorokoapp/core/services/logger/logger_service.dart';
import 'package:etanaorokoapp/core/services/network/network_service.dart';
import 'package:etanaorokoapp/core/services/firebase/firebase_auth_service.dart';
import '../../domain/entities/post_entity.dart';
import '../../domain/entities/comment_entity.dart';
import '../../domain/repositories/feed_repository.dart';
import '../datasources/feed_remote_data_source.dart';
import '../models/post_model.dart';

class FeedRepositoryImpl implements FeedRepository {
  final FeedRemoteDataSource _remoteDataSource;
  final FirebaseAuthService _authService;
  final NetworkService _networkService;
  final LoggerService _logger;

  FeedRepositoryImpl(
    this._remoteDataSource,
    this._authService,
    this._networkService,
  ) : _logger = LoggerService(className: 'FeedRepositoryImpl');

  @override
  Future<List<PostEntity>> getPosts({
    int limit = 20,
    PostEntity? lastPost,
  }) async {
    await _checkNetwork();
    try {
      _logger.info('Fetching posts (limit: $limit)');
      final posts = await _remoteDataSource.getPosts(limit: limit);

      final currentUid = _authService.currentUser?.uid;
      if (currentUid == null) {
        return posts;
      }

      // Check like status for each post
      final postsWithLikes = <PostModel>[];
      for (final post in posts) {
        final liked =
            await _remoteDataSource.hasUserLiked(post.id, currentUid);
        postsWithLikes.add(post.copyWithLiked(liked));
      }

      _logger.success('Fetched ${postsWithLikes.length} posts');
      return postsWithLikes;
    } on Failure {
      rethrow;
    } on FirebaseException catch (e) {
      _logger.error('Firestore error fetching posts: ${e.code}', error: e);
      throw ServerFailure.fromCode(e.code);
    } catch (e, st) {
      _logger.error('Unexpected error fetching posts', error: e, stackTrace: st);
      throw const ServerFailure(
        message: 'Something went wrong. Please try again.',
      );
    }
  }

  @override
  Future<PostEntity> createPost(String content) async {
    await _checkNetwork();
    try {
      final user = _authService.currentUser;
      if (user == null) {
        throw const AuthFailure(message: 'You must be logged in to post.');
      }

      _logger.info('Creating post for uid: ${user.uid}');
      final post = await _remoteDataSource.createPost(
        content,
        user.uid,
        user.displayName ?? '',
        user.photoURL,
      );
      _logger.success('Post created: ${post.id}');
      return post;
    } on Failure {
      rethrow;
    } on FirebaseException catch (e) {
      _logger.error('Firestore error creating post: ${e.code}', error: e);
      throw ServerFailure.fromCode(e.code);
    } catch (e, st) {
      _logger.error('Unexpected error creating post', error: e, stackTrace: st);
      throw const ServerFailure(
        message: 'Something went wrong. Please try again.',
      );
    }
  }

  @override
  Future<PostEntity> toggleLike(String postId, bool isCurrentlyLiked) async {
    await _checkNetwork();
    try {
      final currentUid = _authService.currentUser?.uid;
      if (currentUid == null) {
        throw const AuthFailure(message: 'You must be logged in to like posts.');
      }

      _logger.info(
        '${isCurrentlyLiked ? "Removing" : "Adding"} like on post: $postId',
      );

      if (isCurrentlyLiked) {
        await _remoteDataSource.removeLike(postId, currentUid);
      } else {
        await _remoteDataSource.addLike(postId, currentUid);
      }

      // Read back the updated post
      final posts = await _remoteDataSource.getPosts(limit: 1);
      final updatedDoc = await _remoteDataSource.hasUserLiked(postId, currentUid);

      // Find the post we just updated from a fresh read
      for (final post in posts) {
        if (post.id == postId) {
          return post.copyWithLiked(updatedDoc);
        }
      }

      // Fallback: return a minimal representation
      _logger.warning('Post $postId not found after like toggle, refetching');
      final allPosts = await getPosts();
      return allPosts.firstWhere((p) => p.id == postId);
    } on Failure {
      rethrow;
    } on FirebaseException catch (e) {
      _logger.error('Firestore error toggling like: ${e.code}', error: e);
      throw ServerFailure.fromCode(e.code);
    } catch (e, st) {
      _logger.error('Unexpected error toggling like', error: e, stackTrace: st);
      throw const ServerFailure(
        message: 'Something went wrong. Please try again.',
      );
    }
  }

  @override
  Future<List<CommentEntity>> getComments(String postId) async {
    await _checkNetwork();
    try {
      _logger.info('Fetching comments for post: $postId');
      final comments = await _remoteDataSource.getComments(postId);
      _logger.success('Fetched ${comments.length} comments');
      return comments;
    } on Failure {
      rethrow;
    } on FirebaseException catch (e) {
      _logger.error('Firestore error fetching comments: ${e.code}', error: e);
      throw ServerFailure.fromCode(e.code);
    } catch (e, st) {
      _logger.error(
        'Unexpected error fetching comments',
        error: e,
        stackTrace: st,
      );
      throw const ServerFailure(
        message: 'Something went wrong. Please try again.',
      );
    }
  }

  @override
  Future<CommentEntity> addComment(String postId, String content) async {
    await _checkNetwork();
    try {
      final user = _authService.currentUser;
      if (user == null) {
        throw const AuthFailure(message: 'You must be logged in to comment.');
      }

      _logger.info('Adding comment to post: $postId');
      final comment = await _remoteDataSource.addComment(
        postId,
        content,
        user.uid,
        user.displayName ?? '',
        user.photoURL,
      );
      _logger.success('Comment added: ${comment.id}');
      return comment;
    } on Failure {
      rethrow;
    } on FirebaseException catch (e) {
      _logger.error('Firestore error adding comment: ${e.code}', error: e);
      throw ServerFailure.fromCode(e.code);
    } catch (e, st) {
      _logger.error(
        'Unexpected error adding comment',
        error: e,
        stackTrace: st,
      );
      throw const ServerFailure(
        message: 'Something went wrong. Please try again.',
      );
    }
  }

  @override
  Future<List<PostEntity>> getUserPosts(String userId) async {
    await _checkNetwork();
    try {
      _logger.info('Fetching posts for user: $userId');
      final posts = await _remoteDataSource.getUserPosts(userId);

      final currentUid = _authService.currentUser?.uid;
      if (currentUid == null) {
        return posts;
      }

      final postsWithLikes = <PostModel>[];
      for (final post in posts) {
        final liked =
            await _remoteDataSource.hasUserLiked(post.id, currentUid);
        postsWithLikes.add(post.copyWithLiked(liked));
      }

      _logger.success('Fetched ${postsWithLikes.length} posts for user: $userId');
      return postsWithLikes;
    } on Failure {
      rethrow;
    } on FirebaseException catch (e) {
      _logger.error(
        'Firestore error fetching user posts: ${e.code}',
        error: e,
      );
      throw ServerFailure.fromCode(e.code);
    } catch (e, st) {
      _logger.error(
        'Unexpected error fetching user posts',
        error: e,
        stackTrace: st,
      );
      throw const ServerFailure(
        message: 'Something went wrong. Please try again.',
      );
    }
  }

  Future<void> _checkNetwork() async {
    if (!await _networkService.isConnected) {
      _logger.warning('No network connection');
      throw const NetworkFailure();
    }
  }
}
