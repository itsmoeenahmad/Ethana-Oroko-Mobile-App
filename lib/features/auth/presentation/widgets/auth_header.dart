import 'package:flutter/material.dart';
import 'package:etanaorokoapp/core/theme/app_colors.dart';
import 'package:etanaorokoapp/core/extensions/context_extensions.dart';
import 'package:etanaorokoapp/core/extensions/responsive_extension.dart';
import 'package:etanaorokoapp/core/widgets/more/app_logo_widget.dart';

class AuthHeader extends StatelessWidget {
  final double logoSize;
  final String title;
  final String subtitle;

  const AuthHeader({
    super.key,
    required this.logoSize,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = context.textTheme;

    return Column(
      children: [
        AppLogoWidget(size: logoSize),
        20.ht,
        Text(title, style: textTheme.displayMedium),
        6.ht,
        Text(
          subtitle,
          style: textTheme.bodyMedium?.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }
}
