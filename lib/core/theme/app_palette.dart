import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

/// Kontekstga bog'liq semantik ranglar palitrasi.
///
/// Light va Dark rejimda avtomatik o'zgaradigan yuzalar / matnlar / chegaralar
/// shu yerga jamlangan. Sahifalarda faqat `context.palette.xxx` orqali
/// olinadi — shunda ikkala rejim ham to'g'ri ishlaydi.
///
/// Qatlamlar (light): `background` (sahifa) → `surface` (karta) →
/// `backgroundLight` (maydon/ikonka to'ldirishi).
class AppPalette extends ThemeExtension<AppPalette> {
  /// Sahifa foni.
  final Color background;

  /// Maydon, chip va ikonka plitalari uchun yengil to'ldirish.
  final Color backgroundLight;

  /// Karta / panel yuzasi.
  final Color surface;

  /// `surface` bilan bir xil — eski kod bilan moslik uchun saqlanadi.
  final Color card;

  final Color textPrimary;
  final Color textSecondary;
  final Color textHint;
  final Color textWhite;
  final Color border;
  final Color divider;
  final Color onBrand;

  /// Kichik matn sifatida ham ishlatiladigan holat ranglari
  /// (WCAG AA — ikkala rejimda 4.5:1 dan yuqori).
  final Color success;
  final Color warning;
  final Color error;
  final Color info;

  const AppPalette({
    required this.background,
    required this.backgroundLight,
    required this.surface,
    required this.card,
    required this.textPrimary,
    required this.textSecondary,
    required this.textHint,
    required this.textWhite,
    required this.border,
    required this.divider,
    required this.onBrand,
    required this.success,
    required this.warning,
    required this.error,
    required this.info,
  });

  static const light = AppPalette(
    background: AppColors.backgroundPage,
    backgroundLight: AppColors.backgroundLight,
    surface: AppColors.cardBackground,
    card: AppColors.cardBackground,
    textPrimary: AppColors.textPrimary,
    textSecondary: AppColors.textSecondary,
    textHint: AppColors.textHint,
    textWhite: Colors.white,
    border: AppColors.border,
    divider: AppColors.divider,
    onBrand: Colors.white,
    success: Color(0xFF15803D),
    warning: Color(0xFFB45309),
    error: Color(0xFFDC2626),
    info: Color(0xFF1D4ED8),
  );

  static const dark = AppPalette(
    background: Color(0xFF0F172A),
    backgroundLight: Color(0xFF232C3E),
    surface: Color(0xFF1B2333),
    card: Color(0xFF1B2333),
    textPrimary: Color(0xFFF1F5F9),
    textSecondary: Color(0xFF94A3B8),
    textHint: Color(0xFF8B9AB3),
    textWhite: Colors.white,
    border: Color(0xFF2C3648),
    divider: Color(0xFF232C3E),
    onBrand: Colors.white,
    success: Color(0xFF4ADE80),
    warning: Color(0xFFFBBF24),
    error: Color(0xFFF87171),
    info: Color(0xFF60A5FA),
  );

  /// Karta va sahifa fonini ajratib turadigan yumshoq chegara.
  bool get isDark => background == AppPalette.dark.background;

  @override
  AppPalette copyWith({
    Color? background,
    Color? backgroundLight,
    Color? surface,
    Color? card,
    Color? textPrimary,
    Color? textSecondary,
    Color? textHint,
    Color? textWhite,
    Color? border,
    Color? divider,
    Color? onBrand,
    Color? success,
    Color? warning,
    Color? error,
    Color? info,
  }) {
    return AppPalette(
      background: background ?? this.background,
      backgroundLight: backgroundLight ?? this.backgroundLight,
      surface: surface ?? this.surface,
      card: card ?? this.card,
      textPrimary: textPrimary ?? this.textPrimary,
      textSecondary: textSecondary ?? this.textSecondary,
      textHint: textHint ?? this.textHint,
      textWhite: textWhite ?? this.textWhite,
      border: border ?? this.border,
      divider: divider ?? this.divider,
      onBrand: onBrand ?? this.onBrand,
      success: success ?? this.success,
      warning: warning ?? this.warning,
      error: error ?? this.error,
      info: info ?? this.info,
    );
  }

  @override
  AppPalette lerp(ThemeExtension<AppPalette>? other, double t) {
    if (other is! AppPalette) return this;
    return AppPalette(
      background: Color.lerp(background, other.background, t)!,
      backgroundLight: Color.lerp(backgroundLight, other.backgroundLight, t)!,
      surface: Color.lerp(surface, other.surface, t)!,
      card: Color.lerp(card, other.card, t)!,
      textPrimary: Color.lerp(textPrimary, other.textPrimary, t)!,
      textSecondary: Color.lerp(textSecondary, other.textSecondary, t)!,
      textHint: Color.lerp(textHint, other.textHint, t)!,
      textWhite: Color.lerp(textWhite, other.textWhite, t)!,
      border: Color.lerp(border, other.border, t)!,
      divider: Color.lerp(divider, other.divider, t)!,
      onBrand: Color.lerp(onBrand, other.onBrand, t)!,
      success: Color.lerp(success, other.success, t)!,
      warning: Color.lerp(warning, other.warning, t)!,
      error: Color.lerp(error, other.error, t)!,
      info: Color.lerp(info, other.info, t)!,
    );
  }
}

extension PaletteContext on BuildContext {
  AppPalette get palette => Theme.of(this).extension<AppPalette>()!;
}
