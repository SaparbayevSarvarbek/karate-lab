import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/theme/app_palette.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_text_styles.dart';

/// Til tanlash kartasi — bayroq, nom, izoh va tanlanganlik belgisi bilan.
class LanguageOptionWidget extends StatelessWidget {
  final String title;
  final String subtitle;
  final String flag;
  final String code;
  final String selectedLanguage;
  final void Function(String) onTap;

  const LanguageOptionWidget({
    super.key,
    required this.title,
    required this.subtitle,
    required this.flag,
    required this.code,
    required this.selectedLanguage,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final isSelected = selectedLanguage == code;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => onTap(code),
        borderRadius: BorderRadius.circular(AppRadius.card.r),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeOut,
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            color: isSelected
                ? AppColors.primaryBlue.withValues(alpha: 0.06)
                : palette.surface,
            borderRadius: BorderRadius.circular(AppRadius.card.r),
            border: Border.all(
              color: isSelected ? AppColors.primaryBlue : palette.border,
              width: isSelected ? 1.5 : 1,
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 44.w,
                height: 44.w,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: palette.backgroundLight,
                  shape: BoxShape.circle,
                ),
                child: Text(flag, style: TextStyle(fontSize: 24.sp)),
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
                        color: isSelected
                            ? AppColors.primaryBlue
                            : palette.textPrimary,
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      subtitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.caption
                          .copyWith(color: palette.textSecondary),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 12.w),
              Icon(
                isSelected
                    ? Icons.check_circle
                    : Icons.radio_button_unchecked,
                size: 22.w,
                color: isSelected ? AppColors.primaryBlue : palette.border,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
