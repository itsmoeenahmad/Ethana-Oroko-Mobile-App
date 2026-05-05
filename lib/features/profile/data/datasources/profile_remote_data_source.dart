import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:etanaorokoapp/core/services/firebase/firestore_service.dart';
import '../../domain/repositories/profile_repository.dart';
import '../models/profile_model.dart';

abstract class ProfileRemoteDataSource {
  Future<ProfileModel> getUserProfile(String uid);
  Future<ProfileStats> getUserStats(String uid);
}

class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSource {
  final FirestoreService _firestoreService;

  ProfileRemoteDataSourceImpl(this._firestoreService);

  @override
  Future<ProfileModel> getUserProfile(String uid) async {
    final doc = await _firestoreService.getDocument(
      _firestoreService.usersCollection,
      uid,
    );

    if (!doc.exists) {
      throw FirebaseException(
        plugin: 'firestore',
        code: 'not-found',
        message: 'User profile not found.',
      );
    }

    return ProfileModel.fromFirestore(doc);
  }

  @override
  Future<ProfileStats> getUserStats(String uid) async {
    final snapshot = await _firestoreService.postsCollection
        .where('userId', isEqualTo: uid)
        .get();

    int totalPosts = snapshot.docs.length;
    int totalLikes = 0;
    int totalComments = 0;

    for (final doc in snapshot.docs) {
      final data = doc.data();
      totalLikes += (data['likesCount'] as num?)?.toInt() ?? 0;
      totalComments += (data['commentsCount'] as num?)?.toInt() ?? 0;
    }

    return ProfileStats(
      totalPosts: totalPosts,
      totalLikes: totalLikes,
      totalComments: totalComments,
    );
  }
}
