import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../theme/app_palette.dart';
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

  const PhoneTextField({
    super.key,
    required this.controller,
    this.hintText = 'XX XXX XX XX',
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
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: color, width: width),
      );
    }

    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.phone,
      style: TextStyle(fontSize: 16, color: palette.textPrimary),
      onChanged: _onChanged,
      validator: (v) => UzPhoneFormatter.validateField(v ?? ''),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(color: palette.textHint),
        prefixIcon: Padding(
          padding: const EdgeInsets.only(left: 16, right: 8),
          child: Text(
            '+998',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: palette.textPrimary,
            ),
          ),
        ),
        prefixIconConstraints: const BoxConstraints(minWidth: 0, minHeight: 0),
        filled: true,
        fillColor: palette.backgroundLight,
        contentPadding: const EdgeInsets.symmetric(vertical: 16),
        border: border(palette.border),
        enabledBorder: border(palette.border),
        focusedBorder: border(AppColors.primaryBlue, 2),
        errorBorder: border(AppColors.error),
        focusedErrorBorder: border(AppColors.error, 2),
        errorStyle: const TextStyle(color: AppColors.error, fontSize: 12),
      ),
    );
  }
}
