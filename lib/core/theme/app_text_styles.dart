import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Ilova bo'ylab yagona matn uslublari.
///
/// Ranglar bu yerda berilmaydi — sahifada `context.palette` dan olinib
/// `.copyWith(color: ...)` orqali qo'shiladi. Shu tufayli bir xil uslub
/// light va dark rejimda ham to'g'ri ishlaydi.
class AppTextStyles {
  AppTextStyles._();

  /// Ekran sarlavhasi (masalan "Rolingizni tanlang").
  static TextStyle get screenTitle => TextStyle(
        fontSize: 25.sp,
        fontWeight: FontWeight.w800,
        height: 1.15,
        letterSpacing: -0.4,
      );

  /// Katta brend sarlavhasi (login / onboarding).
  static TextStyle get brandTitle => TextStyle(
        fontSize: 28.sp,
        fontWeight: FontWeight.w800,
        height: 1.1,
        letterSpacing: -0.6,
      );

  /// Bo'lim sarlavhasi.
  static TextStyle get sectionTitle => TextStyle(
        fontSize: 17.5.sp,
        fontWeight: FontWeight.w800,
        height: 1.2,
      );

  /// Karta sarlavhasi.
  static TextStyle get cardTitle => TextStyle(
        fontSize: 15.sp,
        fontWeight: FontWeight.w700,
        height: 1.25,
      );

  /// Maydon ustidagi kichik yozuv (label).
  static TextStyle get label => TextStyle(
        fontSize: 13.sp,
        fontWeight: FontWeight.w600,
        height: 1.2,
      );

  /// Asosiy matn.
  static TextStyle get body => TextStyle(
        fontSize: 14.sp,
        fontWeight: FontWeight.w500,
        height: 1.4,
      );

  /// Yordamchi (ikkinchi darajali) matn.
  static TextStyle get caption => TextStyle(
        fontSize: 12.5.sp,
        fontWeight: FontWeight.w500,
        height: 1.35,
      );

  /// Kichik badge / chip matni.
  static TextStyle get badge => TextStyle(
        fontSize: 11.sp,
        fontWeight: FontWeight.w700,
        letterSpacing: 0.5,
      );

  /// Tugma matni.
  static TextStyle get button => TextStyle(
        fontSize: 15.sp,
        fontWeight: FontWeight.w700,
      );
}
