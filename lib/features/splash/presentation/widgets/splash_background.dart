import 'package:flutter/material.dart';
import 'package:etanaorokoapp/core/theme/app_colors.dart';
import 'package:etanaorokoapp/core/extensions/responsive_extension.dart';

/// Decorative background circles for the splash screen.
/// Matches the two blurred circles from DESIGN.html splash.
class SplashBackground extends StatelessWidget {
  const SplashBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: Stack(
        children: [
          // Top-right decorative circle — white/5%
          Positioned(
            top: -80.h,
            right: -80.w,
            child: Container(
              width: 256.w,
              height: 256.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.white.withValues(alpha: 0.05),
              ),
            ),
          ),
          // Bottom-left decorative circle — brand-900/20%
          Positioned(
            bottom: 40.h,
            left: -80.w,
            child: Container(
              width: 320.w,
              height: 320.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.brand900.withValues(alpha: 0.2),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
