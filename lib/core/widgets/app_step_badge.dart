import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../constants/app_colors.dart';
import '../theme/app_radius.dart';
import '../theme/app_text_styles.dart';

/// Setup ekranlaridagi kichik belgi — masalan "SOZLASH · 1 / 3".
///
/// Ko'k fon ustida ko'k matn, ixtiyoriy ikonka bilan.
class AppStepBadge extends StatelessWidget {
  final String label;
  final IconData? icon;
  final Color? color;

  const AppStepBadge({
    super.key,
    required this.label,
    this.icon,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final tint = color ?? AppColors.primaryBlue;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
      decoration: BoxDecoration(
        color: tint.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppRadius.pill.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 12.w, color: tint),
            SizedBox(width: 5.w),
          ],
          Text(
            label.toUpperCase(),
            style: AppTextStyles.badge.copyWith(color: tint),
          ),
        ],
      ),
    );
  }
}
