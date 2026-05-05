import 'package:flutter/material.dart';
import 'package:etanaorokoapp/core/theme/app_colors.dart';
import 'package:etanaorokoapp/core/theme/app_border_radius.dart';
import 'package:etanaorokoapp/core/extensions/context_extensions.dart';
import 'package:etanaorokoapp/core/extensions/responsive_extension.dart';
import 'package:etanaorokoapp/features/feed/presentation/widgets/post_card.dart';

/// Circular avatar showing a network photo (if available) or user initials
/// on a colored background.
///
/// When [backgroundColor] and [textColor] are not provided, colors are
/// auto-computed from [name] via [AvatarColors.forName] so the same user
/// always gets the same color everywhere.
class UserAvatarWidget extends StatelessWidget {
  /// User's display name — initials are derived automatically.
  final String name;

  /// Optional photo URL (e.g. Google profile photo).
  /// When provided, displays a network image instead of initials.
  final String? photoUrl;

  /// Diameter of the avatar circle.
  final double size;

  /// Background color of the circle. Auto-computed from [name] if null.
  final Color? backgroundColor;

  /// Text color for the initials. Auto-computed from [name] if null.
  final Color? textColor;

  /// Whether this is a placeholder (no name, shows icon).
  final bool _isPlaceholder;

  const UserAvatarWidget({
    super.key,
    required this.name,
    this.photoUrl,
    this.size = 40,
    this.backgroundColor,
    this.textColor,
  }) : _isPlaceholder = false;

  /// Placeholder avatar with a user icon instead of initials.
  const UserAvatarWidget.placeholder({
    super.key,
    this.size = 40,
    this.name = '',
    this.photoUrl,
    this.backgroundColor = AppColors.backgroundAlt,
    this.textColor = AppColors.textSecondary,
  }) : _isPlaceholder = true;

  String get _initials {
    if (name.trim().isEmpty) return '';
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return parts[0][0].toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    final responsiveSize = size.w;
    final fontSize = (size * 0.35).sp;

    // Show network image if photoUrl is available
    if (photoUrl != null && photoUrl!.isNotEmpty) {
      return Container(
        width: responsiveSize,
        height: responsiveSize,
        decoration: BoxDecoration(
          borderRadius: AppBorderRadius.avatar,
          border: Border.all(
            color: AppColors.borderMedium,
            width: size >= 40 ? 1 : 0.5,
          ),
          image: DecorationImage(
            image: NetworkImage(photoUrl!),
            fit: BoxFit.cover,
          ),
        ),
      );
    }

    // Resolve colors: use explicit values or auto-compute from name
    final Color resolvedBg;
    final Color resolvedText;
    if (backgroundColor != null && textColor != null) {
      resolvedBg = backgroundColor!;
      resolvedText = textColor!;
    } else if (_isPlaceholder || name.trim().isEmpty) {
      resolvedBg = AppColors.backgroundAlt;
      resolvedText = AppColors.textSecondary;
    } else {
      final colors = AvatarColors.forName(name);
      resolvedBg = backgroundColor ?? colors.background;
      resolvedText = textColor ?? colors.text;
    }

    return Container(
      width: responsiveSize,
      height: responsiveSize,
      decoration: BoxDecoration(
        color: resolvedBg,
        borderRadius: AppBorderRadius.avatar,
        border: Border.all(
          color: AppColors.borderMedium,
          width: size >= 40 ? 1 : 0.5,
        ),
      ),
      alignment: Alignment.center,
      child: _initials.isEmpty
          ? Icon(
              Icons.person_outline_rounded,
              size: (size * 0.5).sp,
              color: resolvedText,
            )
          : Text(
              _initials,
              style: context.textTheme.titleMedium?.copyWith(
                color: resolvedText,
                fontSize: fontSize,
                fontWeight: FontWeight.w600,
              ),
            ),
    );
  }
}
