import 'package:flutter/material.dart';

/// Ilova bo'ylab yagona xom (raw) ranglar.
///
/// Sahifalarda to'g'ridan-to'g'ri ishlatilmaydi — kontekstga bog'liq
/// yuzalar va matnlar uchun `context.palette` (AppPalette) ishlatiladi.
/// Bu yerdagi ranglar brend va **grafik** (ikonka, chizma, gradient) uchun.
///
/// Diqqat: kichik matn sifatida ishlatiladigan holat ranglari
/// (`palette.success`, `palette.warning`, ...) dan olinadi — ular light va
/// dark rejimda WCAG AA kontrastni ta'minlaydi. Bu yerdagi `success` /
/// `warning` esa yorqinroq variant: faqat ikonka va grafika uchun (3:1).
class AppColors {
  AppColors._();

  // ── Brend ──────────────────────────────────────────────────────────────
  static const Color primaryBlue = Color(0xFF0066FF);
  static const Color primaryBlueLight = Color(0xFF3D8BFF);
  static const Color primaryBlueDark = Color(0xFF0047B3);
  static const Color primaryNavy = Color(0xFF0F172A);
  static const Color primaryDark = Color(0xFF1A1F2E);
  static const Color gradientDeepBlue = Color(0xFF1E3A8A);

  // ── Fon (light rejim) ──────────────────────────────────────────────────
  /// Sahifa foni — oq emas, juda och kulrang. Kartalar shu fondan
  /// "ko'tarilib" turadi, shuning uchun interfeys tekis ko'rinmaydi.
  static const Color backgroundPage = Color(0xFFF4F6FB);

  /// Maydon / chip / ikonka foni uchun yengil to'ldirish rangi.
  static const Color backgroundLight = Color(0xFFEDF1F7);
  static const Color backgroundWhite = Color(0xFFFFFFFF);
  static const Color cardBackground = Color(0xFFFFFFFF);

  // ── Matn (light rejim) ─────────────────────────────────────────────────
  static const Color textPrimary = Color(0xFF101828);
  static const Color textSecondary = Color(0xFF55647C);
  static const Color textHint = Color(0xFF66748C);
  static const Color textWhite = Color(0xFFFFFFFF);

  // ── Holat ranglari (grafik uchun yorqin variant) ───────────────────────
  static const Color successBright = Color(0xFF16A34A);
  static const Color warningBright = Color(0xFFE08700);
  static const Color errorBright = Color(0xFFE11D48);
  static const Color infoBright = Color(0xFF2563EB);

  static const Color success = successBright;
  static const Color warning = warningBright;
  static const Color error = errorBright;
  static const Color info = infoBright;

  // ── Chegara / ajratgich ────────────────────────────────────────────────
  static const Color border = Color(0xFFE3E8F0);
  static const Color divider = Color(0xFFEEF1F6);

  // ── Nishonlar ──────────────────────────────────────────────────────────
  static const Color eliteBadge = Color(0xFF10B981);
  static const Color injuredBadge = Color(0xFFEF4444);

  // ── Daraja / kategoriya tuslari ────────────────────────────────────────
  static const Color beginner = Color(0xFF2563EB);
  static const Color intermediate = Color(0xFFD97706);
  static const Color advanced = Color(0xFFDC2626);
  static const Color expert = Color(0xFF7C3AED);
  static const Color purple = Color(0xFF7C3AED);
  static const Color teal = Color(0xFF0D9488);

  // ── Medal ──────────────────────────────────────────────────────────────
  static const Color medalGold = Color(0xFFD4A017);
  static const Color medalSilver = Color(0xFF94A3B8);
  static const Color medalBronze = Color(0xFFB45309);
}
