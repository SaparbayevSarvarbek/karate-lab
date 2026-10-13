import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../constants/app_colors.dart';
import '../theme/app_radius.dart';

/// Gradientli katta panel (bosh sahifa hero bloklari, test sarlavhasi).
///
/// Orqa fonda brend belgisi juda past shaffoflikda turadi — bu bo'sh
/// gradientdan ko'ra "tayyorlangan" ko'rinadi va qo'shimcha rasm
/// yuklamaydi (vektor ikonka, render yengil).
class AppHeroPanel extends StatelessWidget {
  final Widget child;
  final IconData? watermark;
  final EdgeInsetsGeometry padding;
  final double radius;
  final List<Color>? colors;

  const AppHeroPanel({
    super.key,
    required this.child,
    this.watermark,
    this.padding = const EdgeInsets.all(20),
    this.radius = AppRadius.panel,
    this.colors,
  });

  @override
  Widget build(BuildContext context) {
    final resolvedRadius = BorderRadius.circular(radius.r);
    final p = padding.resolve(Directionality.of(context));

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: colors ??
              const [AppColors.primaryNavy, AppColors.gradientDeepBlue],
          begin: AlignmentDirectional.topStart,
          end: AlignmentDirectional.bottomEnd,
        ),
        borderRadius: resolvedRadius,
      ),
      child: ClipRRect(
        borderRadius: resolvedRadius,
        child: Stack(
          children: [
            if (watermark != null)
              PositionedDirectional(
                end: -24.w,
                bottom: -28.h,
                child: Icon(
                  watermark,
                  size: 138.w,
                  color: Colors.white.withValues(alpha: 0.07),
                ),
              ),
            Padding(
              padding: EdgeInsets.fromLTRB(p.left.w, p.top.h, p.right.w, p.bottom.h),
              child: child,
            ),
          ],
        ),
      ),
    );
  }
}
