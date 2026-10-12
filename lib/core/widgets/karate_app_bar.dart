import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../theme/app_palette.dart';
import 'karate_logo.dart';

/// Ilova bo'ylab yagona AppBar.
///
/// `showLogo` yoqilganda sarlavha oldida brend belgisi ko'rsatiladi
/// (setup/onboarding ekranlari uchun). Sub-sahifalarda faqat matnli
/// sarlavha ko'rsatiladi.
class KarateAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool showLogo;
  final List<Widget>? actions;
  final Widget? leading;
  final bool centerTitle;

  const KarateAppBar({
    super.key,
    required this.title,
    this.showLogo = false,
    this.actions,
    this.leading,
    this.centerTitle = true,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return AppBar(
      backgroundColor: palette.background,
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: centerTitle,
      leading: leading,
      automaticallyImplyLeading: leading == null,
      titleSpacing: 0,
      title: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (showLogo) ...[
            const KarateLabLogo(size: 26),
            SizedBox(width: 8.w),
          ],
          Flexible(
            child: Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w700,
                color: palette.textPrimary,
              ),
            ),
          ),
        ],
      ),
      actions: actions,
    );
  }
}
