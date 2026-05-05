import 'package:etanaorokoapp/core/constants/app_assets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:etanaorokoapp/core/theme/app_border_radius.dart';
import 'package:etanaorokoapp/core/extensions/responsive_extension.dart';
import 'package:etanaorokoapp/core/widgets/animated/primary_button.dart';
import 'package:etanaorokoapp/core/widgets/animated/outlined_button.dart';
import 'package:etanaorokoapp/features/auth/presentation/widgets/or_divider.dart';
import 'package:etanaorokoapp/features/auth/presentation/providers/login_provider.dart';

class LoginActions extends StatelessWidget {
  final VoidCallback onSignIn;
  final VoidCallback onGoogleSignIn;

  const LoginActions({
    super.key,
    required this.onSignIn,
    required this.onGoogleSignIn,
  });

  @override
  Widget build(BuildContext context) {
    final isLoading = context.select<LoginProvider, bool>((p) => p.isLoading);

    return Column(
      children: [
        PrimaryButton(
          text: 'Sign In',
          icon: Icons.arrow_forward,
          borderRadius: AppBorderRadius.s16,
          isLoading: isLoading,
          onPressed: onSignIn,
        ),
        16.ht,
        const OrDivider(),
        16.ht,
        CustomOutlinedButton(
          text: 'Continue with Google',
          icon: AppAssets.googleLogo,
          borderRadius: AppBorderRadius.s16,
          iconSize: 16.w,
          height: 56.h,
          onPressed: onGoogleSignIn,
        ),
      ],
    );
  }
}
