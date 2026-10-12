import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../constants/app_colors.dart';
import '../theme/app_radius.dart';
import '../theme/app_text_styles.dart';

/// Ilova bo'ylab yagona asosiy tugma.
///
/// - Standart holatda to'liq kenglikka cho'ziladi (`expand: true`).
/// - `isOutlined` bilan konturli variant.
/// - `trailingIcon` bilan o'q belgisi (masalan "Davom etish →").
class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isOutlined;
  final bool isLoading;
  final bool expand;
  final double height;
  final IconData? leadingIcon;
  final IconData? trailingIcon;

  /// Fon rangi. Berilmasa — brend ko'ki (`AppColors.primaryBlue`).
  final Color? color;

  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isOutlined = false,
    this.isLoading = false,
    this.expand = true,
    this.height = 52,
    this.leadingIcon,
    this.trailingIcon,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final minSize = Size(expand ? double.infinity : 0, height.h);
    final shape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(AppRadius.button.r),
    );
    final child = _buildChild();

    if (isOutlined) {
      return OutlinedButton(
        onPressed: isLoading ? null : onPressed,
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primaryBlue,
          side: BorderSide(color: AppColors.primaryBlue.withValues(alpha: 0.5)),
          minimumSize: minSize,
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          shape: shape,
          textStyle: AppTextStyles.button,
        ),
        child: child,
      );
    }

    final background = color ?? AppColors.primaryBlue;

    return ElevatedButton(
      onPressed: isLoading ? null : onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: background,
        foregroundColor: Colors.white,
        disabledBackgroundColor: background.withValues(alpha: 0.45),
        disabledForegroundColor: Colors.white,
        elevation: 0,
        shadowColor: Colors.transparent,
        minimumSize: minSize,
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        shape: shape,
        textStyle: AppTextStyles.button,
      ),
      child: child,
    );
  }

  Widget _buildChild() {
    if (isLoading) {
      return SizedBox(
        width: 22.w,
        height: 22.w,
        child: const CircularProgressIndicator(
          strokeWidth: 2.2,
          color: Colors.white,
        ),
      );
    }

    if (leadingIcon == null && trailingIcon == null) {
      return Text(text, maxLines: 1, overflow: TextOverflow.ellipsis);
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (leadingIcon != null) ...[
          Icon(leadingIcon, size: 18.w),
          SizedBox(width: 8.w),
        ],
        Flexible(
          child: Text(text, maxLines: 1, overflow: TextOverflow.ellipsis),
        ),
        if (trailingIcon != null) ...[
          SizedBox(width: 8.w),
          Icon(trailingIcon, size: 18.w),
        ],
      ],
    );
  }
}
