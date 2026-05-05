import '../entities/user_entity.dart';

abstract class AuthRepository {
  Stream<UserEntity?> get authStateChanges;

  Future<UserEntity?> get currentUser;

  Future<UserEntity> signInWithEmailAndPassword(String email, String password);

  Future<UserEntity> signInWithGoogle();

  Future<UserEntity> createAccount(String name, String email, String password);

  Future<void> signOut();
}
