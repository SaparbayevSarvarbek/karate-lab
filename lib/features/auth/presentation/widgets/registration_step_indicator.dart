import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/l10n/app_translations.dart';
import '../../../../core/theme/app_palette.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_step_badge.dart';

/// Ro'yxatdan o'tish bosqichlari ko'rsatkichi — qadam belgisi, rol nomi va
/// progress bar.
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
            AppStepBadge(
              label: Tr.t('stepProgress', {
                'current': '${currentStep + 1}',
                'total': '$totalSteps',
              }),
              icon: Icons.tune_rounded,
            ),
            const Spacer(),
            Icon(
              isCoach ? Icons.assignment_ind_outlined : Icons.sports_martial_arts,
              size: 14.w,
              color: palette.textSecondary,
            ),
            SizedBox(width: 4.w),
            Text(
              isCoach ? 'Murabbiy' : 'Sportchi',
              style: AppTextStyles.caption
                  .copyWith(color: palette.textSecondary),
            ),
          ],
        ),
        SizedBox(height: 12.h),
        ClipRRect(
          borderRadius: BorderRadius.circular(999.r),
          child: LinearProgressIndicator(
            value: (currentStep + 1) / totalSteps,
            backgroundColor: palette.border,
            color: AppColors.primaryBlue,
            minHeight: 6.h,
          ),
        ),
      ],
    );
  }
}
