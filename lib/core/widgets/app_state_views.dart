import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../constants/app_colors.dart';
import '../theme/app_palette.dart';
import '../theme/app_radius.dart';
import '../theme/app_spacing.dart';
import '../theme/app_text_styles.dart';
import 'custom_button.dart';

/// Bo'sh holat ko'rinishi (natija yo'q, ro'yxat bo'sh va h.k.).
///
/// Barcha ekranlarda bir xil uslubni saqlaydi: yumshoq rangli belgi,
/// qisqa sarlavha, izoh va ixtiyoriy amal tugmasi.
class AppEmptyView extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? message;
  final String? actionLabel;
  final VoidCallback? onAction;
  final bool compact;

  const AppEmptyView({
    super.key,
    required this.icon,
    required this.title,
    this.message,
    this.actionLabel,
    this.onAction,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final size = compact ? 64.0 : 76.0;

    final content = Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: size.w,
          height: size.w,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: palette.backgroundLight,
            borderRadius: BorderRadius.circular(AppRadius.panel.r),
            border: Border.all(color: palette.border),
          ),
          child: Icon(
            icon,
            size: (compact ? 28 : 32).w,
            color: AppColors.primaryBlue,
          ),
        ),
        SizedBox(height: AppSpacing.lg.h),
        Text(
          title,
          textAlign: TextAlign.center,
          style: AppTextStyles.cardTitle.copyWith(color: palette.textPrimary),
        ),
        if (message != null && message!.isNotEmpty) ...[
          SizedBox(height: AppSpacing.sm.h),
          Text(
            message!,
            textAlign: TextAlign.center,
            style: AppTextStyles.caption.copyWith(color: palette.textSecondary),
          ),
        ],
        if (actionLabel != null && onAction != null) ...[
          SizedBox(height: AppSpacing.xl.h),
          CustomButton(
            text: actionLabel!,
            onPressed: onAction,
            isOutlined: true,
            expand: false,
            height: 46,
          ),
        ],
      ],
    );

    return Center(
      child: Padding(
        padding: EdgeInsets.all(compact ? AppSpacing.lg.w : AppSpacing.xxl.w),
        child: content,
      ),
    );
  }
}

/// Xatolik holati ko'rinishi.
class AppErrorView extends StatelessWidget {
  final String message;
  final VoidCallback? onRetry;
  final String retryLabel;

  const AppErrorView({
    super.key,
    required this.message,
    this.onRetry,
    this.retryLabel = 'Qayta urinish',
  });

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;

    return Center(
      child: Padding(
        padding: EdgeInsets.all(AppSpacing.xxl.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 76.w,
              height: 76.w,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: palette.error.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(AppRadius.panel.r),
                border: Border.all(
                  color: palette.error.withValues(alpha: 0.18),
                ),
              ),
              child: Icon(
                Icons.cloud_off_rounded,
                size: 32.w,
                color: palette.error,
              ),
            ),
            SizedBox(height: AppSpacing.lg.h),
            Text(
              message,
              textAlign: TextAlign.center,
              style: AppTextStyles.body.copyWith(color: palette.textSecondary),
            ),
            if (onRetry != null) ...[
              SizedBox(height: AppSpacing.xl.h),
              CustomButton(
                text: retryLabel,
                onPressed: onRetry,
                expand: false,
                height: 46,
                leadingIcon: Icons.refresh_rounded,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Yuklanish holati — markazda yumshoq indikator.
///
/// Ro'yxatlar uchun `shimmer_placeholder.dart` dagi skeletlar ishlatiladi;
/// bu esa qisqa/aniq bloklar uchun.
class AppLoadingView extends StatelessWidget {
  final String? label;

  const AppLoadingView({super.key, this.label});

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 26.w,
            height: 26.w,
            child: const CircularProgressIndicator(strokeWidth: 2.4),
          ),
          if (label != null) ...[
            SizedBox(height: AppSpacing.md.h),
            Text(
              label!,
              style: AppTextStyles.caption.copyWith(
                color: palette.textSecondary,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
