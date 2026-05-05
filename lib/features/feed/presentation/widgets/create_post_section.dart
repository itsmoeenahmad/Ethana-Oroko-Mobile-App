import 'package:flutter/material.dart';
import 'package:etanaorokoapp/core/theme/app_colors.dart';
import 'package:etanaorokoapp/core/widgets/loaders/custom_loader.dart';
import 'package:etanaorokoapp/core/theme/app_shadows.dart';
import 'package:etanaorokoapp/core/theme/app_border_radius.dart';
import 'package:etanaorokoapp/core/extensions/context_extensions.dart';
import 'package:etanaorokoapp/core/extensions/responsive_extension.dart';
import 'package:etanaorokoapp/core/widgets/more/user_avatar_widget.dart';

/// Create-post input section fixed at top of the feed.
///
/// Clean card layout: avatar on the left, multiline text area filling the
/// remaining width, Post button bottom-right.
class CreatePostSection extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onPost;
  final bool isCreating;
  final String? userName;
  final String? userPhotoUrl;

  const CreatePostSection({
    super.key,
    required this.controller,
    required this.onPost,
    this.isCreating = false,
    this.userName,
    this.userPhotoUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(bottom: BorderSide(color: AppColors.border)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Avatar
          Padding(
            padding: EdgeInsets.only(top: 4.h),
            child: userName != null
                ? UserAvatarWidget(
                    name: userName!,
                    photoUrl: userPhotoUrl,
                    size: 40,
                  )
                : const UserAvatarWidget.placeholder(size: 40),
          ),
          12.wt,
          // Input area + button
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Multiline text area with styled border
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: AppBorderRadius.card,
                    border: Border.all(color: AppColors.border),
                  ),
                  child: TextField(
                    controller: controller,
                    maxLines: 3,
                    minLines: 2,
                    enabled: !isCreating,
                    textAlignVertical: TextAlignVertical.top,
                    style: context.textTheme.bodyMedium?.copyWith(
                      color: AppColors.textPrimary,
                    ),
                    decoration: InputDecoration(
                      hintText: "What's on your mind?",
                      hintStyle: context.textTheme.bodyMedium?.copyWith(
                        color: AppColors.textTertiary,
                      ),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 14.w,
                        vertical: 12.h,
                      ),
                    ),
                  ),
                ),
                12.ht,
                // Post button aligned right
                Align(
                  alignment: Alignment.centerRight,
                  child: GestureDetector(
                    onTap: isCreating ? null : onPost,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 24.w,
                        vertical: 8.h,
                      ),
                      decoration: BoxDecoration(
                        color: isCreating
                            ? AppColors.brand600.withValues(alpha: 0.6)
                            : AppColors.brand600,
                        borderRadius: AppBorderRadius.pill,
                        boxShadow: AppShadows.sm,
                      ),
                      child: isCreating
                          ? CustomLoader(
                              size: 16.sp,
                              color: AppColors.white,
                            )
                          : Text(
                              'Post',
                              style: context.textTheme.labelMedium?.copyWith(
                                color: AppColors.white,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
