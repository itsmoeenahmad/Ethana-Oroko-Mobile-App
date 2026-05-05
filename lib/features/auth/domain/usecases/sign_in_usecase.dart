import 'package:etanaorokoapp/core/errors/app_failures.dart';
import '../entities/user_entity.dart';
import '../repositories/auth_repository.dart';

class SignInUseCase {
  final AuthRepository _repository;

  const SignInUseCase(this._repository);

  Future<UserEntity> call(String email, String password) async {
    if (email.trim().isEmpty) {
      throw const ValidationFailure(message: 'Email cannot be empty.');
    }
    if (password.isEmpty) {
      throw const ValidationFailure(message: 'Password cannot be empty.');
    }

    return _repository.signInWithEmailAndPassword(
      email.trim(),
      password,
    );
  }
}
