import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../constants/app_colors.dart';
import '../theme/app_palette.dart';
import '../theme/app_radius.dart';
import '../theme/app_spacing.dart';
import '../theme/app_text_styles.dart';
import 'app_card.dart';
import 'app_icon_tile.dart';
/// Ro'yxatdagi yagona element: ikonka plitasi + sarlavha + izoh + o'ng tomon.
///
/// Mashqlar, testlar, sportchilar va amallar ro'yxatlari shu widgetdan
/// quriladi — natijada barcha ro'yxatlar bir xil ritm va o'lchamda bo'ladi.
class AppListTile extends StatelessWidget {
  final IconData? icon;
  final Color? iconColor;
  final Widget? leading;
  final String title;
  final String? subtitle;
  final Widget? footer;
  final Widget? trailing;
  final VoidCallback? onTap;
  final bool showChevron;
  final EdgeInsetsGeometry? margin;

  const AppListTile({
    super.key,
    this.icon,
    this.iconColor,
    this.leading,
    required this.title,
    this.subtitle,
    this.footer,
    this.trailing,
    this.onTap,
    this.showChevron = false,
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final tint = iconColor ?? AppColors.primaryBlue;

    return AppCard.dense(
      margin: margin,
      onTap: onTap,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          leading ?? AppIconTile(icon: icon ?? Icons.circle, color: tint),
          SizedBox(width: AppSpacing.md.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.cardTitle
                      .copyWith(color: palette.textPrimary),
                ),
                if (subtitle != null && subtitle!.isNotEmpty) ...[
                  SizedBox(height: AppSpacing.xxs.h),
                  Text(
                    subtitle!,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.caption
                        .copyWith(color: palette.textSecondary),
                  ),
                ],
                if (footer != null) ...[
                  SizedBox(height: AppSpacing.sm.h),
                  footer!,
                ],
              ],
            ),
          ),
          if (trailing != null) ...[
            SizedBox(width: AppSpacing.sm.w),
            trailing!,
          ],
          if (showChevron) ...[
            SizedBox(width: AppSpacing.xs.w),
            Icon(
              Icons.chevron_right_rounded,
              size: 20.w,
              color: palette.textHint,
            ),
          ],
        ],
      ),
    );
  }
}

/// Karta ichidagi kichik meta yozuv (ikonka + matn) — masalan
/// "3 qadam · 90s".
class AppMetaRow extends StatelessWidget {
  final List<AppMeta> items;
  final double spacing;

  const AppMetaRow({super.key, required this.items, this.spacing = 12});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: spacing.w,
      runSpacing: AppSpacing.xs.h,
      children: items,
    );
  }
}

class AppMeta extends StatelessWidget {
  final IconData icon;
  final String text;
  final Color? color;

  const AppMeta({super.key, required this.icon, required this.text, this.color});

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final tint = color ?? palette.textSecondary;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 13.5.w, color: tint),
        SizedBox(width: 4.w),
        Text(
          text,
          style: AppTextStyles.caption.copyWith(color: tint),
        ),
      ],
    );
  }
}

/// Sarlavha + ixtiyoriy o'ng amal ko'rinishidagi kichik bo'lim ajratgichi.
class AppGroupLabel extends StatelessWidget {
  final String title;
  final EdgeInsetsGeometry padding;

  const AppGroupLabel({
    super.key,
    required this.title,
    this.padding = EdgeInsets.zero,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: Text(
        title.toUpperCase(),
        style: AppTextStyles.badge.copyWith(
          color: context.palette.textHint,
          letterSpacing: 0.8,
        ),
      ),
    );
  }
}

/// Karta ichidagi ingichka ajratgich (indent bilan).
class AppTileDivider extends StatelessWidget {
  final double indent;
  final double endIndent;

  const AppTileDivider({super.key, this.indent = 16, this.endIndent = 16});

  @override
  Widget build(BuildContext context) {
    return Divider(
      height: 1,
      thickness: 1,
      indent: indent.w,
      endIndent: endIndent.w,
      color: context.palette.divider,
    );
  }
}

/// Karta ichidagi yumaloq burchakli guruh (profil menyusi kabi).
class AppGroup extends StatelessWidget {
  final List<Widget> children;
  final EdgeInsetsGeometry? margin;

  const AppGroup({super.key, required this.children, this.margin});

  @override
  Widget build(BuildContext context) {
    final rows = <Widget>[];
    for (var i = 0; i < children.length; i++) {
      if (i > 0) rows.add(const AppTileDivider());
      rows.add(children[i]);
    }
    return AppCard(
      margin: margin,
      padding: EdgeInsets.zero,
      radius: AppRadius.card,
      child: Column(children: rows),
    );
  }
}

/// `AppGroup` ichidagi chegarasiz qator (profil menyusi elementlari).
///
/// Kartani `AppGroup` beradi, shuning uchun bu widget faqat qatorni chizadi.
class AppMenuRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;
  final bool danger;
  final Color? tint;

  const AppMenuRow({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
    this.trailing,
    this.onTap,
    this.danger = false,
    this.tint,
  });

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final accent = danger
        ? palette.error
        : (tint ?? AppColors.primaryBlue);

    final row = Padding(
      padding: EdgeInsets.symmetric(
        horizontal: AppSpacing.lg.w,
        vertical: AppSpacing.md.h,
      ),
      child: Row(
        children: [
          AppIconTile(icon: icon, color: accent, size: 40, radius: AppRadius.tile),
          SizedBox(width: AppSpacing.md.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.label.copyWith(
                    color: danger ? palette.error : palette.textPrimary,
                  ),
                ),
                if (subtitle != null && subtitle!.isNotEmpty) ...[
                  SizedBox(height: 2.h),
                  Text(
                    subtitle!,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.caption
                        .copyWith(color: palette.textSecondary),
                  ),
                ],
              ],
            ),
          ),
          if (trailing != null)
            trailing!
          else if (onTap != null)
            Icon(
              Icons.chevron_right_rounded,
              size: 20.w,
              color: palette.textHint,
            ),
        ],
      ),
    );

    if (onTap == null) return row;

    return InkWell(onTap: onTap, child: row);
  }
}
