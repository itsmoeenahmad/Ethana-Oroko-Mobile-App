import '../entities/profile_entity.dart';

/// Activity stats for a user profile.
class ProfileStats {
  final int totalPosts;
  final int totalLikes;
  final int totalComments;

  const ProfileStats({
    this.totalPosts = 0,
    this.totalLikes = 0,
    this.totalComments = 0,
  });
}

/// Contract for profile data operations.
abstract class ProfileRepository {
  /// Get user profile from Firestore `users/{uid}`.
  Future<ProfileEntity> getUserProfile(String uid);

  /// Get the current authenticated user's profile.
  Future<ProfileEntity> getCurrentUserProfile();

  /// Get activity stats for a user (posts count, total likes, total comments).
  Future<ProfileStats> getUserStats(String uid);
}
