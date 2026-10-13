import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../constants/app_colors.dart';
import '../theme/app_radius.dart';
import '../theme/app_spacing.dart';
import '../theme/app_text_styles.dart';

/// Ro'yxatlarga yangi element qo'shish uchun yagona suzuvchi tugma.
///
/// Standart `FloatingActionButton.extended` dan farqi: soyasi yengil,
/// balandligi 48 (WCAG), matni brend uslubida va pill shaklida.
class AppFab extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onPressed;

  const AppFab({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon = Icons.add_rounded,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.primaryBlue,
      borderRadius: BorderRadius.circular(AppRadius.button.r),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(AppRadius.button.r),
        child: Container(
          height: 48.h,
          padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg.w),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 20.w, color: Colors.white),
              SizedBox(width: AppSpacing.sm.w),
              Text(
                label,
                style: AppTextStyles.button.copyWith(color: Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
