import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:etanaorokoapp/core/theme/app_colors.dart';
import 'package:etanaorokoapp/core/widgets/loaders/custom_loader.dart';
import 'package:etanaorokoapp/core/router/route_names.dart';
import 'package:etanaorokoapp/app/injection_container.dart';
import 'package:etanaorokoapp/core/services/firebase/firebase_auth_service.dart';
import 'package:etanaorokoapp/core/extensions/context_extensions.dart';
import 'package:etanaorokoapp/core/extensions/responsive_extension.dart';
import 'package:etanaorokoapp/features/feed/presentation/widgets/post_card.dart';
import 'package:etanaorokoapp/features/feed/presentation/widgets/feed_app_bar.dart';
import 'package:etanaorokoapp/features/feed/presentation/providers/feed_provider.dart';
import 'package:etanaorokoapp/features/feed/presentation/widgets/create_post_section.dart';

class FeedScreen extends StatelessWidget {
  const FeedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => di<FeedProvider>()..loadPosts(),
      child: const _FeedScreenContent(),
    );
  }
}

class _FeedScreenContent extends StatefulWidget {
  const _FeedScreenContent();

  @override
  State<_FeedScreenContent> createState() => _FeedScreenContentState();
}

class _FeedScreenContentState extends State<_FeedScreenContent> {
  final _postController = TextEditingController();

  @override
  void dispose() {
    _postController.dispose();
    super.dispose();
  }

  Future<void> _onPost() async {
    final text = _postController.text;
    if (text.trim().isEmpty) return;
    final provider = context.read<FeedProvider>();
    await provider.createPost(text);
    if (!mounted) return;
    _postController.clear();
    context.hideKeyboard();
  }

  void _onProfileTap() {
    context.push(RouteNames.profile);
  }

  void _onAvatarTap(String userId, String userName) {
    context.push(
      RouteNames.profile,
      extra: {'userId': userId, 'userName': userName},
    );
  }

  Future<void> _onRefresh() async {
    await context.read<FeedProvider>().refreshPosts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          // Fixed app bar
          Builder(
            builder: (context) {
              final currentUser = di<FirebaseAuthService>().currentUser;
              return FeedAppBar(
                onProfileTap: _onProfileTap,
                userName: currentUser?.displayName,
                userPhotoUrl: currentUser?.photoURL,
              );
            },
          ),
          // Fixed create post section
          Consumer<FeedProvider>(
            builder: (context, provider, _) {
              final currentUser = di<FirebaseAuthService>().currentUser;
              return CreatePostSection(
                controller: _postController,
                onPost: _onPost,
                isCreating: provider.isCreatingPost,
                userName: currentUser?.displayName,
                userPhotoUrl: currentUser?.photoURL,
              );
            },
          ),
          // Scrollable posts with pull-to-refresh
          Expanded(
            child: Consumer<FeedProvider>(
              builder: (context, provider, _) {
                if (provider.isLoading) {
                  return Center(
                    child: CustomLoader(size: 40, color: AppColors.brand600),
                  );
                }

                if (provider.errorMessage != null && provider.posts.isEmpty) {
                  return Center(
                    child: Padding(
                      padding: EdgeInsets.all(32.w),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.error_outline_rounded,
                            size: 48.sp,
                            color: AppColors.textTertiary,
                          ),
                          16.ht,
                          Text(
                            provider.errorMessage!,
                            textAlign: TextAlign.center,
                            style: context.textTheme.bodyMedium?.copyWith(
                              color: AppColors.textSecondary,
                            ),
                          ),
                          16.ht,
                          GestureDetector(
                            onTap: () => provider.loadPosts(),
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 24.w,
                                vertical: 10.h,
                              ),
                              decoration: const BoxDecoration(
                                color: AppColors.brand600,
                                borderRadius: BorderRadius.all(
                                  Radius.circular(999),
                                ),
                              ),
                              child: Text(
                                'Retry',
                                style: context.textTheme.labelMedium?.copyWith(
                                  color: AppColors.white,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                if (provider.posts.isEmpty) {
                  return Center(
                    child: Padding(
                      padding: EdgeInsets.all(32.w),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.forum_outlined,
                            size: 48.sp,
                            color: AppColors.textTertiary,
                          ),
                          16.ht,
                          Text(
                            'No posts yet. Be the first to share!',
                            textAlign: TextAlign.center,
                            style: context.textTheme.bodyMedium?.copyWith(
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                return RefreshIndicator(
                  onRefresh: _onRefresh,
                  color: AppColors.brand600,
                  child: ListView.builder(
                    padding: EdgeInsets.only(bottom: 32.h),
                    itemCount: provider.posts.length,
                    itemBuilder: (context, index) {
                      final post = provider.posts[index];
                      return Padding(
                        padding: EdgeInsets.only(top: 8.h),
                        child: PostCard(
                          post: post,
                          onLikeTap: () => provider.toggleLike(post.id),
                          onAvatarTap: _onAvatarTap,
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
