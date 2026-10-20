import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../theme/app_palette.dart';
import '../theme/app_radius.dart';
import '../theme/app_spacing.dart';

/// Ilova bo'ylab **yagona** karta.
///
/// Ko'rinishi: `surface` fon + 1px `border` + `AppRadius.card` (18).
/// Og'ir soya ishlatilmaydi — qatlamlar fon rangi bilan ajratiladi
/// (shu sababli ro'yxat uzoq bo'lsa ham render yengil qoladi).
///
/// - `onTap` berilsa butun karta bosiladigan bo'ladi (ripple bilan).
/// - `tone` bilan rangli fon (masalan holat kartasi) berish mumkin.
class AppCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final VoidCallback? onTap;
  final Color? tone;
  final Color? borderColor;
  final double radius;

  const AppCard({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.onTap,
    this.tone,
    this.borderColor,
    this.radius = AppRadius.card,
  });

  /// Ichki bo'shliq kichikroq bo'lgan zich karta (ro'yxat elementlari).
  const AppCard.dense({
    super.key,
    required this.child,
    this.margin,
    this.onTap,
    this.tone,
    this.borderColor,
    this.radius = AppRadius.card,
  }) : padding = const EdgeInsets.all(AppSpacing.md);

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final resolvedRadius = BorderRadius.circular(radius.r);
    final decoration = BoxDecoration(
      color: tone ?? palette.surface,
      borderRadius: resolvedRadius,
      border: Border.all(color: borderColor ?? palette.border),
    );

    final content = Padding(
      padding: padding ?? EdgeInsets.all(AppSpacing.lg.w),
      child: child,
    );

    if (onTap == null) {
      return Container(margin: margin, decoration: decoration, child: content);
    }

    return Container(
      margin: margin,
      child: Material(
        color: Colors.transparent,
        borderRadius: resolvedRadius,
        clipBehavior: Clip.antiAlias,
        child: Ink(
          decoration: decoration,
          child: InkWell(
            onTap: onTap,
            borderRadius: resolvedRadius,
            child: content,
          ),
        ),
      ),
    );
  }
}
