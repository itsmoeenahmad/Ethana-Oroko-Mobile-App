import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:etanaorokoapp/core/theme/app_colors.dart';
import 'package:etanaorokoapp/core/widgets/loaders/custom_loader.dart';
import 'package:etanaorokoapp/app/injection_container.dart';
import 'package:etanaorokoapp/core/services/firebase/firebase_auth_service.dart';
import 'package:etanaorokoapp/core/theme/app_border_radius.dart';
import 'package:etanaorokoapp/core/extensions/context_extensions.dart';
import 'package:etanaorokoapp/core/extensions/responsive_extension.dart';
import 'package:etanaorokoapp/core/widgets/more/user_avatar_widget.dart';
import 'package:etanaorokoapp/features/feed/domain/entities/comment_entity.dart';
import 'package:etanaorokoapp/features/feed/presentation/providers/feed_provider.dart';
import 'package:etanaorokoapp/features/feed/presentation/widgets/post_card.dart';

/// Expandable comments section shown under a post.
///
/// Loads comments from Firestore when mounted.
/// Shows comment bubbles + a reply input at the bottom.
class PostCommentsSection extends StatefulWidget {
  final String postId;

  const PostCommentsSection({super.key, required this.postId});

  @override
  State<PostCommentsSection> createState() => _PostCommentsSectionState();
}

class _PostCommentsSectionState extends State<PostCommentsSection> {
  final _replyController = TextEditingController();
  List<CommentEntity> _comments = [];
  bool _isLoading = true;
  bool _isSending = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadComments();
  }

  @override
  void dispose() {
    _replyController.dispose();
    super.dispose();
  }

  Future<void> _loadComments() async {
    try {
      final comments =
          await context.read<FeedProvider>().getComments(widget.postId);
      if (mounted) {
        setState(() {
          _comments = comments;
          _isLoading = false;
        });
      }
    } catch (_) {
      if (mounted) {
        setState(() {
          _error = 'Failed to load comments.';
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _onSend() async {
    final text = _replyController.text.trim();
    if (text.isEmpty || _isSending) return;

    setState(() => _isSending = true);

    final provider = context.read<FeedProvider>();
    try {
      final comment = await provider.addComment(widget.postId, text);
      if (!mounted) return;
      _replyController.clear();
      context.hideKeyboard();
      setState(() {
        _comments.add(comment);
        _isSending = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() => _isSending = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to add comment.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 16.h),
      padding: EdgeInsets.all(12.w),
      decoration: const BoxDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (_isLoading)
            Padding(
              padding: EdgeInsets.symmetric(vertical: 16.h),
              child: Center(
                child: CustomLoader(
                  size: 20,
                  color: AppColors.brand600,
                ),
              ),
            )
          else if (_error != null)
            Padding(
              padding: EdgeInsets.symmetric(vertical: 8.h),
              child: Text(
                _error!,
                style: context.textTheme.labelSmall?.copyWith(
                  color: AppColors.textTertiary,
                ),
              ),
            )
          else ...[
            // Comments list
            ..._comments.map((c) => _CommentBubble(comment: c)),
          ],
          // Reply input
          Builder(
            builder: (context) {
              final currentUser = di<FirebaseAuthService>().currentUser;
              return _ReplyInput(
                controller: _replyController,
                onSend: _onSend,
                isSending: _isSending,
                userName: currentUser?.displayName,
                userPhotoUrl: currentUser?.photoURL,
                hintText: _comments.isEmpty && !_isLoading
                    ? 'Be the first to reply...'
                    : 'Write a reply...',
              );
            },
          ),
        ],
      ),
    );
  }
}

class _CommentBubble extends StatelessWidget {
  final CommentEntity comment;

  const _CommentBubble({required this.comment});

  @override
  Widget build(BuildContext context) {
    final colors = AvatarColors.forName(comment.userName);

    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          UserAvatarWidget(
            name: comment.userName,
            photoUrl: comment.userPhotoUrl,
            size: 28,
            backgroundColor: colors.background,
            textColor: colors.text,
          ),
          8.wt,
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: AppBorderRadius.commentBubble,
                border: Border.all(color: AppColors.borderLight),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Text(
                          comment.userName,
                          style: context.textTheme.labelSmall?.copyWith(
                            color: AppColors.textPrimary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      Text(
                        formatTimeAgo(comment.createdAt),
                        style: context.textTheme.labelSmall?.copyWith(
                          color: AppColors.textTertiary,
                          fontSize: 10.sp,
                        ),
                      ),
                    ],
                  ),
                  6.ht,
                  Text(
                    comment.content,
                    style: context.textTheme.labelSmall?.copyWith(
                      color: AppColors.textLabel,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ReplyInput extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onSend;
  final bool isSending;
  final String hintText;
  final String? userName;
  final String? userPhotoUrl;

  const _ReplyInput({
    required this.controller,
    required this.onSend,
    this.isSending = false,
    this.hintText = 'Write a reply...',
    this.userName,
    this.userPhotoUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        userName != null
            ? UserAvatarWidget(
                name: userName!,
                photoUrl: userPhotoUrl,
                size: 28,
              )
            : const UserAvatarWidget.placeholder(size: 28),
        8.wt,
        Expanded(
          child: SizedBox(
            height: 40.h,
            child: TextField(
              controller: controller,
              enabled: !isSending,
              style: context.textTheme.labelSmall?.copyWith(
                color: AppColors.textPrimary,
              ),
              textAlignVertical: TextAlignVertical.center,
              decoration: InputDecoration(
                hintText: hintText,
                hintStyle: context.textTheme.labelSmall?.copyWith(
                  color: AppColors.textTertiary,
                ),
                filled: true,
                fillColor: AppColors.surface,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 16.w,
                  vertical: 0,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(999),
                  borderSide: BorderSide(color: AppColors.border),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(999),
                  borderSide: BorderSide(color: AppColors.border),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(999),
                  borderSide: BorderSide(color: AppColors.brand500),
                ),
                suffixIcon: GestureDetector(
                  onTap: isSending ? null : onSend,
                  child: Padding(
                    padding: EdgeInsets.only(right: 12.w),
                    child: isSending
                        ? CustomLoader(
                            size: 18.sp,
                            color: AppColors.brand600,
                          )
                        : Icon(
                            Icons.send_rounded,
                            size: 18.sp,
                            color: AppColors.brand600,
                          ),
                  ),
                ),
                suffixIconConstraints: BoxConstraints(
                  minHeight: 18.sp,
                  minWidth: 18.sp,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
