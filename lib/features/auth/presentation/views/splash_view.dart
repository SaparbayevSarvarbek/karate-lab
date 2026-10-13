import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/services/shared_prefs_service.dart';
import '../../../../core/theme/app_palette.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/karate_logo.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  @override
  void initState() {
    super.initState();
    _navigate();
  }

  Future<void> _navigate() async {
    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;

    final prefs = await SharedPrefsService.getInstance();
    final isFirstTime = await prefs.isFirstTimeLaunch();
    final accessToken = prefs.getAccessToken();
    final role = await prefs.getSelectedRole() ?? AppConstants.roleAthlete;

    if (!mounted) return;
    if (!isFirstTime && accessToken != null && accessToken.isNotEmpty) {
      context.go('/main', extra: role);
    } else if (isFirstTime) {
      context.go('/language');
    } else {
      context.go('/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.palette.background,
      body: const SplashBody(),
    );
  }
}

class SplashBody extends StatelessWidget {
  const SplashBody({super.key});

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Center(
              child: TweenAnimationBuilder<double>(
                tween: Tween(begin: 0, end: 1),
                duration: const Duration(milliseconds: 700),
                curve: Curves.easeOutCubic,
                builder: (context, t, child) => Opacity(
                  opacity: t,
                  child: Transform.scale(scale: 0.92 + 0.08 * t, child: child),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const KarateLabLogo(size: 88),
                    SizedBox(height: AppSpacing.xxl.h),
                    Text(
                      'KarateLab AI',
                      textAlign: TextAlign.center,
                      style: AppTextStyles.brandTitle
                          .copyWith(color: palette.textPrimary),
                    ),
                    SizedBox(height: AppSpacing.sm.h),
                    Text(
                      'AI yordamida chempionlik sari',
                      textAlign: TextAlign.center,
                      style: AppTextStyles.caption
                          .copyWith(color: palette.textSecondary),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: AppSpacing.xxxl.h),
            child: Center(
              child: SizedBox(
                width: 22.w,
                height: 22.w,
                child: const CircularProgressIndicator(
                  strokeWidth: 2.4,
                  color: AppColors.primaryBlue,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
