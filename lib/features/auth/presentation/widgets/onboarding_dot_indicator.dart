import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/theme/app_palette.dart';
import '../../../../core/theme/app_radius.dart';

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
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        totalPages,
        (index) => OnboardingDot(isActive: index == currentPage),
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
      margin: EdgeInsets.only(right: 8.w),
      height: 8.w,
      width: isActive ? 20.w : 8.w,
      decoration: BoxDecoration(
        color: isActive ? AppColors.primaryBlue : palette.border,
        borderRadius: BorderRadius.circular(AppRadius.pill.r),
      ),
    );
  }
}
