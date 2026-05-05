import 'package:flutter/material.dart';
import 'package:etanaorokoapp/core/theme/app_colors.dart';
import 'package:etanaorokoapp/core/theme/app_shadows.dart';
import 'package:etanaorokoapp/core/theme/app_border_radius.dart';
import 'package:etanaorokoapp/core/extensions/responsive_extension.dart';
import 'package:etanaorokoapp/core/extensions/context_extensions.dart';

/// Reusable "EO" logo container used across the app.
///
/// Variants from DESIGN.html:
/// - Splash (inverted): white background, brand-600 text, shadow-lg — use [inverted: true]
/// - Default: brand-600 background, white text, shadow-sm
///
/// Sizes from DESIGN.html:
/// - 80 — splash screen
/// - 48 — login header
/// - 40 — signup header
/// - 32 — feed app bar
class AppLogoWidget extends StatelessWidget {
  /// The width and height of the logo container.
  final double size;

  /// When true, renders white bg with brand text (splash variant).
  /// When false, renders brand bg with white text (default).
  final bool inverted;

  const AppLogoWidget({super.key, this.size = 48, this.inverted = false});

  @override
  Widget build(BuildContext context) {
    final responsiveSize = size.w;

    // Scale font relative to container: ~37.5% of size
    final fontSize = (size * 0.375).sp;

    // Use rounded-2xl (logo) for large sizes, rounded-xl (logoSmall) for smaller
    final borderRadius = size >= 48
        ? AppBorderRadius.logo
        : AppBorderRadius.logoSmall;

    final boxShadow = size >= 48 ? AppShadows.lg : AppShadows.sm;

    return Container(
      width: responsiveSize,
      height: responsiveSize,
      decoration: BoxDecoration(
        color: inverted ? AppColors.white : AppColors.brand600,
        borderRadius: borderRadius,
        boxShadow: boxShadow,
      ),
      alignment: Alignment.center,
      child: Text(
        'EO',
        style: context.textTheme.displayLarge?.copyWith(
          color: inverted ? AppColors.brand600 : AppColors.white,
          fontSize: fontSize,
          letterSpacing: -1.5,
        ),
      ),
    );
  }
}
