import '../logger/logger_service.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class LocalStorageService {
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();
  final LoggerService _appLogger = LoggerService(className: "Local Storage");

  // --- Storage keys (single place; do not scatter raw strings) ---
  static const String _authStateKey = 'auth_state';
  static const String _expiryTimeKey = 'auth_expiry_time';
  static const String _accessTokenKey = 'auth_access_token';
  static const String _refreshTokenKey = 'auth_refresh_token';
  static const String _fcmTokenKey = 'fcm_token';
  static const String _onboardingCompleteKey = 'app_onboarding_complete';

  // ============ AUTH TOKEN METHODS ============

  /// Get stored access token
  Future<String?> getAccessToken() async {
    _appLogger.info("Retrieving access token", tag: "[Auth][Storage]");
    return _secureStorage.read(key: _accessTokenKey);
  }

  /// Save access token securely
  Future<void> saveAccessToken(String token) async {
    _appLogger.info("Saving access token", tag: "[Auth][Storage]");
    await _secureStorage.write(key: _accessTokenKey, value: token);
  }

  /// Get stored refresh token
  Future<String?> getRefreshToken() async {
    _appLogger.info("Retrieving refresh token", tag: "[Auth][Storage]");
    return _secureStorage.read(key: _refreshTokenKey);
  }

  /// Save refresh token securely
  Future<void> saveRefreshToken(String token) async {
    _appLogger.info("Saving refresh token", tag: "[Auth][Storage]");
    await _secureStorage.write(key: _refreshTokenKey, value: token);
  }

  /// Get token expiry time (ISO 8601 format)
  Future<String?> getExpiryTime() async {
    _appLogger.info("Retrieving token expiry time", tag: "[Auth][Storage]");
    return _secureStorage.read(key: _expiryTimeKey);
  }

  /// Save token expiry time (ISO 8601 format)
  Future<void> saveExpiryTime(String isoTimestamp) async {
    _appLogger.info(
      "Saving token expiry time: $isoTimestamp",
      tag: "[Auth][Storage]",
    );
    await _secureStorage.write(key: _expiryTimeKey, value: isoTimestamp);
  }

  /// Clear all authentication-related tokens
  Future<void> clearTokens() async {
    _appLogger.info(
      "Clearing all authentication tokens",
      tag: "[Auth][Storage]",
    );
    await _secureStorage.delete(key: _accessTokenKey);
    await _secureStorage.delete(key: _refreshTokenKey);
    await _secureStorage.delete(key: _expiryTimeKey);
  }

  /// Get stored auth state ('signed' or 'guest')
  Future<String?> getAuthState() async {
    _appLogger.info("Retrieving auth state", tag: "[Auth][Storage]");
    return _secureStorage.read(key: _authStateKey);
  }

  /// Save auth state ('signed' or 'guest')
  Future<void> saveAuthState(String state) async {
    _appLogger.info("Saving auth state: $state", tag: "[Auth][Storage]");
    await _secureStorage.write(key: _authStateKey, value: state);
  }

  /// Clear all auth-related data (tokens + state + FCM token)
  Future<void> clearAuthData() async {
    _appLogger.info("Clearing all authentication data", tag: "[Auth][Storage]");
    await clearTokens();
    await clearFcmToken();
    await _secureStorage.delete(key: _authStateKey);
  }

  // ============ FCM TOKEN METHODS ============

  /// Save FCM device token (used for push notifications)
  Future<void> saveFcmToken(String token) async {
    _appLogger.info("Saving FCM token", tag: "[Notification][Storage]");
    await _secureStorage.write(key: _fcmTokenKey, value: token);
  }

  /// Get stored FCM token
  Future<String?> getFcmToken() async {
    _appLogger.info("Retrieving FCM token", tag: "[Notification][Storage]");
    return _secureStorage.read(key: _fcmTokenKey);
  }

  /// Clear stored FCM token
  Future<void> clearFcmToken() async {
    _appLogger.info("Clearing FCM token", tag: "[Notification][Storage]");
    await _secureStorage.delete(key: _fcmTokenKey);
  }

  // ============ ONBOARDING / APP ============

  /// Whether the user has completed the onboarding flow (persisted).
  Future<bool> getOnboardingComplete() async {
    _appLogger.info(
      "Retrieving onboarding complete flag",
      tag: "[App][Storage]",
    );
    final raw = await _secureStorage.read(key: _onboardingCompleteKey);
    if (raw == null) return false;
    return raw.toLowerCase() == 'true';
  }

  /// Persist onboarding completion (e.g. after "Login with Email" or skip).
  Future<void> setOnboardingComplete(bool value) async {
    _appLogger.info(
      "Saving onboarding complete: $value",
      tag: "[App][Storage]",
    );
    await _secureStorage.write(
      key: _onboardingCompleteKey,
      value: value.toString(),
    );
  }

  /// Remove onboarding flag (e.g. logout-from-guest or reset flows).
  Future<void> clearOnboardingComplete() async {
    _appLogger.info("Clearing onboarding complete flag", tag: "[App][Storage]");
    await _secureStorage.delete(key: _onboardingCompleteKey);
  }

  // ============ GENERAL ============

  /// Deletes **all** keys in secure storage (use sparingly).
  Future<void> deleteAllData() async {
    _appLogger.info("Deleting all data from local storage", tag: "[Storage]");
    await _secureStorage.deleteAll();
  }
}
