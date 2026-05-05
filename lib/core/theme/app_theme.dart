import 'app_theme_data.dart';
import 'package:flutter/material.dart';

/// Entry point for [ThemeData]. Use [light] for Etana Oroko (see `DESIGN.html`).
abstract class AppTheme {
  static ThemeData get light => AppThemeData.lightTheme;
  static ThemeData get dark => AppThemeData.darkTheme;
}
