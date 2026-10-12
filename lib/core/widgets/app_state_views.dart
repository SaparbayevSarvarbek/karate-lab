import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../constants/app_colors.dart';
import '../theme/app_palette.dart';
import '../theme/app_radius.dart';
import '../theme/app_text_styles.dart';
import 'custom_button.dart';

/// Bo'sh holat ko'rinishi (natija yo'q, ro'yxat bo'sh va h.k.).
///
/// Barcha ekranlarda bir xil uslubni saqlaydi.
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
    final content = Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 64.w,
          height: 64.w,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: AppColors.primaryBlue.withValues(alpha: 0.08),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, size: 28.w, color: AppColors.primaryBlue),
        ),
        SizedBox(height: 14.h),
        Text(
          title,
          textAlign: TextAlign.center,
          style: AppTextStyles.cardTitle.copyWith(color: palette.textPrimary),
        ),
        if (message != null && message!.isNotEmpty) ...[
          SizedBox(height: 6.h),
          Text(
            message!,
            textAlign: TextAlign.center,
            style: AppTextStyles.caption.copyWith(color: palette.textSecondary),
          ),
        ],
        if (actionLabel != null && onAction != null) ...[
          SizedBox(height: 18.h),
          CustomButton(
            text: actionLabel!,
            onPressed: onAction,
            isOutlined: true,
            expand: false,
          ),
        ],
      ],
    );

    return Center(
      child: Padding(
        padding: EdgeInsets.all(compact ? 16.w : 24.w),
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
        padding: EdgeInsets.all(24.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 64.w,
              height: 64.w,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: AppColors.error.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(AppRadius.card.r),
              ),
              child: Icon(Icons.cloud_off_rounded,
                  size: 28.w, color: AppColors.error),
            ),
            SizedBox(height: 14.h),
            Text(
              message,
              textAlign: TextAlign.center,
              style: AppTextStyles.body.copyWith(color: palette.textSecondary),
            ),
            if (onRetry != null) ...[
              SizedBox(height: 18.h),
              CustomButton(
                text: retryLabel,
                onPressed: onRetry,
                expand: false,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
