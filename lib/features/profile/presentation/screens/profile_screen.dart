import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:etanaorokoapp/core/theme/app_colors.dart';
import 'package:etanaorokoapp/core/widgets/loaders/custom_loader.dart';
import 'package:etanaorokoapp/core/router/route_names.dart';
import 'package:etanaorokoapp/app/injection_container.dart';
import 'package:etanaorokoapp/core/extensions/context_extensions.dart';
import 'package:etanaorokoapp/core/extensions/responsive_extension.dart';
import 'package:etanaorokoapp/core/services/firebase/firebase_auth_service.dart';
import 'package:etanaorokoapp/features/auth/domain/usecases/sign_out_usecase.dart';
import 'package:etanaorokoapp/features/feed/presentation/widgets/post_card.dart';
import 'package:etanaorokoapp/features/feed/presentation/providers/feed_provider.dart';
import 'package:etanaorokoapp/features/profile/presentation/widgets/profile_header.dart';
import 'package:etanaorokoapp/features/profile/presentation/widgets/profile_app_bar.dart';
import 'package:etanaorokoapp/features/profile/presentation/widgets/profile_activity.dart';
import 'package:etanaorokoapp/features/profile/presentation/providers/profile_provider.dart';

class ProfileScreen extends StatelessWidget {
  final String? userId;
  final String? userName;

  const ProfileScreen({super.key, this.userId, this.userName});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) =>
          di<ProfileProvider>()..loadProfile(userId: userId, userName: userName),
      child: _ProfileScreenContent(userId: userId),
    );
  }
}

class _ProfileScreenContent extends StatelessWidget {
  final String? userId;

  const _ProfileScreenContent({this.userId});

  bool _isOwnProfile() {
    final currentUid = di<FirebaseAuthService>().currentUser?.uid;
    return userId == null || userId == currentUid;
  }

  Future<void> _onSignOut(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Sign Out'),
        content: const Text('Are you sure you want to sign out?'),
        actions: [
          TextButton(
            onPressed: () => ctx.pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => ctx.pop(true),
            child: const Text('Sign Out'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;
    if (!context.mounted) return;

    await di<SignOutUseCase>()();
    if (!context.mounted) return;
    context.go(RouteNames.login);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          ProfileAppBar(
            onBackTap: () => context.pop(),
            onSignOutTap: _isOwnProfile() ? () => _onSignOut(context) : null,
          ),
          Expanded(
            child: Consumer<ProfileProvider>(
              builder: (context, provider, _) {
                if (provider.isLoading || provider.profile == null) {
                  if (provider.errorMessage != null) {
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
                              onTap: () => provider.loadProfile(
                                userId: userId,
                              ),
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
                                  style:
                                      context.textTheme.labelMedium?.copyWith(
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

                  return Center(
                    child: CustomLoader(size: 40, color: AppColors.brand600),
                  );
                }

                final profile = provider.profile!;
                final colors = AvatarColors.forName(profile.name);

                return SingleChildScrollView(
                  child: Column(
                    children: [
                      ProfileHeader(
                        profile: profile,
                        totalPosts: provider.totalPosts,
                        totalLikes: provider.totalLikes,
                        totalComments: provider.totalComments,
                        avatarBackground: colors.background,
                        avatarTextColor: colors.text,
                      ),
                      ProfileActivity(
                        posts: provider.userPosts,
                        onLikeTap: (postId) {
                          try {
                            context.read<FeedProvider>().toggleLike(postId);
                          } catch (_) {
                            // FeedProvider not available on profile — no-op
                          }
                        },
                      ),
                    ],
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
