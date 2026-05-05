import 'package:flutter/material.dart';
import '../extensions/responsive_extension.dart';
import 'app_fonts.dart';

/// Poppins text styles — weights: Regular (400), Medium (500), SemiBold (600).
/// Sizes derived from DESIGN.html Tailwind classes.
class AppTextStyles {
  AppTextStyles._();

  // ---------------------------------------------------------------------------
  // Display — SemiBold 600
  // ---------------------------------------------------------------------------

  /// 30sp — splash title (text-3xl → 30px).
  static TextStyle displayLarge = TextStyle(
    fontFamily: AppFonts.poppinsFamily,
    fontSize: 30.sp,
    fontWeight: FontWeight.w600,
    height: 1.2,
    letterSpacing: -0.5,
  );

  /// 24sp — section headers (text-2xl → 24px).
  static TextStyle displayMedium = TextStyle(
    fontFamily: AppFonts.poppinsFamily,
    fontSize: 24.sp,
    fontWeight: FontWeight.w600,
    height: 1.2,
    letterSpacing: -0.5,
  );

  /// 20sp — sub-headers (text-xl → 20px).
  static TextStyle displaySmall = TextStyle(
    fontFamily: AppFonts.poppinsFamily,
    fontSize: 20.sp,
    fontWeight: FontWeight.w600,
    height: 1.3,
    letterSpacing: -0.3,
  );

  // ---------------------------------------------------------------------------
  // Headings — SemiBold 600
  // ---------------------------------------------------------------------------

  /// 18sp — app bar title (text-lg → 18px).
  static TextStyle headingLarge = TextStyle(
    fontFamily: AppFonts.poppinsFamily,
    fontSize: 18.sp,
    fontWeight: FontWeight.w600,
    height: 1.3,
    letterSpacing: -0.3,
  );

  /// 16sp — card title.
  static TextStyle headingMedium = TextStyle(
    fontFamily: AppFonts.poppinsFamily,
    fontSize: 16.sp,
    fontWeight: FontWeight.w600,
    height: 1.3,
    letterSpacing: -0.2,
  );

  /// 14sp — small headings, post author name (text-sm font-semibold).
  static TextStyle headingSmall = TextStyle(
    fontFamily: AppFonts.poppinsFamily,
    fontSize: 14.sp,
    fontWeight: FontWeight.w600,
    height: 1.4,
  );

  // ---------------------------------------------------------------------------
  // Title — SemiBold 600
  // ---------------------------------------------------------------------------

  static TextStyle titleLarge = TextStyle(
    fontFamily: AppFonts.poppinsFamily,
    fontSize: 16.sp,
    fontWeight: FontWeight.w600,
    height: 1.4,
  );

  static TextStyle titleMedium = TextStyle(
    fontFamily: AppFonts.poppinsFamily,
    fontSize: 14.sp,
    fontWeight: FontWeight.w600,
    height: 1.4,
  );

  static TextStyle titleSmall = TextStyle(
    fontFamily: AppFonts.poppinsFamily,
    fontSize: 12.sp,
    fontWeight: FontWeight.w600,
    height: 1.4,
    letterSpacing: 0.5,
  );

  // ---------------------------------------------------------------------------
  // Body — Regular 400
  // ---------------------------------------------------------------------------

  /// 16sp body text.
  static TextStyle bodyLarge = TextStyle(
    fontFamily: AppFonts.poppinsFamily,
    fontSize: 16.sp,
    fontWeight: FontWeight.w400,
    height: 1.5,
  );

  /// 14sp body text — post content (text-sm → 14px).
  static TextStyle bodyMedium = TextStyle(
    fontFamily: AppFonts.poppinsFamily,
    fontSize: 14.sp,
    fontWeight: FontWeight.w400,
    height: 1.5,
  );

  /// 12sp body text — timestamps, secondary info (text-xs → 12px).
  static TextStyle bodySmall = TextStyle(
    fontFamily: AppFonts.poppinsFamily,
    fontSize: 12.sp,
    fontWeight: FontWeight.w400,
    height: 1.5,
  );

  // ---------------------------------------------------------------------------
  // Label — Medium 500
  // ---------------------------------------------------------------------------

  /// 14sp label — form labels, navigation items.
  static TextStyle labelLarge = TextStyle(
    fontFamily: AppFonts.poppinsFamily,
    fontSize: 14.sp,
    fontWeight: FontWeight.w500,
    height: 1.2,
    letterSpacing: 0.1,
  );

  /// 12sp label — input labels (text-xs font-medium).
  static TextStyle labelMedium = TextStyle(
    fontFamily: AppFonts.poppinsFamily,
    fontSize: 12.sp,
    fontWeight: FontWeight.w500,
    height: 1.2,
    letterSpacing: 0.5,
  );

  /// 10sp label — tiny labels, badges.
  static TextStyle labelSmall = TextStyle(
    fontFamily: AppFonts.poppinsFamily,
    fontSize: 10.sp,
    fontWeight: FontWeight.w500,
    height: 1.2,
    letterSpacing: 0.5,
  );

  // ---------------------------------------------------------------------------
  // Utility styles
  // ---------------------------------------------------------------------------

  /// Caption — 12sp regular.
  static TextStyle caption = TextStyle(
    fontFamily: AppFonts.poppinsFamily,
    fontSize: 12.sp,
    fontWeight: FontWeight.w400,
    height: 1.4,
  );

  /// Overline — 10sp medium, uppercase tracking (loading text on splash).
  static TextStyle overline = TextStyle(
    fontFamily: AppFonts.poppinsFamily,
    fontSize: 10.sp,
    fontWeight: FontWeight.w500,
    height: 1.6,
    letterSpacing: 1.5,
  );

  /// Button text — 14sp medium (text-sm font-medium).
  static TextStyle button = TextStyle(
    fontFamily: AppFonts.poppinsFamily,
    fontSize: 14.sp,
    fontWeight: FontWeight.w500,
    height: 1.2,
    letterSpacing: 0.5,
  );

  /// Large button text — 16sp medium.
  static TextStyle buttonLarge = TextStyle(
    fontFamily: AppFonts.poppinsFamily,
    fontSize: 16.sp,
    fontWeight: FontWeight.w500,
    height: 1.2,
    letterSpacing: 0.5,
  );

  /// Small button text — 12sp medium (text-xs font-medium, e.g. Post button).
  static TextStyle buttonSmall = TextStyle(
    fontFamily: AppFonts.poppinsFamily,
    fontSize: 12.sp,
    fontWeight: FontWeight.w500,
    height: 1.2,
    letterSpacing: 0.3,
  );

  /// Link text — 14sp medium, for "Forgot?", "Sign Up" links.
  static TextStyle link = TextStyle(
    fontFamily: AppFonts.poppinsFamily,
    fontSize: 14.sp,
    fontWeight: FontWeight.w500,
    height: 1.4,
  );
}
