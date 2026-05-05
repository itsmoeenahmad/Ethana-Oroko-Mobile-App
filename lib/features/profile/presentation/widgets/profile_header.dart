import 'package:flutter/material.dart';
import 'package:etanaorokoapp/core/theme/app_colors.dart';
import 'package:etanaorokoapp/core/extensions/context_extensions.dart';
import 'package:etanaorokoapp/core/extensions/responsive_extension.dart';
import 'package:etanaorokoapp/core/widgets/more/user_avatar_widget.dart';
import 'package:etanaorokoapp/features/profile/domain/entities/profile_entity.dart';

/// Profile header section:
/// - Large circle avatar (80px) with initials
/// - Name, email, bio text
/// - Stats row: posts count, total likes, total comments
/// - White background with bottom border
class ProfileHeader extends StatelessWidget {
  final ProfileEntity profile;
  final int totalPosts;
  final int totalLikes;
  final int totalComments;
  final Color avatarBackground;
  final Color avatarTextColor;

  const ProfileHeader({
    super.key,
    required this.profile,
    this.totalPosts = 0,
    this.totalLikes = 0,
    this.totalComments = 0,
    this.avatarBackground = AppColors.avatarTeal,
    this.avatarTextColor = AppColors.avatarTealText,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 32.h),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(bottom: BorderSide(color: AppColors.border)),
      ),
      child: Column(
        children: [
          UserAvatarWidget(
            name: profile.name,
            photoUrl: profile.photoUrl,
            size: 80,
            backgroundColor: avatarBackground,
            textColor: avatarTextColor,
          ),
          16.ht,
          Text(
            profile.name,
            style: context.textTheme.headlineMedium?.copyWith(
              color: AppColors.textPrimary,
            ),
          ),
          4.ht,
          Text(
            profile.email,
            style: context.textTheme.bodyMedium?.copyWith(
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w500,
            ),
          ),
          24.ht,
          // Stats row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _StatItem(label: 'Posts', value: totalPosts),
              _StatItem(label: 'Likes', value: totalLikes),
              _StatItem(label: 'Comments', value: totalComments),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String label;
  final int value;

  const _StatItem({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          '$value',
          style: context.textTheme.titleMedium?.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
        4.ht,
        Text(
          label,
          style: context.textTheme.labelSmall?.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }
}
