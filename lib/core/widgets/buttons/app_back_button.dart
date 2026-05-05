import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:etanaorokoapp/core/theme/app_colors.dart';
import 'package:etanaorokoapp/core/extensions/responsive_extension.dart';

/// Plain back chevron — no background. Prefer [AuthHeaderWidget.showBack] on recovery screens.
class AppBackButton extends StatelessWidget {
  const AppBackButton({super.key, this.onBackPressed});

  final VoidCallback? onBackPressed;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: IconButton(
        padding: EdgeInsets.zero,
        constraints: BoxConstraints(minWidth: 48.w, minHeight: 48.h),
        style: IconButton.styleFrom(
          foregroundColor: AppColors.textPrimary,
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          visualDensity: VisualDensity.compact,
        ),
        onPressed: onBackPressed ?? () => context.pop(),
        icon: Icon(Icons.arrow_back_ios_new_rounded, size: 18.sp),
      ),
    );
  }
}
