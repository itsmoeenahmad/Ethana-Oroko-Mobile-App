import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:etanaorokoapp/core/errors/app_failures.dart';
import 'package:etanaorokoapp/core/services/logger/logger_service.dart';
import 'package:etanaorokoapp/core/services/network/network_service.dart';
import 'package:etanaorokoapp/core/services/firebase/firebase_auth_service.dart';
import '../../domain/entities/profile_entity.dart';
import '../../domain/repositories/profile_repository.dart';
import '../datasources/profile_remote_data_source.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileRemoteDataSource _remoteDataSource;
  final FirebaseAuthService _authService;
  final NetworkService _networkService;
  final LoggerService _logger;

  ProfileRepositoryImpl(
    this._remoteDataSource,
    this._authService,
    this._networkService,
  ) : _logger = LoggerService(className: 'ProfileRepositoryImpl');

  @override
  Future<ProfileEntity> getUserProfile(String uid) async {
    await _checkNetwork();
    try {
      _logger.info('Fetching profile for uid: $uid');
      final profile = await _remoteDataSource.getUserProfile(uid);
      _logger.success('Profile fetched for uid: $uid');
      return profile;
    } on Failure {
      rethrow;
    } on FirebaseException catch (e) {
      _logger.error('Firestore error fetching profile: ${e.code}', error: e);
      throw ServerFailure.fromCode(e.code);
    } catch (e, st) {
      _logger.error('Unexpected error fetching profile', error: e, stackTrace: st);
      throw const ServerFailure(
        message: 'Something went wrong. Please try again.',
      );
    }
  }

  @override
  Future<ProfileEntity> getCurrentUserProfile() async {
    final user = _authService.currentUser;
    if (user == null) {
      throw const AuthFailure(
        message: 'You must be logged in to view your profile.',
      );
    }
    return getUserProfile(user.uid);
  }

  @override
  Future<ProfileStats> getUserStats(String uid) async {
    await _checkNetwork();
    try {
      _logger.info('Fetching stats for uid: $uid');
      final stats = await _remoteDataSource.getUserStats(uid);
      _logger.success(
        'Stats fetched for uid: $uid '
        '(posts: ${stats.totalPosts}, likes: ${stats.totalLikes}, '
        'comments: ${stats.totalComments})',
      );
      return stats;
    } on Failure {
      rethrow;
    } on FirebaseException catch (e) {
      _logger.error('Firestore error fetching stats: ${e.code}', error: e);
      throw ServerFailure.fromCode(e.code);
    } catch (e, st) {
      _logger.error('Unexpected error fetching stats', error: e, stackTrace: st);
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
