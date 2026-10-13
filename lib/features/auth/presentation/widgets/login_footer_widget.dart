import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/theme/app_palette.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';

/// Login sahifasining pastidagi "Ro'yxatdan o'tish" havolasi.
///
/// Havola bosish maydoni 44 dan kichik bo'lsa barmoq bilan tegish qiyin
/// bo'ladi — shu sababli `minHeight` 44 ga majburlangan.
class LoginFooterWidget extends StatelessWidget {
  final VoidCallback onRegister;

  const LoginFooterWidget({super.key, required this.onRegister});

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Hisobingiz yo\'qmi?',
          style: AppTextStyles.body.copyWith(color: palette.textSecondary),
        ),
        Semantics(
          button: true,
          child: InkWell(
            onTap: onRegister,
            borderRadius: BorderRadius.circular(AppRadius.xs.r),
            child: Container(
              constraints: BoxConstraints(minHeight: 44.h),
              alignment: Alignment.center,
              padding: EdgeInsets.symmetric(horizontal: AppSpacing.sm.w),
              child: Text(
                'Ro\'yxatdan o\'tish',
                style: AppTextStyles.body.copyWith(
                  color: AppColors.primaryBlue,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
