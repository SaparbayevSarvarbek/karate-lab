import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../theme/app_palette.dart';
import '../theme/app_spacing.dart';
import '../theme/app_text_styles.dart';
import 'karate_logo.dart';
import 'remote_image.dart';

/// Ilova bo'ylab **yagona** yuqori panel.
///
/// Barcha sahifalar shundan foydalanadi — shunda balandlik, shrift, orqaga
/// tugmasi va fon rangi hamma joyda bir xil bo'ladi.
///
/// - `showLogo: true` — asosiy (tab) sahifalar: brend belgisi + bo'lim nomi
///   chapga tekislangan, orqaga tugmasi ko'rsatilmaydi.
/// - `showAvatar: true` — logo o'rniga foydalanuvchi rasmi (bosh sahifalar).
///   `avatarUrl` berilmasa — ism bosh harflari ko'rsatiladi.
/// - `subtitle` — sarlavha ostidagi kichik yozuv (masalan salomlashish).
/// - `showLogo: false` — ichki sahifalar: orqaga tugmasi + markazlashgan
///   sarlavha.
/// - `actions` — o'ng tomondagi amallar (masalan bildirishnoma qo'ng'irog'i).
class KarateAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final String? subtitle;
  final bool showLogo;
  final bool showAvatar;
  final String? avatarUrl;
  final List<Widget>? actions;
  final Widget? leading;
  final bool? centerTitle;

  const KarateAppBar({
    super.key,
    required this.title,
    this.subtitle,
    this.showLogo = false,
    this.showAvatar = false,
    this.avatarUrl,
    this.actions,
    this.leading,
    this.centerTitle,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 1);

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final canPop = ModalRoute.of(context)?.canPop ?? false;
    final effectiveLeading =
        leading ??
        (canPop
            ? IconButton(
                icon: const Icon(Icons.arrow_back_rounded),
                color: palette.textPrimary,
                onPressed: () => Navigator.of(context).maybePop(),
              )
            : null);

    final showBrand = showAvatar || showLogo;

    return AppBar(
      backgroundColor: palette.background,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: centerTitle ?? !showBrand,
      leading: effectiveLeading,
      automaticallyImplyLeading: false,
      titleSpacing: showBrand ? AppSpacing.screenH : null,
      title: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (showAvatar) ...[
            AvatarImage(url: avatarUrl, name: title, size: 34),
            SizedBox(width: AppSpacing.sm.w),
          ] else if (showLogo) ...[
            const KarateLabLogo(size: 26),
            SizedBox(width: AppSpacing.sm.w),
          ],
          Flexible(
            child: subtitle == null
                ? Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.sectionTitle.copyWith(
                      color: palette.textPrimary,
                    ),
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.sectionTitle.copyWith(
                          color: palette.textPrimary,
                        ),
                      ),
                      Text(
                        subtitle!,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.caption.copyWith(
                          color: palette.textSecondary,
                        ),
                      ),
                    ],
                  ),
          ),
        ],
      ),
      actions: actions,
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1),
        child: Container(height: 1, color: palette.divider),
      ),
    );
  }
}
