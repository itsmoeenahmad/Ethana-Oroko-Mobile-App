import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';
import 'package:etanaorokoapp/app/injection_container.dart';
import 'package:etanaorokoapp/core/router/route_names.dart';
import 'package:etanaorokoapp/core/router/route_transitions.dart';
import 'package:etanaorokoapp/core/extensions/responsive_extension.dart';
import 'package:etanaorokoapp/core/services/firebase/firebase_auth_service.dart';
import 'package:etanaorokoapp/features/feed/presentation/screens/feed_screen.dart';
import 'package:etanaorokoapp/features/auth/presentation/screens/login_screen.dart';
import 'package:etanaorokoapp/features/splash/presentation/screens/splash_screen.dart';
import 'package:etanaorokoapp/features/profile/presentation/screens/profile_screen.dart';
import 'package:etanaorokoapp/features/auth/presentation/screens/create_account_screen.dart';

class AppRouter {
  static final GoRouter appRouter = GoRouter(
    initialLocation: RouteNames.splash,
    debugLogDiagnostics: kDebugMode,
    redirect: (context, state) {
      final isLoggedIn = di<FirebaseAuthService>().currentUser != null;
      final currentPath = state.matchedLocation;

      final isAuthPage =
          currentPath == RouteNames.login ||
          currentPath == RouteNames.createAccount;
      final isSplash = currentPath == RouteNames.splash;

      // Don't redirect from splash — it handles its own auth-aware navigation
      if (isSplash) return null;

      // Not logged in + accessing protected route → send to login
      if (!isLoggedIn && !isAuthPage) return RouteNames.login;

      // Logged in + accessing auth pages → send to feed
      if (isLoggedIn && isAuthPage) return RouteNames.feed;

      return null;
    },
    routes: [
      GoRoute(
        path: RouteNames.splash,
        name: 'splash',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: RouteNames.login,
        name: 'login',
        pageBuilder: (context, state) =>
            RouteTransitions.fade(child: const LoginScreen(), state: state),
      ),
      GoRoute(
        path: RouteNames.createAccount,
        name: 'create-account',
        pageBuilder: (context, state) => RouteTransitions.slideFromRight(
          child: const CreateAccountScreen(),
          state: state,
        ),
      ),
      GoRoute(
        path: RouteNames.feed,
        name: 'feed',
        pageBuilder: (context, state) =>
            RouteTransitions.fade(child: const FeedScreen(), state: state),
      ),
      GoRoute(
        path: RouteNames.profile,
        name: 'profile',
        pageBuilder: (context, state) {
          final extras = state.extra as Map<String, String>?;
          return RouteTransitions.slideFromRight(
            child: ProfileScreen(
              userId: extras?['userId'],
              userName: extras?['userName'],
            ),
            state: state,
          );
        },
      ),
    ],
    // Error page
    errorPageBuilder: (context, state) => MaterialPage(
      key: state.pageKey,
      child: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Error: ${state.error}', textAlign: TextAlign.center),
              16.ht,
              ElevatedButton(
                onPressed: () => context.go(RouteNames.splash),
                child: const Text('Return to Splash Screen'),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
