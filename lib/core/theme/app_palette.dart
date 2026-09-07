import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

/// Kontekst-ga bog'liq semantik ranglar palitrasi.
///
/// Light va Dark rejimlarda avtomatik o'zgaradigan yuzalar/matnlar/chegaralar
/// shu yerga jamlangan. Brand ranglari (primaryBlue, success, ...) `AppColors`
/// da statik qoladi. Sahifalarda `context.palette.xxx` orqali olinadi.
class AppPalette extends ThemeExtension<AppPalette> {
  final Color background;
  final Color backgroundLight;
  final Color surface;
  final Color card;
  final Color textPrimary;
  final Color textSecondary;
  final Color textHint;
  final Color textWhite;
  final Color border;
  final Color divider;
  final Color onBrand;

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
  });

  static const light = AppPalette(
    background: AppColors.backgroundWhite,
    backgroundLight: AppColors.backgroundLight,
    surface: AppColors.backgroundWhite,
    card: AppColors.cardBackground,
    textPrimary: AppColors.textPrimary,
    textSecondary: AppColors.textSecondary,
    textHint: AppColors.textHint,
    textWhite: Colors.white,
    border: AppColors.border,
    divider: AppColors.divider,
    onBrand: Colors.white,
  );

  static const dark = AppPalette(
    background: Color(0xFF0F172A),
    backgroundLight: Color(0xFF1A2130),
    surface: Color(0xFF252B3B),
    card: Color(0xFF1A2130),
    textPrimary: Color(0xFFF1F5F9),
    textSecondary: Color(0xFF94A3B8),
    textHint: Color(0xFF64748B),
    textWhite: Colors.white,
    border: Color(0xFF2E3648),
    divider: Color(0xFF1A2130),
    onBrand: Colors.white,
  );

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
    );
  }
}

extension PaletteContext on BuildContext {
  AppPalette get palette => Theme.of(this).extension<AppPalette>()!;
}
