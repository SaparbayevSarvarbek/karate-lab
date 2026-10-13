import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../theme/app_radius.dart';

/// Karta ichidagi yumaloq kvadrat ikonka plitasi (standart 44x44).
///
/// Fon rangi — berilgan rangning 12% shaffof varianti. Bu ilova bo'ylab
/// bir xil "rangli belgi" uslubini beradi va ro'yxatlarni tez o'qishga
/// yordam beradi.
class AppIconTile extends StatelessWidget {
  final IconData icon;
  final Color color;
  final double size;
  final double radius;

  const AppIconTile({
    super.key,
    required this.icon,
    required this.color,
    this.size = 44,
    this.radius = AppRadius.iconTile,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size.w,
      height: size.w,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(radius.r),
      ),
      child: Icon(icon, size: size.w * 0.5, color: color),
    );
  }
}
