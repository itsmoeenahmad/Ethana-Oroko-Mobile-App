import '../entities/profile_entity.dart';
import '../repositories/profile_repository.dart';

class GetCurrentProfileUseCase {
  final ProfileRepository _repository;

  GetCurrentProfileUseCase(this._repository);

  Future<ProfileEntity> call() {
    return _repository.getCurrentUserProfile();
  }
}
