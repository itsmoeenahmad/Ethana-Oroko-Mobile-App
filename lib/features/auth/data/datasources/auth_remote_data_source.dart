import 'package:firebase_auth/firebase_auth.dart';

import 'package:etanaorokoapp/core/services/firebase/firebase_auth_service.dart';
import 'package:etanaorokoapp/core/services/firebase/firestore_service.dart';
import '../models/user_model.dart';

abstract class AuthRemoteDataSource {
  Stream<UserModel?> get authStateChanges;
  UserModel? get currentUser;
  Future<UserModel> signInWithEmailAndPassword(String email, String password);
  Future<UserModel> signInWithGoogle();
  Future<UserModel> createAccount(String name, String email, String password);
  Future<void> signOut();
  Future<UserModel> getUserDocument(String uid);
  Future<void> createUserDocument(UserModel user);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final FirebaseAuthService _authService;
  final FirestoreService _firestoreService;

  AuthRemoteDataSourceImpl(this._authService, this._firestoreService);

  @override
  Stream<UserModel?> get authStateChanges {
    return _authService.authStateChanges.map((user) {
      if (user == null) return null;
      return UserModel.fromFirebaseUser(user);
    });
  }

  @override
  UserModel? get currentUser {
    final user = _authService.currentUser;
    if (user == null) return null;
    return UserModel.fromFirebaseUser(user);
  }

  @override
  Future<UserModel> signInWithEmailAndPassword(
    String email,
    String password,
  ) async {
    final credential = await _authService.signInWithEmailAndPassword(
      email,
      password,
    );
    final uid = credential.user!.uid;
    return getUserDocument(uid);
  }

  @override
  Future<UserModel> signInWithGoogle() async {
    final credential = await _authService.signInWithGoogle();
    final user = credential.user!;
    final uid = user.uid;

    final doc = await _firestoreService.getDocument(
      _firestoreService.usersCollection,
      uid,
    );

    if (doc.exists) {
      return UserModel.fromFirestore(doc);
    }

    // New Google user — create Firestore document
    final newUser = UserModel.fromFirebaseUser(user);
    await createUserDocument(newUser);
    return newUser;
  }

  @override
  Future<UserModel> createAccount(
    String name,
    String email,
    String password,
  ) async {
    final credential = await _authService.createUserWithEmailAndPassword(
      email,
      password,
    );
    final user = credential.user!;

    // Update displayName on Firebase Auth user
    await user.updateDisplayName(name);

    final newUser = UserModel(
      uid: user.uid,
      name: name,
      email: email,
      photoUrl: null,
      createdAt: DateTime.now(),
    );

    await createUserDocument(newUser);
    return newUser;
  }

  @override
  Future<void> signOut() async {
    await _authService.signOut();
  }

  @override
  Future<UserModel> getUserDocument(String uid) async {
    final doc = await _firestoreService.getDocument(
      _firestoreService.usersCollection,
      uid,
    );

    if (!doc.exists) {
      // Edge case: auth user exists but Firestore doc is missing.
      // Recover by creating a doc from the current auth user.
      final authUser = _authService.currentUser;
      if (authUser != null) {
        final recovered = UserModel.fromFirebaseUser(authUser);
        await createUserDocument(recovered);
        return recovered;
      }
      throw FirebaseAuthException(
        code: 'user-not-found',
        message: 'User document not found in Firestore.',
      );
    }

    return UserModel.fromFirestore(doc);
  }

  @override
  Future<void> createUserDocument(UserModel user) async {
    await _firestoreService.setDocument(
      _firestoreService.usersCollection,
      user.uid,
      user.toFirestore(),
    );
  }
}
