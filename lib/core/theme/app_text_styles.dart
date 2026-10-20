import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Ilova bo'ylab yagona matn uslublari.
///
/// Ranglar bu yerda berilmaydi — sahifada `context.palette` dan olinib
/// `.copyWith(color: ...)` orqali qo'shiladi. Shu tufayli bir xil uslub
/// light va dark rejimda ham to'g'ri ishlaydi.
///
/// Shkala 4 bosqichli: sarlavha → bo'lim → karta → tana → izoh.
class AppTextStyles {
  AppTextStyles._();

  /// Katta brend sarlavhasi (login / onboarding).
  static TextStyle get brandTitle => TextStyle(
    fontSize: 28.sp,
    fontWeight: FontWeight.w800,
    height: 1.12,
    letterSpacing: -0.7,
  );

  /// Ekran sarlavhasi (masalan "Rolingizni tanlang").
  static TextStyle get screenTitle => TextStyle(
    fontSize: 24.sp,
    fontWeight: FontWeight.w800,
    height: 1.16,
    letterSpacing: -0.5,
  );

  /// Katta raqam / karta sarlavhasi.
  static TextStyle get title => TextStyle(
    fontSize: 20.sp,
    fontWeight: FontWeight.w800,
    height: 1.2,
    letterSpacing: -0.3,
  );

  /// Bo'lim sarlavhasi.
  static TextStyle get sectionTitle => TextStyle(
    fontSize: 17.sp,
    fontWeight: FontWeight.w800,
    height: 1.25,
    letterSpacing: -0.2,
  );

  /// Karta sarlavhasi.
  static TextStyle get cardTitle =>
      TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w700, height: 1.3);

  /// Maydon ustidagi kichik yozuv (label).
  static TextStyle get label =>
      TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w600, height: 1.25);

  /// Asosiy matn.
  static TextStyle get body =>
      TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500, height: 1.45);

  /// Yordamchi (ikkinchi darajali) matn.
  static TextStyle get caption =>
      TextStyle(fontSize: 12.5.sp, fontWeight: FontWeight.w500, height: 1.35);

  /// Kichik badge / chip matni.
  static TextStyle get badge => TextStyle(
    fontSize: 11.5.sp,
    fontWeight: FontWeight.w700,
    height: 1.1,
    letterSpacing: 0.3,
  );

  /// Pastki navigatsiya yozuvi.
  static TextStyle get navLabel => TextStyle(
    fontSize: 10.5.sp,
    fontWeight: FontWeight.w600,
    height: 1.1,
    letterSpacing: 0.1,
  );

  /// Tugma matni.
  static TextStyle get button => TextStyle(
    fontSize: 15.sp,
    fontWeight: FontWeight.w700,
    letterSpacing: 0.1,
  );

  /// Karta ichidagi katta raqam (statistika).
  static TextStyle get stat => TextStyle(
    fontSize: 26.sp,
    fontWeight: FontWeight.w800,
    height: 1.05,
    letterSpacing: -0.6,
  );
}
