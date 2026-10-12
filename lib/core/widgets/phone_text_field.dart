import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../constants/app_colors.dart';
import '../theme/app_palette.dart';
import '../theme/app_radius.dart';
import '../theme/app_text_styles.dart';
import '../utils/uz_phone_formatter.dart';

/// Toza, izchil Material telefon raqam maydoni.
///
/// `+998` `prefixIcon` orqali **doim ko'rinadigan** qilib qo'yiladi (prefixText
/// emas — u bo'sh/oddiy holatda yashirinadi). Foydalanuvchi faqat mahalliy
/// raqamni kiritadi (`XX XXX XX XX`), formatlash va validatsiya ichkarida
/// bajariladi. Boshqa shakl maydonlari bilan bir xil uslubda (filled,
/// yumaloq, chegarali).
class PhoneTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final String? label;

  const PhoneTextField({
    super.key,
    required this.controller,
    this.hintText = 'XX XXX XX XX',
    this.label,
  });

  void _onChanged(String value) {
    final formatted = UzPhoneFormatter.field(value);
    if (formatted != value) {
      controller.value = TextEditingValue(
        text: formatted,
        selection: TextSelection.collapsed(offset: formatted.length),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    OutlineInputBorder border(Color color, [double width = 1]) {
      return OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppRadius.button.r),
        borderSide: BorderSide(color: color, width: width),
      );
    }

    final field = TextFormField(
      controller: controller,
      keyboardType: TextInputType.phone,
      style: TextStyle(fontSize: 16.sp, color: palette.textPrimary),
      onChanged: _onChanged,
      validator: (v) => UzPhoneFormatter.validateField(v ?? ''),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(color: palette.textHint, fontSize: 15.sp),
        prefixIcon: Padding(
          padding: EdgeInsetsDirectional.only(start: 16.w, end: 8.w),
          child: Text(
            '+998',
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              color: palette.textPrimary,
            ),
          ),
        ),
        prefixIconConstraints: const BoxConstraints(minWidth: 0, minHeight: 0),
        filled: true,
        fillColor: palette.backgroundLight,
        contentPadding: EdgeInsets.symmetric(vertical: 20.h),
        border: border(palette.border),
        enabledBorder: border(palette.border),
        focusedBorder: border(AppColors.primaryBlue, 2),
        errorBorder: border(AppColors.error),
        focusedErrorBorder: border(AppColors.error, 2),
        errorStyle: const TextStyle(color: AppColors.error, fontSize: 12.5),
      ),
    );

    if (label == null) return field;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label!,
          style: AppTextStyles.label.copyWith(color: palette.textSecondary),
        ),
        SizedBox(height: 8.h),
        field,
      ],
    );
  }
}
