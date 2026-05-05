import 'package:flutter/material.dart';
import 'package:etanaorokoapp/core/theme/app_colors.dart';
import 'package:etanaorokoapp/core/extensions/context_extensions.dart';
import 'package:etanaorokoapp/core/extensions/responsive_extension.dart';

class AuthFooter extends StatelessWidget {
  final String message;
  final String actionText;
  final VoidCallback onActionTap;

  const AuthFooter({
    super.key,
    required this.message,
    required this.actionText,
    required this.onActionTap,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = context.textTheme;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(
        top: 24.h,
        bottom: 8.h + MediaQuery.of(context).padding.bottom,
      ),
      decoration: BoxDecoration(
        color: AppColors.surface.withValues(alpha: 0.5),
        border: const Border(top: BorderSide(color: AppColors.borderLight)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            message,
            style: textTheme.bodyMedium?.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          GestureDetector(
            onTap: onActionTap,
            child: Text(
              actionText,
              style: textTheme.bodyMedium?.copyWith(
                color: AppColors.brand600,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
