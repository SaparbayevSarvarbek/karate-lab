import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/theme/app_palette.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';

class OnboardingPageWidget extends StatelessWidget {
  final Map<String, String> data;

  const OnboardingPageWidget({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        AppSpacing.screenH.w,
        AppSpacing.sm.h,
        AppSpacing.screenH.w,
        AppSpacing.xxl.h,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          OnboardingIllustration(iconName: data['icon'] ?? 'sports_martial_arts'),
          SizedBox(height: AppSpacing.xxl.h),
          OnboardingPageTitle(title: data['title'] ?? ''),
          SizedBox(height: AppSpacing.md.h),
          OnboardingPageDescription(description: data['description'] ?? ''),
        ],
      ),
    );
  }
}

class OnboardingIllustration extends StatelessWidget {
  final String iconName;

  const OnboardingIllustration({super.key, required this.iconName});

  IconData get _icon {
    switch (iconName) {
      case 'fitness_center':
        return Icons.fitness_center_rounded;
      case 'people':
        return Icons.groups_rounded;
      default:
        return Icons.sports_martial_arts;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 4 / 3,
      child: Container(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [AppColors.primaryNavy, AppColors.primaryBlue],
            begin: AlignmentDirectional.topStart,
            end: AlignmentDirectional.bottomEnd,
          ),
          borderRadius: BorderRadius.circular(AppRadius.card.r),
        ),
        clipBehavior: Clip.antiAlias,
        child: Center(
          child: Icon(
            _icon,
            size: 120.w,
            color: Colors.white.withValues(alpha: 0.16),
          ),
        ),
      ),
    );
  }
}

class OnboardingPageTitle extends StatelessWidget {
  final String title;

  const OnboardingPageTitle({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      textAlign: TextAlign.center,
      style: AppTextStyles.screenTitle.copyWith(
        color: context.palette.textPrimary,
      ),
    );
  }
}

class OnboardingPageDescription extends StatelessWidget {
  final String description;

  const OnboardingPageDescription({super.key, required this.description});

  @override
  Widget build(BuildContext context) {
    return Text(
      description,
      textAlign: TextAlign.center,
      style: AppTextStyles.body.copyWith(
        color: context.palette.textSecondary,
      ),
    );
  }
}
