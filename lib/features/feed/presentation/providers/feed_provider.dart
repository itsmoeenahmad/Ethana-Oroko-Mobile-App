import 'package:flutter/foundation.dart';
import 'package:etanaorokoapp/core/errors/app_failures.dart';
import 'package:etanaorokoapp/core/services/logger/logger_service.dart';
import 'package:etanaorokoapp/features/feed/domain/entities/post_entity.dart';
import 'package:etanaorokoapp/features/feed/domain/entities/comment_entity.dart';
import 'package:etanaorokoapp/features/feed/domain/usecases/get_posts_usecase.dart';
import 'package:etanaorokoapp/features/feed/domain/usecases/create_post_usecase.dart';
import 'package:etanaorokoapp/features/feed/domain/usecases/toggle_like_usecase.dart';
import 'package:etanaorokoapp/features/feed/domain/usecases/add_comment_usecase.dart';
import 'package:etanaorokoapp/features/feed/domain/usecases/get_comments_usecase.dart';
import 'package:etanaorokoapp/features/feed/data/models/post_model.dart';

class FeedProvider extends ChangeNotifier {
  final GetPostsUseCase _getPostsUseCase;
  final CreatePostUseCase _createPostUseCase;
  final ToggleLikeUseCase _toggleLikeUseCase;
  final GetCommentsUseCase _getCommentsUseCase;
  final AddCommentUseCase _addCommentUseCase;
  final _logger = LoggerService(className: 'FeedProvider');

  FeedProvider(
    this._getPostsUseCase,
    this._createPostUseCase,
    this._toggleLikeUseCase,
    this._getCommentsUseCase,
    this._addCommentUseCase,
  );

  List<PostEntity> _posts = [];
  bool _isLoading = false;
  bool _isCreatingPost = false;
  String? _errorMessage;

  List<PostEntity> get posts => _posts;
  bool get isLoading => _isLoading;
  bool get isCreatingPost => _isCreatingPost;
  String? get errorMessage => _errorMessage;

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  Future<void> loadPosts() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _logger.provider('Loading posts', tag: 'loadPosts');
      _posts = await _getPostsUseCase(limit: 20);
      _logger.success('Loaded ${_posts.length} posts');
    } on Failure catch (e) {
      _errorMessage = e.message;
      _logger.error('Failed to load posts: ${e.message}', tag: 'loadPosts');
    } catch (e, st) {
      _errorMessage = 'Something went wrong. Please try again.';
      _logger.error(
        'Failed to load posts',
        tag: 'loadPosts',
        error: e,
        stackTrace: st,
      );
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> createPost(String content) async {
    _isCreatingPost = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _logger.provider('Creating post', tag: 'createPost');
      final post = await _createPostUseCase(content);
      _posts.insert(0, post);
      _logger.success('Post created: ${post.id}');
    } on Failure catch (e) {
      _errorMessage = e.message;
      _logger.error('Failed to create post: ${e.message}', tag: 'createPost');
    } catch (e, st) {
      _errorMessage = 'Something went wrong. Please try again.';
      _logger.error(
        'Failed to create post',
        tag: 'createPost',
        error: e,
        stackTrace: st,
      );
    } finally {
      _isCreatingPost = false;
      notifyListeners();
    }
  }

  Future<void> toggleLike(String postId) async {
    final index = _posts.indexWhere((p) => p.id == postId);
    if (index == -1) return;

    final post = _posts[index];
    final wasLiked = post.isLiked;

    // Optimistic UI update — wrap in PostModel to maintain list type consistency
    final optimistic = PostModel.fromEntity(post.copyWith(
      isLiked: !wasLiked,
      likesCount: wasLiked ? post.likesCount - 1 : post.likesCount + 1,
    ));
    _posts[index] = optimistic;
    notifyListeners();

    try {
      _logger.provider('Toggling like on post: $postId', tag: 'toggleLike');
      final updated = await _toggleLikeUseCase(postId, wasLiked);
      // Replace with server-confirmed state
      final currentIndex = _posts.indexWhere((p) => p.id == postId);
      if (currentIndex != -1) {
        _posts[currentIndex] = updated;
        notifyListeners();
      }
    } on Failure catch (e) {
      // Revert optimistic update
      final revertIndex = _posts.indexWhere((p) => p.id == postId);
      if (revertIndex != -1) {
        _posts[revertIndex] = post;
        notifyListeners();
      }
      _errorMessage = e.message;
      _logger.error('Failed to toggle like: ${e.message}', tag: 'toggleLike');
    } catch (e, st) {
      // Revert optimistic update
      final revertIndex = _posts.indexWhere((p) => p.id == postId);
      if (revertIndex != -1) {
        _posts[revertIndex] = post;
        notifyListeners();
      }
      _errorMessage = 'Something went wrong. Please try again.';
      _logger.error(
        'Failed to toggle like',
        tag: 'toggleLike',
        error: e,
        stackTrace: st,
      );
    }
  }

  Future<void> refreshPosts() async {
    _posts = [];
    await loadPosts();
  }

  Future<List<CommentEntity>> getComments(String postId) async {
    try {
      _logger.provider(
        'Fetching comments for post: $postId',
        tag: 'getComments',
      );
      final comments = await _getCommentsUseCase(postId);
      _logger.success('Fetched ${comments.length} comments');
      return comments;
    } on Failure catch (e) {
      _logger.error(
        'Failed to fetch comments: ${e.message}',
        tag: 'getComments',
      );
      rethrow;
    } catch (e, st) {
      _logger.error(
        'Failed to fetch comments',
        tag: 'getComments',
        error: e,
        stackTrace: st,
      );
      throw const ServerFailure(message: 'Failed to load comments.');
    }
  }

  Future<CommentEntity> addComment(String postId, String content) async {
    try {
      _logger.provider('Adding comment to post: $postId', tag: 'addComment');
      final comment = await _addCommentUseCase(postId, content);

      // Update commentsCount on the post in the local list
      final index = _posts.indexWhere((p) => p.id == postId);
      if (index != -1) {
        _posts[index] = PostModel.fromEntity(_posts[index].copyWith(
          commentsCount: _posts[index].commentsCount + 1,
        ));
        notifyListeners();
      }

      _logger.success('Comment added: ${comment.id}');
      return comment;
    } on Failure catch (e) {
      _logger.error('Failed to add comment: ${e.message}', tag: 'addComment');
      rethrow;
    } catch (e, st) {
      _logger.error(
        'Failed to add comment',
        tag: 'addComment',
        error: e,
        stackTrace: st,
      );
      throw const ServerFailure(message: 'Failed to add comment.');
    }
  }
}
