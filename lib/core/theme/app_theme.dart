import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import 'app_palette.dart';
import 'app_radius.dart';

class AppTheme {
  static ThemeData get lightTheme => _build(AppPalette.light);

  static ThemeData get darkTheme => _build(AppPalette.dark);

  static ThemeData _build(AppPalette palette) {
    final isDark = palette.isDark;
    final brightness = isDark ? Brightness.dark : Brightness.light;

    final colorScheme = ColorScheme.fromSeed(
      seedColor: AppColors.primaryBlue,
      brightness: brightness,
    ).copyWith(
      primary: AppColors.primaryBlue,
      onPrimary: palette.onBrand,
      secondary: AppColors.primaryBlue,
      onSecondary: palette.onBrand,
      surface: palette.surface,
      onSurface: palette.textPrimary,
      surfaceContainerHighest: palette.backgroundLight,
      outline: palette.border,
      outlineVariant: palette.divider,
      error: palette.error,
      onError: Colors.white,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      primaryColor: AppColors.primaryBlue,
      scaffoldBackgroundColor: palette.background,
      colorScheme: colorScheme,
      extensions: [palette],
      fontFamily: 'Inter',
      appBarTheme: AppBarTheme(
        backgroundColor: palette.background,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: palette.textPrimary, size: 22),
        titleTextStyle: TextStyle(
          color: palette.textPrimary,
          fontSize: 17,
          fontWeight: FontWeight.w700,
        ),
      ),
      textTheme: TextTheme(
        displayLarge: TextStyle(
            fontSize: 32, fontWeight: FontWeight.w800, color: palette.textPrimary),
        displayMedium: TextStyle(
            fontSize: 24, fontWeight: FontWeight.w800, color: palette.textPrimary),
        titleLarge: TextStyle(
            fontSize: 20, fontWeight: FontWeight.w700, color: palette.textPrimary),
        titleMedium: TextStyle(
            fontSize: 16, fontWeight: FontWeight.w600, color: palette.textPrimary),
        bodyLarge: TextStyle(
            fontSize: 15, fontWeight: FontWeight.w500, color: palette.textPrimary),
        bodyMedium: TextStyle(fontSize: 14, color: palette.textSecondary),
        labelLarge: TextStyle(
            fontSize: 14, fontWeight: FontWeight.w700, color: palette.onBrand),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryBlue,
          foregroundColor: Colors.white,
          minimumSize: const Size(double.infinity, 52),
          elevation: 0,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.button),
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primaryBlue,
          side: BorderSide(color: AppColors.primaryBlue.withValues(alpha: 0.5)),
          minimumSize: const Size(double.infinity, 52),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.button),
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.primaryBlue,
          textStyle: const TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: palette.backgroundLight,
        hintStyle: TextStyle(color: palette.textHint, fontSize: 14.5),
        labelStyle: TextStyle(color: palette.textSecondary, fontSize: 13.5),
        errorStyle: TextStyle(fontSize: 12.5, color: palette.error),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.button),
          borderSide: BorderSide(color: palette.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.button),
          borderSide: BorderSide(color: palette.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.button),
          borderSide: const BorderSide(color: AppColors.primaryBlue, width: 1.6),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.button),
          borderSide: BorderSide(color: palette.error),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.button),
          borderSide: BorderSide(color: palette.error, width: 1.6),
        ),
      ),
      dividerTheme: DividerThemeData(
        color: palette.divider,
        thickness: 1,
        space: 1,
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: palette.surface,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.panel),
          side: BorderSide(color: palette.border),
        ),
        titleTextStyle: TextStyle(
            fontSize: 17, fontWeight: FontWeight.w700, color: palette.textPrimary),
        contentTextStyle:
            TextStyle(color: palette.textSecondary, fontSize: 14, height: 1.4),
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: palette.surface,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        showDragHandle: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.lg)),
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: palette.surface,
        contentTextStyle: TextStyle(color: palette.textPrimary, fontSize: 13.5),
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.button),
          side: BorderSide(color: palette.border),
        ),
      ),
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: AppColors.primaryBlue,
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith(
          (states) => states.contains(WidgetState.selected)
              ? AppColors.primaryBlue
              : null,
        ),
        trackColor: WidgetStateProperty.resolveWith(
          (states) => states.contains(WidgetState.selected)
              ? AppColors.primaryBlue.withValues(alpha: 0.35)
              : null,
        ),
      ),
    );
  }
}
