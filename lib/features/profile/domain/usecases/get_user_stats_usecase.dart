import '../repositories/profile_repository.dart';

class GetUserStatsUseCase {
  final ProfileRepository _repository;

  GetUserStatsUseCase(this._repository);

  Future<ProfileStats> call(String uid) {
    return _repository.getUserStats(uid);
  }
}
