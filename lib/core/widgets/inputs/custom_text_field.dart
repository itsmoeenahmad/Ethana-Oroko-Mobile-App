import '../../enums/app_enums.dart';
import '../../theme/app_colors.dart';
import '../../utils/validators.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../extensions/context_extensions.dart';
import '../../extensions/responsive_extension.dart';

/// Text field with theme styling. Validation errors render in a **fixed-height**
/// slot below the input so the field box stays [height] tall in all states.
class CustomTextField extends StatefulWidget {
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final String? hint, title;
  final String? errorText;
  final bool obscureText;
  final TextInputType? keyboardType;
  final IconData? prefixIcon;
  final String? prefixText;
  final Widget? suffixIcon;
  final void Function(String)? onChanged;
  final List<TextInputFormatter>? inputFormatters;
  final int? maxLines;
  final bool enabled;
  final bool readOnly;
  final VoidCallback? onTap;
  final double? height, width;
  final TextAlign textAlign;
  final int? maxLength;
  final double? borderRadius;
  final Color? prefixIconColor;
  final TextStyle? hintStyle;
  final bool enableValidation;
  final TextFieldType fieldType;
  final String? Function(String?)? customValidator;

  const CustomTextField({
    super.key,
    this.focusNode,
    this.height,
    this.title,
    this.width,
    this.controller,
    this.hint,
    this.errorText,
    this.obscureText = false,
    this.keyboardType,
    this.prefixIcon,
    this.suffixIcon,
    this.onChanged,
    this.maxLength,
    this.inputFormatters,
    this.maxLines = 1,
    this.enabled = true,
    this.readOnly = false,
    this.onTap,
    this.enableValidation = true,
    this.fieldType = TextFieldType.text,
    this.prefixText,
    this.textAlign = TextAlign.start,
    this.customValidator,
    this.borderRadius,
    this.prefixIconColor,
    this.hintStyle,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  final GlobalKey<FormFieldState<String>> _fieldKey =
      GlobalKey<FormFieldState<String>>();

  double get _fieldHeight => widget.height ?? 56.h;

  @override
  void didUpdateWidget(CustomTextField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      final state = _fieldKey.currentState;
      if (state != null) {
        state.didChange(widget.controller?.text ?? '');
      }
    }
  }

  String? _validate(String? value) {
    if (!widget.enableValidation) return null;

    if (widget.customValidator != null) {
      return widget.customValidator!(value);
    }

    switch (widget.fieldType) {
      case TextFieldType.email:
        return Validators.validateEmail(value);
      case TextFieldType.password:
        return Validators.validatePassword(value);
      case TextFieldType.name:
        return Validators.validateName(value);
      case TextFieldType.phone:
        return Validators.validatePhone(value);
      case TextFieldType.text:
        return Validators.validateRequired(value, widget.hint ?? 'Field');
      case TextFieldType.number:
        return Validators.validateNumberOnly(value, widget.hint ?? 'Field');
    }
  }

  TextInputType _keyboardType() {
    switch (widget.fieldType) {
      case TextFieldType.email:
        return TextInputType.emailAddress;
      case TextFieldType.password:
        return TextInputType.text;
      case TextFieldType.name:
        return TextInputType.name;
      case TextFieldType.phone:
        return TextInputType.phone;
      case TextFieldType.text:
        return TextInputType.text;
      case TextFieldType.number:
        return TextInputType.number;
    }
  }

  TextCapitalization _textCapitalization() {
    switch (widget.fieldType) {
      case TextFieldType.name:
        return TextCapitalization.words;
      case TextFieldType.email:
      case TextFieldType.password:
      case TextFieldType.phone:
      case TextFieldType.text:
      case TextFieldType.number:
        return TextCapitalization.none;
    }
  }

  InputDecoration _decoration(BuildContext context) {
    final colorScheme = context.colorScheme;
    final textTheme = context.textTheme;
    final r = widget.borderRadius;

    if (r != null) {
      final br = BorderRadius.circular(r);
      return InputDecoration(
        hintText: widget.hint,
        hintStyle: widget.hintStyle,
        alignLabelWithHint: true,
        border: OutlineInputBorder(
          borderRadius: br,
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: br,
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: br,
          borderSide: BorderSide.none,
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: br,
          borderSide: BorderSide.none,
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: br,
          borderSide: BorderSide.none,
        ),
        prefixIcon: widget.prefixIcon != null
            ? Icon(
                widget.prefixIcon,
                size: 20.w,
                color: widget.prefixIconColor ?? AppColors.textPrimary,
              )
            : widget.prefixText != null
            ? Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 12.w,
                  vertical: 14.h,
                ),
                child: Text(
                  widget.prefixText!,
                  style: textTheme.labelLarge?.copyWith(
                    color: colorScheme.onSurface,
                  ),
                ),
              )
            : null,
        suffixIcon: widget.suffixIcon,
        filled: true,
        isDense: true,
        counterText: widget.maxLength != null ? '' : null,
      );
    }

    return InputDecoration(
      hintText: widget.hint,
      hintStyle: widget.hintStyle,
      alignLabelWithHint: true,
      prefixIcon: widget.prefixIcon != null
          ? Icon(
              widget.prefixIcon,
              size: 20.w,
              color: widget.prefixIconColor ?? AppColors.textPrimary,
            )
          : widget.prefixText != null
          ? Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 12.w,
                vertical: 14.h,
              ),
              child: Text(
                widget.prefixText!,
                style: textTheme.labelLarge?.copyWith(
                  color: colorScheme.onSurface,
                ),
              ),
            )
          : null,
      suffixIcon: widget.suffixIcon,
      filled: true,
      isDense: true,
      counterText: widget.maxLength != null ? '' : null,
    );
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = context.textTheme;
    final errorStyle = textTheme.bodySmall?.copyWith(color: AppColors.error);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.title != null) ...[
          Text(
            widget.title!,
            style: textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w500),
          ),
          5.ht,
        ],
        FormField<String>(
          key: _fieldKey,
          initialValue: widget.controller?.text ?? '',
          enabled: widget.enabled,
          autovalidateMode: AutovalidateMode.disabled,
          validator: widget.enableValidation ? _validate : (_) => null,
          builder: (field) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(
                  height: _fieldHeight,
                  width: widget.width ?? double.infinity,
                  child: TextField(
                    controller: widget.controller,
                    focusNode: widget.focusNode,
                    textAlign: widget.textAlign,
                    obscureText: widget.obscureText,
                    cursorColor: AppColors.black,
                    keyboardType: widget.keyboardType ?? _keyboardType(),
                    onChanged: (val) {
                      field.didChange(val);
                      if (field.hasError) {
                        field.validate();
                      }
                      widget.onChanged?.call(val);
                    },
                    inputFormatters: widget.inputFormatters,
                    textCapitalization: _textCapitalization(),
                    maxLines: widget.maxLines,
                    enabled: widget.enabled,
                    readOnly: widget.readOnly,
                    onTap: widget.onTap,
                    maxLength: widget.maxLength,
                    style: textTheme.bodyLarge?.copyWith(color: AppColors.black),
                    decoration: _decoration(context),
                    onTapOutside: (_) => FocusScope.of(context).unfocus(),
                  ),
                ),
                if (widget.enableValidation)
                  AnimatedSize(
                    duration: const Duration(milliseconds: 180),
                    curve: Curves.easeOutCubic,
                    alignment: Alignment.topLeft,
                    child: field.hasError
                        ? Padding(
                            padding: EdgeInsets.only(top: 6.h),
                            child: SizedBox(
                              height: 18.h,
                              width: double.infinity,
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  field.errorText ?? '',
                                  maxLines: 1,
                                  softWrap: false,
                                  overflow: TextOverflow.ellipsis,
                                  style: errorStyle,
                                ),
                              ),
                            ),
                          )
                        : const SizedBox.shrink(),
                  ),
              ],
            );
          },
        ),
      ],
    );
  }
}
