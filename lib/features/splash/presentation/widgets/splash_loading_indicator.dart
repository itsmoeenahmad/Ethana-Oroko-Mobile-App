import 'package:flutter/material.dart';
import 'package:etanaorokoapp/core/theme/app_colors.dart';
import 'package:etanaorokoapp/core/extensions/responsive_extension.dart';
import 'package:etanaorokoapp/core/widgets/animated/fade_in_widget.dart';

/// Loading spinner shown at the bottom of the splash screen.
/// Uses a CircularProgressIndicator in white/70% per DESIGN.html.
class SplashLoadingIndicator extends StatelessWidget {
  const SplashLoadingIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return FadeInWidget(
      duration: const Duration(milliseconds: 600),
      delay: const Duration(milliseconds: 400),
      child: UnconstrainedBox(
        child: SizedBox(
          width: 24.sp,
          height: 24.sp,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            valueColor: AlwaysStoppedAnimation<Color>(
              AppColors.white.withValues(alpha: 0.7),
            ),
          ),
        ),
      ),
    );
  }
}
