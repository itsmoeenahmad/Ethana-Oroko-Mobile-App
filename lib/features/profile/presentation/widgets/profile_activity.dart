import 'package:flutter/material.dart';
import 'package:etanaorokoapp/core/theme/app_colors.dart';
import 'package:etanaorokoapp/core/extensions/context_extensions.dart';
import 'package:etanaorokoapp/core/extensions/responsive_extension.dart';
import 'package:etanaorokoapp/features/feed/domain/entities/post_entity.dart';
import 'package:etanaorokoapp/features/feed/presentation/widgets/post_card.dart';

/// "MY ACTIVITY" section on the profile screen.
///
/// Matches DESIGN.html: uppercase label header + list of user's own posts.
class ProfileActivity extends StatelessWidget {
  final List<PostEntity> posts;
  final void Function(String postId)? onLikeTap;

  const ProfileActivity({super.key, required this.posts, this.onLikeTap});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section header
        Container(
          width: double.infinity,
          color: AppColors.background,
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
          child: Text(
            'MY ACTIVITY',
            style: context.textTheme.labelSmall?.copyWith(
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w600,
              letterSpacing: 1.2,
            ),
          ),
        ),
        // User's posts or empty state
        if (posts.isEmpty)
          Padding(
            padding: EdgeInsets.symmetric(vertical: 40.h),
            child: Center(
              child: Column(
                children: [
                  Icon(
                    Icons.article_outlined,
                    size: 40.sp,
                    color: AppColors.textTertiary,
                  ),
                  12.ht,
                  Text(
                    'No activity yet',
                    style: context.textTheme.bodyMedium?.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          )
        else
          ...posts.map(
            (post) => Padding(
              padding: EdgeInsets.only(bottom: 8.h),
              child: PostCard(
                post: post,
                onLikeTap: () => onLikeTap?.call(post.id),
              ),
            ),
          ),
      ],
    );
  }
}
