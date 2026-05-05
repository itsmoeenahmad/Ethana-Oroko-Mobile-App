import 'package:flutter/foundation.dart';

// Todo: Replace this mock with real Firebase + local notification implementation
// once google-services.json is configured.
// See PROGRESS_REPORT.md for context.

/// Notification Service — mock implementation.
///
/// Provides the same public API the rest of the app depends on so DI and
/// bootstrap work without Firebase. Swap in the real Firebase/FCM logic later.
class NotificationService {
  NotificationService._();
  static final NotificationService instance = NotificationService._();

  bool _isInitialized = false;
  bool get isInitialized => _isInitialized;

  /// No-op until Firebase is wired up.
  Future<void> initialize() async {
    if (_isInitialized) return;
    _isInitialized = true;
    debugPrint('NotificationService initialized (mock)');
  }

  Future<bool> requestPermissions() async => false;

  Future<void> showLocalNotification({
    required String title,
    required String body,
    String? payload,
    String channelId = 'high_importance_channel',
  }) async {
    debugPrint('Mock notification — $title: $body');
  }

  Future<void> dispose() async {
    _isInitialized = false;
  }
}
