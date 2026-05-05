import 'package:flutter/material.dart';
import 'package:etanaorokoapp/core/theme/app_colors.dart';
import 'package:etanaorokoapp/core/extensions/context_extensions.dart';
import 'package:etanaorokoapp/core/extensions/responsive_extension.dart';
import 'package:etanaorokoapp/core/widgets/more/user_avatar_widget.dart';
import 'package:etanaorokoapp/features/feed/domain/entities/post_entity.dart';
import 'package:etanaorokoapp/features/feed/presentation/widgets/post_actions.dart';
import 'package:etanaorokoapp/features/feed/presentation/widgets/post_comments_section.dart';

/// Avatar color pair for a user based on their name.
class AvatarColors {
  final Color background;
  final Color text;
  const AvatarColors(this.background, this.text);

  /// Deterministic color assignment based on user name.
  static AvatarColors forName(String name) {
    const palette = [
      AvatarColors(AppColors.avatarTeal, AppColors.avatarTealText),
      AvatarColors(AppColors.avatarBlue, AppColors.avatarBlueText),
      AvatarColors(AppColors.avatarIndigo, AppColors.avatarIndigoText),
      AvatarColors(AppColors.avatarOrange, AppColors.avatarOrangeText),
    ];
    final index =
        name.codeUnits.fold<int>(0, (sum, c) => sum + c) % palette.length;
    return palette[index];
  }
}

/// Formats a DateTime into a human-readable "time ago" string.
String formatTimeAgo(DateTime dateTime) {
  final diff = DateTime.now().difference(dateTime);
  if (diff.inDays > 0) {
    return diff.inDays == 1 ? 'Yesterday' : '${diff.inDays} days ago';
  }
  if (diff.inHours > 0) {
    return '${diff.inHours} ${diff.inHours == 1 ? 'hour' : 'hours'} ago';
  }
  if (diff.inMinutes > 0) {
    return '${diff.inMinutes} ${diff.inMinutes == 1 ? 'minute' : 'minutes'} ago';
  }
  return 'Just now';
}

/// Individual post card.
///
/// Layout: avatar + name/time row, content text, like/comment actions.
/// Tapping the avatar navigates to that user's profile.
class PostCard extends StatefulWidget {
  final PostEntity post;
  final VoidCallback onLikeTap;
  final void Function(String userId, String userName)? onAvatarTap;

  const PostCard({
    super.key,
    required this.post,
    required this.onLikeTap,
    this.onAvatarTap,
  });

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  bool _showComments = false;

  @override
  Widget build(BuildContext context) {
    final colors = AvatarColors.forName(widget.post.userName);

    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border.symmetric(
          horizontal: BorderSide(color: AppColors.border),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header: avatar + name + time
          Row(
            children: [
              GestureDetector(
                onTap: () => widget.onAvatarTap?.call(
                  widget.post.userId,
                  widget.post.userName,
                ),
                child: UserAvatarWidget(
                  name: widget.post.userName,
                  photoUrl: widget.post.userPhotoUrl,
                  size: 40,
                  backgroundColor: colors.background,
                  textColor: colors.text,
                ),
              ),
              12.wt,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.post.userName,
                      style: context.textTheme.titleSmall?.copyWith(
                        color: AppColors.textPrimary,
                      ),
                    ),
                    4.ht,
                    Text(
                      formatTimeAgo(widget.post.createdAt),
                      style: context.textTheme.labelSmall?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          12.ht,
          // Content
          Text(
            widget.post.content,
            style: context.textTheme.bodyMedium?.copyWith(
              color: AppColors.textPrimary,
              height: 1.6,
            ),
          ),
          8.ht,
          // Actions
          PostActions(
            likesCount: widget.post.likesCount,
            commentsCount: widget.post.commentsCount,
            isLiked: widget.post.isLiked,
            onLikeTap: widget.onLikeTap,
            onCommentTap: () {
              setState(() => _showComments = !_showComments);
            },
          ),
          // Comments section (expandable)
          if (_showComments) PostCommentsSection(postId: widget.post.id),
        ],
      ),
    );
  }
}
