/// Sealed class hierarchy for typed error handling across the app.
///
/// Domain-pure: no Flutter or Firebase SDK imports.
sealed class Failure {
  final String message;
  final String? code;

  const Failure({required this.message, this.code});

  @override
  String toString() => 'Failure($code: $message)';
}

/// Authentication-related failures (Firebase Auth errors).
class AuthFailure extends Failure {
  const AuthFailure({required super.message, super.code});

  /// Maps a Firebase Auth error code string to a user-friendly [AuthFailure].
  factory AuthFailure.fromCode(String code) {
    final message = switch (code) {
      'wrong-password' => 'Incorrect password. Please try again.',
      'invalid-credential' =>
        'Invalid email or password. Please check your credentials.',
      'user-not-found' => 'No account found with this email.',
      'email-already-in-use' => 'An account with this email already exists.',
      'invalid-email' => 'Please enter a valid email address.',
      'too-many-requests' => 'Too many attempts. Please try again later.',
      'network-request-failed' =>
        'No internet connection. Please check your network.',
      'user-disabled' =>
        'This account has been disabled. Please contact support.',
      'operation-not-allowed' =>
        'This sign-in method is not enabled. Please contact support.',
      'weak-password' =>
        'Password is too weak. Please choose a stronger password.',
      'sign_in_canceled' => 'Sign-in was cancelled.',
      _ => 'Something went wrong. Please try again.',
    };
    return AuthFailure(message: message, code: code);
  }
}

/// Server/Firestore-related failures.
class ServerFailure extends Failure {
  const ServerFailure({required super.message, super.code});

  /// Maps a Firestore error code string to a user-friendly [ServerFailure].
  factory ServerFailure.fromCode(String code) {
    final message = switch (code) {
      'permission-denied' =>
        "You don't have permission to perform this action.",
      'not-found' => 'The requested data was not found.',
      'already-exists' => 'This data already exists.',
      'resource-exhausted' => 'Too many requests. Please try again later.',
      'unavailable' =>
        'Service is temporarily unavailable. Please try again later.',
      _ => 'Something went wrong. Please try again.',
    };
    return ServerFailure(message: message, code: code);
  }
}

/// Network connectivity failures.
class NetworkFailure extends Failure {
  const NetworkFailure({
    super.message = 'No internet connection. Please check your network.',
    super.code = 'network-failure',
  });
}

/// Input validation failures.
class ValidationFailure extends Failure {
  const ValidationFailure({required super.message, super.code = 'validation'});
}
