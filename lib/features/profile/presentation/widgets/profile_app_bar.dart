import 'package:flutter/material.dart';
import 'package:etanaorokoapp/core/theme/app_colors.dart';
import 'package:etanaorokoapp/core/extensions/context_extensions.dart';
import 'package:etanaorokoapp/core/extensions/responsive_extension.dart';

/// Profile screen app bar:
/// - Back arrow (left), "Profile" centered, sign-out button (right, own profile only)
/// - White background with bottom border
class ProfileAppBar extends StatelessWidget {
  final VoidCallback onBackTap;
  final VoidCallback? onSignOutTap;

  const ProfileAppBar({super.key, required this.onBackTap, this.onSignOutTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        left: 16.w,
        right: 16.w,
        top: MediaQuery.of(context).padding.top + 12.h,
        bottom: 16.h,
      ),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(bottom: BorderSide(color: AppColors.borderLight)),
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: onBackTap,
            child: SizedBox(
              width: 40.w,
              height: 40.w,
              child: Icon(
                Icons.arrow_back_rounded,
                size: 22.sp,
                color: AppColors.textSecondary,
              ),
            ),
          ),
          Expanded(
            child: Text(
              'Profile',
              textAlign: TextAlign.center,
              style: context.textTheme.titleLarge?.copyWith(
                color: AppColors.textPrimary,
              ),
            ),
          ),
          if (onSignOutTap != null)
            GestureDetector(
              onTap: onSignOutTap,
              child: SizedBox(
                width: 40.w,
                height: 40.w,
                child: Icon(
                  Icons.logout_rounded,
                  size: 22.sp,
                  color: AppColors.textSecondary,
                ),
              ),
            )
          else
            SizedBox(width: 40.w),
        ],
      ),
    );
  }
}
