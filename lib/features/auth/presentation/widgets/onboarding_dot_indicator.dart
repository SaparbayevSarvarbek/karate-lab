import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/theme/app_palette.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';

/// Onboarding sahifalari uchun nuqtali ko'rsatkich.
class OnboardingDotIndicator extends StatelessWidget {
  final int currentPage;
  final int totalPages;

  const OnboardingDotIndicator({
    super.key,
    required this.currentPage,
    required this.totalPages,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: '${currentPage + 1}/$totalPages',
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(
          totalPages,
          (index) => OnboardingDot(isActive: index == currentPage),
        ),
      ),
    );
  }
}

class OnboardingDot extends StatelessWidget {
  final bool isActive;

  const OnboardingDot({super.key, required this.isActive});

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeOut,
      margin: EdgeInsetsDirectional.only(end: AppSpacing.sm.w),
      height: AppSpacing.sm.w,
      width: isActive ? AppSpacing.xl.w : AppSpacing.sm.w,
      decoration: BoxDecoration(
        color: isActive ? AppColors.primaryBlue : palette.border,
        borderRadius: BorderRadius.circular(AppRadius.pill.r),
      ),
    );
  }
}
