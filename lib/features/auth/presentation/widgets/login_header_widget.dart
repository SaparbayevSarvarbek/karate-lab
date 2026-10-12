import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/app_palette.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/karate_logo.dart';

class LoginHeaderWidget extends StatelessWidget {
  const LoginHeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const LoginLogoIcon(),
        SizedBox(height: AppSpacing.xxl.h),
        const LoginWelcomeTitle(),
        SizedBox(height: AppSpacing.sm.h),
        const LoginWelcomeSubtitle(),
      ],
    );
  }
}

class LoginLogoIcon extends StatelessWidget {
  const LoginLogoIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return const KarateLabLogo(size: 64);
  }
}

class LoginWelcomeTitle extends StatelessWidget {
  const LoginWelcomeTitle({super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      'KarateLab AI',
      textAlign: TextAlign.center,
      style: AppTextStyles.screenTitle.copyWith(
        color: context.palette.textPrimary,
      ),
    );
  }
}

class LoginWelcomeSubtitle extends StatelessWidget {
  const LoginWelcomeSubtitle({super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      'Profilingizga kiring',
      textAlign: TextAlign.center,
      style: AppTextStyles.caption.copyWith(
        color: context.palette.textSecondary,
      ),
    );
  }
}
