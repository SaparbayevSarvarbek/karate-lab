import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../constants/app_colors.dart';
import '../theme/app_palette.dart';
import '../theme/app_radius.dart';
import '../theme/app_text_styles.dart';

/// Tanlov kartasi — rol, guruh va shunga o'xshash variantlar uchun.
///
/// Chapda yumaloq ikonka, o'rtada sarlavha va izoh, o'ngda tanlanganlik
/// belgisi (yoki `trailingLabel` pill'i). Setup ekranlarida ishlatiladi.
class AppSelectionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final bool selected;
  final bool enabled;
  final String? trailingLabel;
  final VoidCallback? onTap;

  const AppSelectionCard({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
    this.selected = false,
    this.enabled = true,
    this.trailingLabel,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final accent = enabled ? AppColors.primaryBlue : palette.textHint;

    return Opacity(
      opacity: enabled ? 1 : 0.65,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppRadius.card.r),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            curve: Curves.easeOut,
            padding: EdgeInsets.all(14.w),
            decoration: BoxDecoration(
              color: selected
                  ? AppColors.primaryBlue.withValues(alpha: 0.06)
                  : palette.surface,
              borderRadius: BorderRadius.circular(AppRadius.card.r),
              border: Border.all(
                color: selected ? AppColors.primaryBlue : palette.border,
                width: selected ? 1.5 : 1,
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 44.w,
                  height: 44.w,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: accent.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(14.r),
                  ),
                  child: Icon(icon, size: 22.w, color: accent),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.cardTitle.copyWith(
                          color: selected
                              ? AppColors.primaryBlue
                              : palette.textPrimary,
                        ),
                      ),
                      if (subtitle != null && subtitle!.isNotEmpty) ...[
                        SizedBox(height: 2.h),
                        Text(
                          subtitle!,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyles.caption
                              .copyWith(color: palette.textSecondary),
                        ),
                      ],
                    ],
                  ),
                ),
                SizedBox(width: 10.w),
                _trailing(palette, accent),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _trailing(AppPalette palette, Color accent) {
    if (trailingLabel != null) {
      return Container(
        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
        decoration: BoxDecoration(
          color: palette.textHint.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(AppRadius.pill.r),
        ),
        child: Text(
          trailingLabel!,
          style: AppTextStyles.badge
              .copyWith(color: palette.textHint, letterSpacing: 0),
        ),
      );
    }
    if (selected) {
      return Icon(Icons.check_circle, size: 22.w, color: AppColors.primaryBlue);
    }
    return Icon(
      Icons.radio_button_unchecked,
      size: 22.w,
      color: palette.border,
    );
  }
}
