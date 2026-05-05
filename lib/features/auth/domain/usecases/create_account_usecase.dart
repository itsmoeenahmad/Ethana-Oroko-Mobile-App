import 'package:etanaorokoapp/core/errors/app_failures.dart';
import '../entities/user_entity.dart';
import '../repositories/auth_repository.dart';

class CreateAccountUseCase {
  final AuthRepository _repository;

  const CreateAccountUseCase(this._repository);

  Future<UserEntity> call(String name, String email, String password) async {
    if (name.trim().isEmpty) {
      throw const ValidationFailure(message: 'Name cannot be empty.');
    }
    if (email.trim().isEmpty) {
      throw const ValidationFailure(message: 'Email cannot be empty.');
    }
    if (password.isEmpty) {
      throw const ValidationFailure(message: 'Password cannot be empty.');
    }

    return _repository.createAccount(
      name.trim(),
      email.trim(),
      password,
    );
  }
}
