/// Ilova bo'ylab yagona spacing (masofa) qiymatlari.
///
/// Qiymatlar dizayn sistemasining 4px grid'iga asoslangan. Sahifalarda
/// `EdgeInsets.all(AppSpacing.lg)` yoki `SizedBox(height: AppSpacing.md)`
/// ko'rinishida ishlatiladi. ScreenUtil kerak bo'lgan joyda `.w` / `.h`
/// qo'shiladi.
class AppSpacing {
  AppSpacing._();

  static const double xxs = 2;
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double xl = 20;
  static const double xxl = 24;
  static const double xxxl = 32;

  /// Ekranlarning standart yon padding'i.
  static const double screenH = 20;
}
