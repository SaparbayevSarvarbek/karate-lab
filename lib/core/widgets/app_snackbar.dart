import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../theme/app_palette.dart';
import '../theme/app_radius.dart';
import '../theme/app_spacing.dart';
import '../theme/app_text_styles.dart';

enum AppSnackTone { neutral, success, error, warning, info }

/// Ilova bo'ylab yagona xabar (snackbar).
///
/// Fon har doim mavzuga mos yuza bo'ladi; holat esa chap tomondagi
/// rangli ikonka va chegara rangi bilan beriladi. Shu tufayli xabar
/// light va dark rejimda ham o'qiladi.
class AppSnackbar {
  AppSnackbar._();

  static void show(
    BuildContext context,
    String message, {
    AppSnackTone tone = AppSnackTone.neutral,
    IconData? icon,
  }) {
    final palette = context.palette;
    final color = switch (tone) {
      AppSnackTone.neutral => palette.textSecondary,
      AppSnackTone.success => palette.success,
      AppSnackTone.error => palette.error,
      AppSnackTone.warning => palette.warning,
      AppSnackTone.info => palette.info,
    };
    final resolvedIcon = icon ??
        switch (tone) {
          AppSnackTone.neutral => Icons.info_outline_rounded,
          AppSnackTone.success => Icons.check_circle_outline_rounded,
          AppSnackTone.error => Icons.error_outline_rounded,
          AppSnackTone.warning => Icons.warning_amber_rounded,
          AppSnackTone.info => Icons.info_outline_rounded,
        };

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          backgroundColor: palette.surface,
          elevation: 0,
          duration: const Duration(seconds: 3),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.button.r),
            side: BorderSide(color: color.withValues(alpha: 0.4)),
          ),
          content: Row(
            children: [
              Icon(resolvedIcon, size: 19.w, color: color),
              SizedBox(width: AppSpacing.sm.w),
              Expanded(
                child: Text(
                  message,
                  style: AppTextStyles.body.copyWith(
                    color: palette.textPrimary,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
  }

  static void error(BuildContext context, String message) =>
      show(context, message, tone: AppSnackTone.error);

  static void success(BuildContext context, String message) =>
      show(context, message, tone: AppSnackTone.success);

  static void info(BuildContext context, String message) =>
      show(context, message, tone: AppSnackTone.info);

  static void warning(BuildContext context, String message) =>
      show(context, message, tone: AppSnackTone.warning);

  static void neutral(BuildContext context, String message) =>
      show(context, message);
}
