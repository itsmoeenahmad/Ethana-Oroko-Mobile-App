import 'package:flutter/material.dart';
import '../../domain/usecases/create_account_usecase.dart';
import 'package:etanaorokoapp/core/errors/app_failures.dart';
import 'package:etanaorokoapp/core/services/logger/logger_service.dart';

class CreateAccountProvider extends ChangeNotifier {
  final CreateAccountUseCase _createAccountUseCase;
  final _logger = LoggerService(className: 'CreateAccountProvider');

  CreateAccountProvider(this._createAccountUseCase);

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

  Future<void> createAccount({
    required String name,
    required String email,
    required String password,
  }) async {
    _isLoading = true;
    _isSuccess = false;
    _errorMessage = null;
    notifyListeners();

    try {
      _logger.provider('Create account attempted', tag: 'createAccount');
      await _createAccountUseCase(name, email, password);
      _isSuccess = true;
      _logger.success('Account created successfully');
    } on Failure catch (e) {
      _errorMessage = e.message;
      _logger.error(
        'Create account failed: ${e.message}',
        tag: 'createAccount',
      );
    } catch (e, st) {
      _errorMessage = 'Something went wrong. Please try again.';
      _logger.error(
        'Create account failed',
        tag: 'createAccount',
        error: e,
        stackTrace: st,
      );
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
