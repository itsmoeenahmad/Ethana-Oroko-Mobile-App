import 'package:flutter/material.dart';
import 'package:etanaorokoapp/core/theme/app_colors.dart';
import 'package:etanaorokoapp/core/widgets/more/user_avatar_widget.dart';
import 'package:etanaorokoapp/core/widgets/more/app_logo_widget.dart';
import 'package:etanaorokoapp/core/extensions/context_extensions.dart';
import 'package:etanaorokoapp/core/extensions/responsive_extension.dart';

/// Feed screen app bar matching DESIGN.html:
/// - Translucent white with border bottom
/// - EO logo (32px) + "Community Feed" title on the left
/// - Circular profile icon button on the right
class FeedAppBar extends StatelessWidget {
  final VoidCallback onProfileTap;
  final String? userName;
  final String? userPhotoUrl;

  const FeedAppBar({
    super.key,
    required this.onProfileTap,
    this.userName,
    this.userPhotoUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        left: 20.w,
        right: 20.w,
        top: MediaQuery.of(context).padding.top + 12.h,
        bottom: 16.h,
      ),
      decoration: const BoxDecoration(
        color: AppColors.surfaceTranslucent,
        border: Border(bottom: BorderSide(color: AppColors.border)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              const AppLogoWidget(size: 32),
              10.wt,
              Text(
                'Community Feed',
                style: context.textTheme.headlineLarge?.copyWith(
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          GestureDetector(
            onTap: onProfileTap,
            child: userName != null
                ? UserAvatarWidget(
                    name: userName!,
                    photoUrl: userPhotoUrl,
                    size: 36,
                  )
                : Container(
                    width: 36.w,
                    height: 36.w,
                    decoration: BoxDecoration(
                      color: AppColors.backgroundAlt,
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.borderMedium),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x0D000000),
                          offset: Offset(0, 1),
                          blurRadius: 2,
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.person_outline_rounded,
                      size: 20.sp,
                      color: AppColors.textSecondary,
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
