/// Represents a user's profile data.
///
/// Fields mirror the Firestore `users/{uid}` collection schema.
class ProfileEntity {
  final String uid;
  final String name;
  final String email;
  final String? photoUrl;
  final String bio;
  final DateTime createdAt;
  final DateTime? updatedAt;

  const ProfileEntity({
    required this.uid,
    required this.name,
    required this.email,
    this.photoUrl,
    this.bio = '',
    required this.createdAt,
    this.updatedAt,
  });

  ProfileEntity copyWith({
    String? uid,
    String? name,
    String? email,
    String? photoUrl,
    String? bio,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ProfileEntity(
      uid: uid ?? this.uid,
      name: name ?? this.name,
      email: email ?? this.email,
      photoUrl: photoUrl ?? this.photoUrl,
      bio: bio ?? this.bio,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
