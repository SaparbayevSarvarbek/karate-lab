import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../constants/app_colors.dart';
import '../theme/app_palette.dart';
import '../theme/app_radius.dart';
import '../theme/app_spacing.dart';
import '../theme/app_text_styles.dart';

/// Filtr / segment chipi tavsifi.
class AppChipItem<T> {
  final T value;
  final String label;
  final IconData? icon;

  const AppChipItem({required this.value, required this.label, this.icon});
}

/// Gorizontal siljiydigan filtr chiplari qatori.
///
/// Vizual balandligi 36, lekin bosish maydoni 44 — WCAG talabiga mos.
/// Tanlangan chip to'ldirilgan (brend ko'k), qolganlari konturli.
class AppFilterChips<T> extends StatelessWidget {
  final List<AppChipItem<T>> items;
  final T selected;
  final ValueChanged<T> onSelected;
  final EdgeInsetsGeometry? padding;
  final bool scrollable;

  const AppFilterChips({
    super.key,
    required this.items,
    required this.selected,
    required this.onSelected,
    this.padding,
    this.scrollable = true,
  });

  @override
  Widget build(BuildContext context) {
    final horizontal =
        padding ?? EdgeInsets.symmetric(horizontal: AppSpacing.screenH.w);

    if (!scrollable) {
      return Padding(
        padding: horizontal,
        child: Row(
          children: [
            for (var i = 0; i < items.length; i++) ...[
              if (i > 0) SizedBox(width: AppSpacing.sm.w),
              Expanded(
                child: _Chip<T>(
                  item: items[i],
                  selected: items[i].value == selected,
                  fill: true,
                  onTap: () => onSelected(items[i].value),
                ),
              ),
            ],
          ],
        ),
      );
    }

    return SizedBox(
      height: 44.h,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: horizontal,
        itemCount: items.length,
        separatorBuilder: (_, _) => SizedBox(width: AppSpacing.sm.w),
        itemBuilder: (context, index) => _Chip<T>(
          item: items[index],
          selected: items[index].value == selected,
          onTap: () => onSelected(items[index].value),
        ),
      ),
    );
  }
}

class _Chip<T> extends StatelessWidget {
  final AppChipItem<T> item;
  final bool selected;
  final bool fill;
  final VoidCallback onTap;

  const _Chip({
    required this.item,
    required this.selected,
    required this.onTap,
    this.fill = false,
  });

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final foreground = selected ? Colors.white : palette.textSecondary;

    return Semantics(
      button: true,
      selected: selected,
      label: item.label,
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: Center(
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 160),
            curve: Curves.easeOut,
            width: fill ? double.infinity : null,
            height: 36.h,
            padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg.w),
            decoration: BoxDecoration(
              color: selected ? AppColors.primaryBlue : palette.surface,
              borderRadius: BorderRadius.circular(AppRadius.pill.r),
              border: Border.all(
                color: selected ? AppColors.primaryBlue : palette.border,
              ),
            ),
            child: Row(
              mainAxisSize: fill ? MainAxisSize.max : MainAxisSize.min,
              mainAxisAlignment: fill
                  ? MainAxisAlignment.center
                  : MainAxisAlignment.start,
              children: [
                if (item.icon != null) ...[
                  Icon(item.icon, size: 15.w, color: foreground),
                  SizedBox(width: AppSpacing.xs.w),
                ],
                Flexible(
                  child: Text(
                    item.label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.caption.copyWith(
                      color: foreground,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
