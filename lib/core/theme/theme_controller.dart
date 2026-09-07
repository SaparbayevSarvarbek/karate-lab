import 'package:flutter/material.dart';
import '../services/shared_prefs_service.dart';

/// Ilovaning kunduzgi/tungi rejimini boshqaruvchi ChangeNotifier.
///
/// Tanlov SharedPrefs'da saqlanadi. `main()` da `load()` chaqiriladi,
/// sozlamalardagi switch `setDark()` orqali o'zgartiradi.
class ThemeController extends ChangeNotifier {
  ThemeController._();
  static final ThemeController instance = ThemeController._();

  bool _isDark = false;

  bool get isDark => _isDark;

  ThemeMode get themeMode => _isDark ? ThemeMode.dark : ThemeMode.light;

  /// Saqlangan tanlovni yuklaydi. SharedPrefs o'qib bo'lmasa ham xato
  /// tashlamaydi (testlar va birinchi ishga tushirishda xavfsiz).
  Future<void> load() async {
    try {
      final prefs = await SharedPrefsService.getInstance();
      _isDark = await prefs.getDarkMode() ?? false;
      notifyListeners();
    } catch (_) {
      _isDark = false;
    }
  }

  Future<void> setDark(bool value) async {
    if (_isDark == value) return;
    _isDark = value;
    notifyListeners();
    try {
      final prefs = await SharedPrefsService.getInstance();
      await prefs.setDarkMode(value);
    } catch (_) {
      // Saqlash imkoni bo'lmasa ham rejim o'zgardi
    }
  }

  void toggle() => setDark(!_isDark);
}
