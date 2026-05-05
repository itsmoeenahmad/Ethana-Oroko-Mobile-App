import 'package:flutter/material.dart';
import 'package:etanaorokoapp/core/enums/app_enums.dart';
import 'package:etanaorokoapp/core/theme/app_colors.dart';
import 'package:etanaorokoapp/core/extensions/responsive_extension.dart';
import 'package:etanaorokoapp/core/widgets/inputs/custom_text_field.dart';

class LoginForm extends StatefulWidget {
  final TextEditingController emailController;
  final TextEditingController passwordController;

  const LoginForm({
    super.key,
    required this.emailController,
    required this.passwordController,
  });

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _obscurePassword = ValueNotifier<bool>(true);

  @override
  void dispose() {
    _obscurePassword.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomTextField(
          controller: widget.emailController,
          title: 'Email Address',
          hint: 'hello@example.com',
          prefixIcon: Icons.email_outlined,
          prefixIconColor: AppColors.textTertiary,
          fieldType: TextFieldType.email,
        ),
        16.ht,

        // Password field — only this rebuilds on toggle
        ValueListenableBuilder<bool>(
          valueListenable: _obscurePassword,
          builder: (context, obscure, _) => CustomTextField(
            controller: widget.passwordController,
            title: 'Password',
            hint: '••••••••',
            obscureText: obscure,
            prefixIcon: Icons.lock_outline,
            prefixIconColor: AppColors.textTertiary,
            fieldType: TextFieldType.password,
            suffixIcon: IconButton(
              icon: Icon(
                obscure
                    ? Icons.visibility_outlined
                    : Icons.visibility_off_outlined,
                color: AppColors.textTertiary,
                size: 20.w,
              ),
              onPressed: () => _obscurePassword.value = !obscure,
            ),
          ),
        ),
      ],
    );
  }
}
