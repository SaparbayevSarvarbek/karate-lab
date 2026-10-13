import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../theme/app_palette.dart';
import '../theme/app_radius.dart';
import '../theme/app_spacing.dart';
import '../theme/app_text_styles.dart';

/// Ilova bo'ylab yagona qidiruv maydoni.
///
/// Balandligi 48 — bosish maydoni WCAG talabiga mos. Matn kiritilganda
/// o'ng tomonda "tozalash" tugmasi chiqadi.
class AppSearchField extends StatefulWidget {
  final String hint;
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final bool autofocus;

  const AppSearchField({
    super.key,
    required this.hint,
    this.controller,
    this.onChanged,
    this.autofocus = false,
  });

  @override
  State<AppSearchField> createState() => _AppSearchFieldState();
}

class _AppSearchFieldState extends State<AppSearchField> {
  late final TextEditingController _controller =
      widget.controller ?? TextEditingController();
  late final bool _ownsController = widget.controller == null;

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onTextChanged);
  }

  void _onTextChanged() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _controller.removeListener(_onTextChanged);
    if (_ownsController) _controller.dispose();
    super.dispose();
  }

  void _clear() {
    _controller.clear();
    widget.onChanged?.call('');
  }

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final hasText = _controller.text.isNotEmpty;

    return SizedBox(
      height: 48.h,
      child: TextField(
        controller: _controller,
        autofocus: widget.autofocus,
        onChanged: widget.onChanged,
        textInputAction: TextInputAction.search,
        style: AppTextStyles.body.copyWith(color: palette.textPrimary),
        decoration: InputDecoration(
          hintText: widget.hint,
          hintStyle: AppTextStyles.body.copyWith(color: palette.textHint),
          filled: true,
          fillColor: palette.surface,
          isDense: true,
          contentPadding: EdgeInsets.symmetric(horizontal: AppSpacing.lg.w),
          prefixIcon: Icon(
            Icons.search_rounded,
            size: 20.w,
            color: palette.textHint,
          ),
          prefixIconConstraints: BoxConstraints(minWidth: 44.w, minHeight: 44.w),
          suffixIcon: hasText
              ? IconButton(
                  onPressed: _clear,
                  tooltip: 'Tozalash',
                  icon: Icon(
                    Icons.close_rounded,
                    size: 18.w,
                    color: palette.textHint,
                  ),
                )
              : null,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppRadius.button.r),
            borderSide: BorderSide(color: palette.border),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppRadius.button.r),
            borderSide: BorderSide(color: palette.border),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppRadius.button.r),
            borderSide: const BorderSide(color: Color(0xFF0066FF), width: 1.6),
          ),
        ),
      ),
    );
  }
}
