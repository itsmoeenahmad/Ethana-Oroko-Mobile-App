import 'package:flutter/material.dart';
import 'package:etanaorokoapp/core/theme/app_colors.dart';
import 'package:etanaorokoapp/core/extensions/context_extensions.dart';
import 'package:etanaorokoapp/core/extensions/responsive_extension.dart';

/// Like and comment action buttons for a post card.
///
/// Matches DESIGN.html: heart icon + count, chat icon + count,
/// separated by a top border.
class PostActions extends StatelessWidget {
  final int likesCount;
  final int commentsCount;
  final bool isLiked;
  final VoidCallback onLikeTap;
  final VoidCallback onCommentTap;

  const PostActions({
    super.key,
    required this.likesCount,
    required this.commentsCount,
    required this.isLiked,
    required this.onLikeTap,
    required this.onCommentTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 4.h),
      child: Row(
        children: [
          _ActionButton(
            icon: isLiked ? Icons.favorite : Icons.favorite_border,
            count: likesCount,
            isActive: isLiked,
            onTap: onLikeTap,
          ),
          24.wt,
          _ActionButton(
            icon: Icons.chat_bubble_outline_rounded,
            count: commentsCount,
            isActive: false,
            onTap: onCommentTap,
          ),
        ],
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final int count;
  final bool isActive;
  final VoidCallback onTap;

  const _ActionButton({
    required this.icon,
    required this.count,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = isActive ? AppColors.brand600 : AppColors.textSecondary;

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Row(
        children: [
          Icon(icon, size: 20.sp, color: color),
          6.wt,
          Text(
            '$count',
            style: context.textTheme.labelSmall?.copyWith(
              color: color,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
