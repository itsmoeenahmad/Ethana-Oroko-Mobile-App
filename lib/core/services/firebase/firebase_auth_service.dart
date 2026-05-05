import '../logger/logger_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

/// Single wrapper for all [FirebaseAuth] SDK calls.
///
/// No other file in the app should import `firebase_auth` directly
/// (except this service). Raw Firebase exceptions propagate up —
/// the repository layer catches and maps them via [AppFailures].
class FirebaseAuthService {
  final FirebaseAuth _auth;
  final GoogleSignIn _googleSignIn;
  final LoggerService _logger;

  FirebaseAuthService({FirebaseAuth? auth, GoogleSignIn? googleSignIn})
    : _auth = auth ?? FirebaseAuth.instance,
      _googleSignIn = googleSignIn ?? GoogleSignIn.instance,
      _logger = LoggerService(className: 'FirebaseAuthService');

  /// Stream of auth state changes (user login/logout).
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  /// Currently signed-in user, or `null` if not signed in.
  User? get currentUser => _auth.currentUser;

  /// Sign in with email and password.
  Future<UserCredential> signInWithEmailAndPassword(
    String email,
    String password,
  ) async {
    _logger.info('Attempting email/password sign-in for: $email');
    final credential = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    _logger.success(
      'Email/password sign-in successful for uid: ${credential.user?.uid}',
    );
    return credential;
  }

  /// Create a new user with email and password.
  Future<UserCredential> createUserWithEmailAndPassword(
    String email,
    String password,
  ) async {
    _logger.info('Attempting account creation for: $email');
    final credential = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    _logger.success('Account created for uid: ${credential.user?.uid}');
    return credential;
  }

  /// Sign in with Google (google_sign_in v7+ API).
  ///
  /// Uses [GoogleSignIn.instance.authenticate] to get the Google account,
  /// then extracts the [idToken] to create a Firebase credential.
  /// Throws [FirebaseAuthException] on failure or cancellation.
  Future<UserCredential> signInWithGoogle() async {
    _logger.info('Attempting Google sign-in');

    try {
      final googleAccount = await _googleSignIn.authenticate();
      final idToken = googleAccount.authentication.idToken;

      final credential = GoogleAuthProvider.credential(idToken: idToken);
      final userCredential = await _auth.signInWithCredential(credential);

      _logger.success(
        'Google sign-in successful for uid: ${userCredential.user?.uid}',
      );
      return userCredential;
    } on GoogleSignInException catch (e) {
      _logger.warning('Google sign-in failed: ${e.code} - ${e.description}');
      throw FirebaseAuthException(
        code: e.code == GoogleSignInExceptionCode.canceled
            ? 'sign_in_canceled'
            : 'google-sign-in-failed',
        message: e.description ?? 'Google sign-in failed.',
      );
    }
  }

  /// Sign out from both Firebase Auth and Google Sign-In.
  Future<void> signOut() async {
    _logger.info('Signing out');
    await _auth.signOut();
    await _googleSignIn.signOut();
    _logger.success('Sign out complete');
  }
}
