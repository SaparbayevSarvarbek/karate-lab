import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import 'app_palette.dart';

class AppTheme {
  static ThemeData get lightTheme => _build(AppPalette.light);

  static ThemeData get darkTheme => _build(AppPalette.dark);

  static ThemeData _build(AppPalette palette) {
    final isDark = palette.background == AppPalette.dark.background;
    return ThemeData(
      brightness: isDark ? Brightness.dark : Brightness.light,
      primaryColor: AppColors.primaryBlue,
      scaffoldBackgroundColor: palette.background,
      colorScheme: ColorScheme(
        brightness: isDark ? Brightness.dark : Brightness.light,
        primary: AppColors.primaryBlue,
        onPrimary: palette.onBrand,
        secondary: AppColors.primaryDark,
        onSecondary: palette.onBrand,
        error: AppColors.error,
        onError: Colors.white,
        surface: palette.surface,
        onSurface: palette.textPrimary,
      ),
      extensions: [palette],
      fontFamily: 'Inter',
      appBarTheme: AppBarTheme(
        backgroundColor: palette.background,
        elevation: 0,
        scrolledUnderElevation: 0,
        iconTheme: IconThemeData(color: palette.textPrimary),
        titleTextStyle: TextStyle(
          color: palette.textPrimary,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
      ),
      textTheme: TextTheme(
        displayLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: palette.textPrimary),
        displayMedium: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: palette.textPrimary),
        titleLarge: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: palette.textPrimary),
        titleMedium: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: palette.textPrimary),
        bodyLarge: TextStyle(fontSize: 16, color: palette.textPrimary),
        bodyMedium: TextStyle(fontSize: 14, color: palette.textSecondary),
        labelLarge: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: palette.onBrand),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryBlue,
          foregroundColor: Colors.white,
          minimumSize: const Size(double.infinity, 50),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 0,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primaryBlue,
          side: const BorderSide(color: AppColors.primaryBlue),
          minimumSize: const Size(double.infinity, 50),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: palette.backgroundLight,
        hintStyle: const TextStyle(color: AppColors.textHint, fontSize: 14),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.primaryBlue, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.error),
        ),
      ),
      dividerTheme: DividerThemeData(color: palette.divider),
      dialogTheme: DialogThemeData(
        backgroundColor: palette.surface,
        titleTextStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: palette.textPrimary),
        contentTextStyle: TextStyle(color: palette.textSecondary, fontSize: 14),
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: palette.surface,
        contentTextStyle: TextStyle(color: palette.textPrimary),
      ),
    );
  }
}
