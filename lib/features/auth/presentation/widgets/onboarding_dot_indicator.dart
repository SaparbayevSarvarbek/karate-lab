import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';

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
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      margin: const EdgeInsets.only(right: 8),
      height: 8,
      width: isActive ? 24 : 8,
      decoration: BoxDecoration(
        color: isActive ? AppColors.primaryBlue : AppColors.border,
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }
}
