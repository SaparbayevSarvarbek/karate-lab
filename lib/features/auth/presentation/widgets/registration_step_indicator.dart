import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/l10n/app_translations.dart';
import '../../../../core/theme/app_palette.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';

/// Ro'yxatdan o'tish bosqichlari ko'rsatkichi — uch nuqtali bosqich
/// indikatori (stepper) va "Qadam X/Y" yozuvi.
class RegistrationStepIndicator extends StatelessWidget {
  final int currentStep;
  final int totalSteps;
  final String role;

  const RegistrationStepIndicator({
    super.key,
    required this.currentStep,
    required this.totalSteps,
    required this.role,
  });

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final isCoach = role == AppConstants.roleCoach;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              isCoach
                  ? Icons.assignment_ind_outlined
                  : Icons.sports_martial_arts,
              size: 16.w,
              color: palette.textSecondary,
            ),
            SizedBox(width: AppSpacing.xs.w),
            Text(
              isCoach ? 'Murabbiy' : 'Sportchi',
              style: AppTextStyles.caption.copyWith(
                color: palette.textSecondary,
              ),
            ),
            const Spacer(),
            Text(
              Tr.t('stepProgress', {
                'current': '${currentStep + 1}',
                'total': '$totalSteps',
              }),
              style: AppTextStyles.label.copyWith(
                color: palette.textSecondary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        SizedBox(height: AppSpacing.md.h),
        Row(
          children: [
            for (int i = 0; i < totalSteps; i++) ...[
              _StepDot(
                index: i,
                isCompleted: i < currentStep,
                isCurrent: i == currentStep,
                palette: palette,
              ),
              if (i < totalSteps - 1)
                Expanded(
                  child: Container(
                    height: 3.h,
                    margin: EdgeInsets.symmetric(horizontal: AppSpacing.xs.w),
                    decoration: BoxDecoration(
                      color: i < currentStep
                          ? AppColors.primaryBlue
                          : palette.border,
                      borderRadius: BorderRadius.circular(AppRadius.pill.r),
                    ),
                  ),
                ),
            ],
          ],
        ),
      ],
    );
  }
}

/// Stepper dagi bitta nuqta: tugallangan — ko'k + galoch, joriy — ko'k + raqam
/// (kattaroq, halqa bilan), kelajakdagi — kontur + xira raqam.
class _StepDot extends StatelessWidget {
  final int index;
  final bool isCompleted;
  final bool isCurrent;
  final AppPalette palette;

  const _StepDot({
    required this.index,
    required this.isCompleted,
    required this.isCurrent,
    required this.palette,
  });

  @override
  Widget build(BuildContext context) {
    final size = isCurrent ? 28.0 : 24.0;
    final isActive = isCompleted || isCurrent;

    return Container(
      width: size.w,
      height: size.w,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isActive ? AppColors.primaryBlue : palette.backgroundLight,
        border: Border.all(
          color: isActive ? AppColors.primaryBlue : palette.border,
          width: isCurrent ? 2.5 : 1.5,
        ),
      ),
      child: Center(
        child: isCompleted
            ? Icon(Icons.check_rounded, size: 15.w, color: palette.onBrand)
            : Text(
                '${index + 1}',
                style: AppTextStyles.label.copyWith(
                  color: isActive ? palette.onBrand : palette.textHint,
                  fontWeight: FontWeight.w600,
                ),
              ),
      ),
    );
  }
}
