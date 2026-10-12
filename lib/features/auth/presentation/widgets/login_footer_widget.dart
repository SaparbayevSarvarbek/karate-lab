import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/theme/app_palette.dart';
import '../../../../core/theme/app_text_styles.dart';

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
        GestureDetector(
          onTap: onRegister,
          behavior: HitTestBehavior.opaque,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
            child: Text(
              'Ro\'yxatdan o\'tish',
              style: AppTextStyles.body.copyWith(
                color: AppColors.primaryBlue,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
