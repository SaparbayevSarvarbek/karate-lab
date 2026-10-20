import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/theme/app_palette.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/karate_logo.dart';

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
          OnboardingIllustration(
            imagePath: data['image'] ?? 'assets/images/karate_do.jpg',
          ),
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
  final String imagePath;

  const OnboardingIllustration({super.key, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 4 / 3,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppRadius.panel.r),
        ),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset(imagePath, fit: BoxFit.cover),
            Positioned(
              top: AppSpacing.md.h,
              left: AppSpacing.md.w,
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: AppSpacing.sm.w,
                  vertical: AppSpacing.xs.h,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.94),
                  borderRadius: BorderRadius.circular(AppRadius.pill.r),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    KarateLabLogo(size: 28.w),
                    SizedBox(width: AppSpacing.xs.w),
                    Text(
                      'KarateLab AI',
                      style: AppTextStyles.caption.copyWith(
                        color: context.palette.textPrimary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
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
      style: AppTextStyles.body.copyWith(color: context.palette.textSecondary),
    );
  }
}
