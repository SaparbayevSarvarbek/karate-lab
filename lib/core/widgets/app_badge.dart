import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../theme/app_radius.dart';
import '../theme/app_text_styles.dart';

/// Kichik yorliq (badge / chip / status).
///
/// `filled` — rangli fon (standart, holat uchun), `outlined` — faqat chegara.
class AppBadge extends StatelessWidget {
  final String label;
  final Color color;
  final IconData? icon;
  final bool filled;
  final bool dense;

  const AppBadge({
    super.key,
    required this.label,
    required this.color,
    this.icon,
    this.filled = true,
    this.dense = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: (dense ? 8 : 10).w,
        vertical: (dense ? 3 : 5).h,
      ),
      decoration: BoxDecoration(
        color: filled ? color.withValues(alpha: 0.12) : Colors.transparent,
        borderRadius: BorderRadius.circular(AppRadius.pill.r),
        border: filled
            ? null
            : Border.all(color: color.withValues(alpha: 0.45)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 12.5.w, color: color),
            SizedBox(width: 4.w),
          ],
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.badge.copyWith(color: color, letterSpacing: 0),
          ),
        ],
      ),
    );
  }
}
