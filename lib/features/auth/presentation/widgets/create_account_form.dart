import 'package:flutter/material.dart';
import 'package:etanaorokoapp/core/enums/app_enums.dart';
import 'package:etanaorokoapp/core/theme/app_colors.dart';
import 'package:etanaorokoapp/core/utils/validators.dart';
import 'package:etanaorokoapp/core/extensions/context_extensions.dart';
import 'package:etanaorokoapp/core/extensions/responsive_extension.dart';
import 'package:etanaorokoapp/core/widgets/inputs/custom_text_field.dart';

class CreateAccountForm extends StatelessWidget {
  final TextEditingController nameController;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final TextEditingController confirmPasswordController;

  const CreateAccountForm({
    super.key,
    required this.nameController,
    required this.emailController,
    required this.passwordController,
    required this.confirmPasswordController,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = context.textTheme;

    return Column(
      children: [
        CustomTextField(
          controller: nameController,
          title: 'Full Name',
          hint: 'John Doe',
          prefixIcon: Icons.person_outline,
          prefixIconColor: AppColors.textTertiary,
          fieldType: TextFieldType.name,
        ),
        16.ht,
        CustomTextField(
          controller: emailController,
          title: 'Email Address',
          hint: 'hello@example.com',
          prefixIcon: Icons.email_outlined,
          prefixIconColor: AppColors.textTertiary,
          fieldType: TextFieldType.email,
        ),
        16.ht,
        CustomTextField(
          controller: passwordController,
          title: 'Password',
          hint: '••••••••',
          obscureText: true,
          prefixIcon: Icons.lock_outline,
          prefixIconColor: AppColors.textTertiary,
          fieldType: TextFieldType.password,
        ),
        Padding(
          padding: EdgeInsets.only(left: 4.w, top: 4.h),
          child: Row(
            children: [
              Icon(
                Icons.info_outline,
                size: 14.sp,
                color: AppColors.textTertiary,
              ),
              6.wt,
              Text(
                'Must be at least 8 characters',
                style: textTheme.bodySmall?.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
        16.ht,
        CustomTextField(
          controller: confirmPasswordController,
          title: 'Confirm Password',
          hint: '••••••••',
          obscureText: true,
          prefixIcon: Icons.lock_outline,
          prefixIconColor: AppColors.textTertiary,
          fieldType: TextFieldType.password,
          customValidator: (value) => Validators.validateConfirmPassword(
            value,
            passwordController.text,
          ),
        ),
      ],
    );
  }
}
