import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:etanaorokoapp/app/injection_container.dart';
import 'package:etanaorokoapp/core/enums/app_enums.dart';
import 'package:etanaorokoapp/core/theme/app_colors.dart';
import 'package:etanaorokoapp/core/router/route_names.dart';
import 'package:etanaorokoapp/core/widgets/snackbars/custom_snackbars.dart';
import 'package:etanaorokoapp/core/extensions/responsive_extension.dart';
import 'package:etanaorokoapp/features/auth/presentation/widgets/login_form.dart';
import 'package:etanaorokoapp/features/auth/presentation/widgets/auth_header.dart';
import 'package:etanaorokoapp/features/auth/presentation/widgets/auth_footer.dart';
import 'package:etanaorokoapp/features/auth/presentation/widgets/login_actions.dart';
import 'package:etanaorokoapp/features/auth/presentation/providers/login_provider.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => di<LoginProvider>(),
      child: const _LoginScreenContent(),
    );
  }
}

class _LoginScreenContent extends StatefulWidget {
  const _LoginScreenContent();

  @override
  State<_LoginScreenContent> createState() => _LoginScreenContentState();
}

class _LoginScreenContentState extends State<_LoginScreenContent> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _onSignIn() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    final provider = context.read<LoginProvider>();
    await provider.signIn(
      email: _emailController.text.trim(),
      password: _passwordController.text,
    );
    if (!mounted) return;
    if (provider.isSuccess) {
      context.go(RouteNames.feed);
    } else if (provider.errorMessage != null) {
      CustomSnackbar.show(
        context: context,
        message: provider.errorMessage!,
        type: SnackbarType.error,
      );
    }
  }

  Future<void> _onGoogleSignIn() async {
    final provider = context.read<LoginProvider>();
    await provider.signInWithGoogle();
    if (!mounted) return;
    if (provider.isSuccess) {
      context.go(RouteNames.feed);
    } else if (provider.errorMessage != null) {
      CustomSnackbar.show(
        context: context,
        message: provider.errorMessage!,
        type: SnackbarType.error,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) => SingleChildScrollView(
                padding: EdgeInsets.only(
                  left: 24.w,
                  right: 24.w,
                  top: MediaQuery.of(context).padding.top,
                ),
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const AuthHeader(
                          logoSize: 48,
                          title: 'Welcome Back',
                          subtitle: 'Sign in to continue to Etana Oroko',
                        ),
                        40.ht,
                        LoginForm(
                          emailController: _emailController,
                          passwordController: _passwordController,
                        ),
                        32.ht,
                        LoginActions(
                          onSignIn: _onSignIn,
                          onGoogleSignIn: _onGoogleSignIn,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          AuthFooter(
            message: "Don't have an account? ",
            actionText: 'Sign Up',
            onActionTap: () => context.push(RouteNames.createAccount),
          ),
        ],
      ),
    );
  }
}
