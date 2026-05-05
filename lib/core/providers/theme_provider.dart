import 'package:flutter/material.dart';

/// Theme Provider - Manages app theme state
/// Current: Light theme only
/// Future: Will include dark theme support
class ThemeProvider extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.light;

  ThemeMode get themeMode => _themeMode;

  bool get isDark => _themeMode == ThemeMode.dark;
  bool get isLight => _themeMode == ThemeMode.light;

  /// Set light theme (current default)
  void setLight() {
    _themeMode = ThemeMode.light;
    notifyListeners();
  }

  /// Set dark theme (reserved for future implementation)
  void setDark() {
    // Implement dark theme in future
    // For now, stay on light theme
    _themeMode = ThemeMode.light;
    notifyListeners();
  }

  /// Set system theme (follows device theme)
  /// Currently defaults to light theme
  void setSystem() {
    // Implement system theme following in future
    // For now, use light theme
    _themeMode = ThemeMode.light;
    notifyListeners();
  }
}

/// Usage Examples:
///
/// Toggle theme from UI:
/// ```dart
/// context.read<ThemeProvider>().setLight();
/// context.read<ThemeProvider>().setDark(); // Will be enabled in future
/// ```
///
/// Check current theme:
/// ```dart
/// final isDark = context.watch<ThemeProvider>().isDark;
/// ```
