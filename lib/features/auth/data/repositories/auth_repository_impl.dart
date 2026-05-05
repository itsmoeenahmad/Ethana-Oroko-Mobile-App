import 'package:firebase_auth/firebase_auth.dart';

import 'package:etanaorokoapp/core/errors/app_failures.dart';
import 'package:etanaorokoapp/core/services/logger/logger_service.dart';
import 'package:etanaorokoapp/core/services/network/network_service.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_data_source.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _remoteDataSource;
  final NetworkService _networkService;
  final LoggerService _logger;

  AuthRepositoryImpl(
    this._remoteDataSource,
    this._networkService,
  ) : _logger = LoggerService(className: 'AuthRepositoryImpl');

  @override
  Stream<UserEntity?> get authStateChanges => _remoteDataSource.authStateChanges;

  @override
  Future<UserEntity?> get currentUser async => _remoteDataSource.currentUser;

  @override
  Future<UserEntity> signInWithEmailAndPassword(
    String email,
    String password,
  ) async {
    await _checkNetwork();
    try {
      _logger.info('Signing in with email: $email');
      final user = await _remoteDataSource.signInWithEmailAndPassword(
        email,
        password,
      );
      _logger.success('Sign-in successful for uid: ${user.uid}');
      return user;
    } on FirebaseAuthException catch (e) {
      _logger.error('Sign-in failed: ${e.code}', error: e);
      throw AuthFailure.fromCode(e.code);
    } on Failure {
      rethrow;
    } catch (e, st) {
      _logger.error('Unexpected sign-in error', error: e, stackTrace: st);
      throw const ServerFailure(message: 'Something went wrong. Please try again.');
    }
  }

  @override
  Future<UserEntity> signInWithGoogle() async {
    await _checkNetwork();
    try {
      _logger.info('Signing in with Google');
      final user = await _remoteDataSource.signInWithGoogle();
      _logger.success('Google sign-in successful for uid: ${user.uid}');
      return user;
    } on FirebaseAuthException catch (e) {
      _logger.error('Google sign-in failed: ${e.code}', error: e);
      throw AuthFailure.fromCode(e.code);
    } on Failure {
      rethrow;
    } catch (e, st) {
      _logger.error('Unexpected Google sign-in error', error: e, stackTrace: st);
      throw const ServerFailure(message: 'Something went wrong. Please try again.');
    }
  }

  @override
  Future<UserEntity> createAccount(
    String name,
    String email,
    String password,
  ) async {
    await _checkNetwork();
    try {
      _logger.info('Creating account for: $email');
      final user = await _remoteDataSource.createAccount(name, email, password);
      _logger.success('Account created for uid: ${user.uid}');
      return user;
    } on FirebaseAuthException catch (e) {
      _logger.error('Account creation failed: ${e.code}', error: e);
      throw AuthFailure.fromCode(e.code);
    } on Failure {
      rethrow;
    } catch (e, st) {
      _logger.error('Unexpected account creation error', error: e, stackTrace: st);
      throw const ServerFailure(message: 'Something went wrong. Please try again.');
    }
  }

  @override
  Future<void> signOut() async {
    try {
      _logger.info('Signing out');
      await _remoteDataSource.signOut();
      _logger.success('Sign-out successful');
    } catch (e, st) {
      _logger.error('Sign-out failed', error: e, stackTrace: st);
      throw const ServerFailure(message: 'Failed to sign out. Please try again.');
    }
  }

  Future<void> _checkNetwork() async {
    if (!await _networkService.isConnected) {
      _logger.warning('No network connection');
      throw const NetworkFailure();
    }
  }
}
