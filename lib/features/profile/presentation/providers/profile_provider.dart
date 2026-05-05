import 'package:flutter/foundation.dart';
import 'package:etanaorokoapp/core/errors/app_failures.dart';
import 'package:etanaorokoapp/core/services/logger/logger_service.dart';
import 'package:etanaorokoapp/features/feed/domain/entities/post_entity.dart';
import 'package:etanaorokoapp/features/profile/domain/entities/profile_entity.dart';
import 'package:etanaorokoapp/features/feed/domain/usecases/get_user_posts_usecase.dart';
import 'package:etanaorokoapp/features/profile/domain/usecases/get_profile_usecase.dart';
import 'package:etanaorokoapp/features/profile/domain/usecases/get_user_stats_usecase.dart';
import 'package:etanaorokoapp/features/profile/domain/repositories/profile_repository.dart';
import 'package:etanaorokoapp/features/profile/domain/usecases/get_current_profile_usecase.dart';

class ProfileProvider extends ChangeNotifier {
  final GetProfileUseCase _getProfileUseCase;
  final GetCurrentProfileUseCase _getCurrentProfileUseCase;
  final GetUserStatsUseCase _getUserStatsUseCase;
  final GetUserPostsUseCase _getUserPostsUseCase;
  final LoggerService _logger;

  ProfileProvider(
    this._getProfileUseCase,
    this._getCurrentProfileUseCase,
    this._getUserStatsUseCase,
    this._getUserPostsUseCase,
  ) : _logger = LoggerService(className: 'ProfileProvider');

  ProfileEntity? _profile;
  List<PostEntity> _userPosts = [];
  int _totalPosts = 0;
  int _totalLikes = 0;
  int _totalComments = 0;
  bool _isLoading = false;
  String? _errorMessage;

  ProfileEntity? get profile => _profile;
  List<PostEntity> get userPosts => _userPosts;
  int get totalPosts => _totalPosts;
  int get totalLikes => _totalLikes;
  int get totalComments => _totalComments;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  /// Load profile for a specific user, or the current user if no ID given.
  Future<void> loadProfile({String? userId, String? userName}) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // Step 1: Fetch profile document
      if (userId != null) {
        _profile = await _getProfileUseCase(userId);
      } else {
        _profile = await _getCurrentProfileUseCase();
      }
      _logger.success('Profile loaded for uid: ${_profile!.uid}');
    } on Failure catch (e) {
      _logger.error('Failed to load profile: ${e.message}', tag: 'loadProfile');
      _errorMessage = e.message;
      _isLoading = false;
      notifyListeners();
      return;
    } catch (e, st) {
      _logger.error('Unexpected error loading profile', tag: 'loadProfile', error: e, stackTrace: st);
      _errorMessage = 'Something went wrong. Please try again.';
      _isLoading = false;
      notifyListeners();
      return;
    }

    final uid = _profile!.uid;

    // Step 2: Fetch stats (independent — failure doesn't block posts)
    try {
      final ProfileStats stats = await _getUserStatsUseCase(uid);
      _totalPosts = stats.totalPosts;
      _totalLikes = stats.totalLikes;
      _totalComments = stats.totalComments;
      _logger.success('Stats loaded: posts=${stats.totalPosts}, likes=${stats.totalLikes}, comments=${stats.totalComments}');
    } on Failure catch (e) {
      _logger.error('Failed to load stats: ${e.message}', tag: 'loadProfile');
    } catch (e, st) {
      _logger.error('Unexpected error loading stats', tag: 'loadProfile', error: e, stackTrace: st);
    }

    // Step 3: Fetch user posts (independent — failure doesn't block stats)
    try {
      _userPosts = await _getUserPostsUseCase(uid);
      _logger.success('User posts loaded: ${_userPosts.length} posts');
    } on Failure catch (e) {
      _logger.error('Failed to load user posts: ${e.message}', tag: 'loadProfile');
    } catch (e, st) {
      _logger.error('Unexpected error loading user posts', tag: 'loadProfile', error: e, stackTrace: st);
    }

    _isLoading = false;
    notifyListeners();
  }
}
