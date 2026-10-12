import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../theme/app_palette.dart';

/// Ekran pastida yopishib turadigan amal paneli (asosiy CTA uchun).
///
/// Safe area va ustki chegara avtomatik qo'shiladi.
class AppBottomBar extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;

  const AppBottomBar({super.key, required this.child, this.padding});

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return Container(
      decoration: BoxDecoration(
        color: palette.background,
        border: Border(top: BorderSide(color: palette.border)),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: padding ?? EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 12.h),
          child: child,
        ),
      ),
    );
  }
}
