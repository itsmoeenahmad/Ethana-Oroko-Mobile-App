import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../widgets/splash_background.dart';
import '../widgets/splash_loading_indicator.dart';
import 'package:etanaorokoapp/core/theme/app_colors.dart';
import 'package:etanaorokoapp/core/router/route_names.dart';
import 'package:etanaorokoapp/app/injection_container.dart';
import 'package:etanaorokoapp/core/services/firebase/firebase_auth_service.dart';
import 'package:etanaorokoapp/core/widgets/more/app_logo_widget.dart';
import 'package:etanaorokoapp/core/extensions/context_extensions.dart';
import 'package:etanaorokoapp/core/extensions/responsive_extension.dart';
import 'package:etanaorokoapp/core/widgets/animated/fade_in_widget.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateBasedOnAuth();
  }

  Future<void> _navigateBasedOnAuth() async {
    await Future.delayed(const Duration(seconds: 3));
    if (!mounted) return;

    final isLoggedIn = di<FirebaseAuthService>().currentUser != null;
    context.go(isLoggedIn ? RouteNames.feed : RouteNames.login);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.brand600,
      body: Stack(
        children: [
          // Decorative background blur circles
          const SplashBackground(),

          // Main content — centered logo, title, subtitle
          Center(
            child: FadeInWidget(
              duration: const Duration(milliseconds: 800),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Logo container (inverted: white bg, brand text)
                  const AppLogoWidget(size: 80, inverted: true),
                  24.ht,
                  // App title
                  Text(
                    'Etana Oroko',
                    style: context.textTheme.displayLarge?.copyWith(
                      color: AppColors.white,
                      letterSpacing: -0.5,
                    ),
                  ),
                  8.ht,
                  // Subtitle
                  Text(
                    'Connecting the Oroko Community',
                    style: context.textTheme.bodyMedium?.copyWith(
                      color: AppColors.brand100,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 0.3,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Loading indicator at bottom
          Positioned(
            bottom: 64.h,
            left: 0,
            right: 0,
            child: const Center(child: SplashLoadingIndicator()),
          ),
        ],
      ),
    );
  }
}
