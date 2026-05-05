import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:etanaorokoapp/app/injection_container.dart';
import 'package:etanaorokoapp/core/enums/app_enums.dart';
import 'package:etanaorokoapp/core/theme/app_colors.dart';
import 'package:etanaorokoapp/core/router/route_names.dart';
import 'package:etanaorokoapp/core/widgets/snackbars/custom_snackbars.dart';
import 'package:etanaorokoapp/core/theme/app_border_radius.dart';
import 'package:etanaorokoapp/core/extensions/responsive_extension.dart';
import 'package:etanaorokoapp/core/widgets/animated/primary_button.dart';
import 'package:etanaorokoapp/features/auth/presentation/widgets/auth_header.dart';
import 'package:etanaorokoapp/features/auth/presentation/widgets/auth_footer.dart';
import 'package:etanaorokoapp/features/auth/presentation/widgets/create_account_form.dart';
import 'package:etanaorokoapp/features/auth/presentation/providers/create_account_provider.dart';

class CreateAccountScreen extends StatelessWidget {
  const CreateAccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => di<CreateAccountProvider>(),
      child: const _CreateAccountScreenContent(),
    );
  }
}

class _CreateAccountScreenContent extends StatefulWidget {
  const _CreateAccountScreenContent();

  @override
  State<_CreateAccountScreenContent> createState() =>
      _CreateAccountScreenContentState();
}

class _CreateAccountScreenContentState
    extends State<_CreateAccountScreenContent> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _onCreateAccount() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    final provider = context.read<CreateAccountProvider>();
    await provider.createAccount(
      name: _nameController.text.trim(),
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

  @override
  Widget build(BuildContext context) {
    final isLoading = context.select<CreateAccountProvider, bool>(
      (p) => p.isLoading,
    );

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.only(
                left: 24.w,
                right: 24.w,
                top: MediaQuery.of(context).padding.top + 32.h,
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    const AuthHeader(
                      logoSize: 40,
                      title: 'Create Account',
                      subtitle: 'Join the Oroko Community',
                    ),
                    32.ht,
                    CreateAccountForm(
                      nameController: _nameController,
                      emailController: _emailController,
                      passwordController: _passwordController,
                      confirmPasswordController: _confirmPasswordController,
                    ),
                    32.ht,
                    PrimaryButton(
                      text: 'Create Account',
                      borderRadius: AppBorderRadius.s16,
                      isLoading: isLoading,
                      onPressed: _onCreateAccount,
                    ),
                    16.ht,
                  ],
                ),
              ),
            ),
          ),
          AuthFooter(
            message: 'Already have an account? ',
            actionText: 'Login',
            onActionTap: () => context.pop(),
          ),
        ],
      ),
    );
  }
}
