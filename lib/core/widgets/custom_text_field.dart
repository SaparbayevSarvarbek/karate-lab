import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../theme/app_palette.dart';
import '../theme/app_text_styles.dart';

/// Ilova bo'ylab yagona matn maydoni.
///
/// `label` berilsa maydon ustida kichik sarlavha chiqadi — bu formani
/// o'qishni ancha osonlashtiradi.
class CustomTextField extends StatelessWidget {
  final String hintText;
  final String? label;
  final TextEditingController? controller;
  final bool obscureText;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final String? prefixText;
  final String? suffixText;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;

  const CustomTextField({
    super.key,
    required this.hintText,
    this.label,
    this.controller,
    this.obscureText = false,
    this.prefixIcon,
    this.suffixIcon,
    this.prefixText,
    this.suffixText,
    this.keyboardType = TextInputType.text,
    this.validator,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final hintColor = context.palette.textHint;
    final field = TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      validator: validator,
      onChanged: onChanged,
      decoration: InputDecoration(
        hintText: hintText,
        prefixIcon: prefixIcon != null
            ? IconTheme(data: IconThemeData(color: hintColor), child: prefixIcon!)
            : null,
        prefixText: prefixText,
        suffixText: suffixText,
        suffixIcon: suffixIcon != null
            ? IconTheme(data: IconThemeData(color: hintColor), child: suffixIcon!)
            : null,
      ),
    );

    if (label == null) return field;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label!,
          style: AppTextStyles.label
              .copyWith(color: context.palette.textSecondary),
        ),
        SizedBox(height: 8.h),
        field,
      ],
    );
  }
}
