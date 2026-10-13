import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../theme/app_palette.dart';
import '../theme/app_radius.dart';
import '../theme/app_spacing.dart';
import '../theme/app_text_styles.dart';
import 'app_card.dart';

/// Statistika kartasi — kichik ikonka, katta raqam va izoh.
///
/// Uchtadan qatorga qo'yish uchun mo'ljallangan (`compact: true`),
/// yoki bitta keng variant sifatida.
class AppStatCard extends StatelessWidget {
  final String value;
  final String label;
  final IconData icon;
  final Color color;
  final bool compact;

  const AppStatCard({
    super.key,
    required this.value,
    required this.label,
    required this.icon,
    required this.color,
    this.compact = true,
  });

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;

    return AppCard(
      padding: EdgeInsets.all((compact ? AppSpacing.md : AppSpacing.lg).w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: (compact ? 32 : 38).w,
            height: (compact ? 32 : 38).w,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(AppRadius.tile.r),
            ),
            child: Icon(icon, size: (compact ? 17 : 20).w, color: color),
          ),
          SizedBox(height: AppSpacing.md.h),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: AlignmentDirectional.centerStart,
            child: Text(
              value,
              maxLines: 1,
              style: (compact ? AppTextStyles.title : AppTextStyles.stat)
                  .copyWith(color: palette.textPrimary),
            ),
          ),
          SizedBox(height: AppSpacing.xxs.h),
          Text(
            label,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.caption.copyWith(color: palette.textSecondary),
          ),
        ],
      ),
    );
  }
}
