import 'package:flutter/material.dart';
import '../../domain/usecases/sign_in_usecase.dart';
import 'package:etanaorokoapp/core/errors/app_failures.dart';
import '../../domain/usecases/sign_in_with_google_usecase.dart';
import 'package:etanaorokoapp/core/services/logger/logger_service.dart';

class LoginProvider extends ChangeNotifier {
  final SignInUseCase _signInUseCase;
  final SignInWithGoogleUseCase _signInWithGoogleUseCase;
  final _logger = LoggerService(className: 'LoginProvider');

  LoginProvider(this._signInUseCase, this._signInWithGoogleUseCase);

  bool _isLoading = false;
  bool _isSuccess = false;
  String? _errorMessage;

  bool get isLoading => _isLoading;
  bool get isSuccess => _isSuccess;
  String? get errorMessage => _errorMessage;

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  Future<void> signIn({required String email, required String password}) async {
    _isLoading = true;
    _isSuccess = false;
    _errorMessage = null;
    notifyListeners();

    try {
      _logger.provider('Sign in attempted', tag: 'signIn');
      await _signInUseCase(email, password);
      _isSuccess = true;
      _logger.success('Sign in successful');
    } on Failure catch (e) {
      _errorMessage = e.message;
      _logger.error('Sign in failed: ${e.message}', tag: 'signIn');
    } catch (e, st) {
      _errorMessage = 'Something went wrong. Please try again.';
      _logger.error('Sign in failed', tag: 'signIn', error: e, stackTrace: st);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> signInWithGoogle() async {
    _isLoading = true;
    _isSuccess = false;
    _errorMessage = null;
    notifyListeners();

    try {
      _logger.provider('Google sign-in attempted', tag: 'signInWithGoogle');
      await _signInWithGoogleUseCase();
      _isSuccess = true;
      _logger.success('Google sign-in successful');
    } on Failure catch (e) {
      // Don't show error for user-initiated cancellation
      if (e.code == 'sign_in_canceled') {
        _logger.info('Google sign-in cancelled by user');
      } else {
        _errorMessage = e.message;
        _logger.error(
          'Google sign-in failed: ${e.message}',
          tag: 'signInWithGoogle',
        );
      }
    } catch (e, st) {
      _errorMessage = 'Something went wrong. Please try again.';
      _logger.error(
        'Google sign-in failed',
        tag: 'signInWithGoogle',
        error: e,
        stackTrace: st,
      );
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
