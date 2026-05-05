import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/entities/profile_entity.dart';

class ProfileModel extends ProfileEntity {
  const ProfileModel({
    required super.uid,
    required super.name,
    required super.email,
    super.photoUrl,
    super.bio,
    required super.createdAt,
    super.updatedAt,
  });

  factory ProfileModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final data = doc.data()!;
    return ProfileModel(
      uid: data['uid'] as String,
      name: data['name'] as String,
      email: data['email'] as String,
      photoUrl: data['photoUrl'] as String?,
      bio: (data['bio'] as String?) ?? '',
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      updatedAt: data['updatedAt'] != null
          ? (data['updatedAt'] as Timestamp).toDate()
          : null,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'uid': uid,
      'name': name,
      'email': email,
      'photoUrl': photoUrl,
      'bio': bio,
      'createdAt': FieldValue.serverTimestamp(),
    };
  }

  factory ProfileModel.fromEntity(ProfileEntity entity) {
    return ProfileModel(
      uid: entity.uid,
      name: entity.name,
      email: entity.email,
      photoUrl: entity.photoUrl,
      bio: entity.bio,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }
}
