/// O'zbekiston telefon raqamlarini formatlash va tekshirish yordamchilari.
///
/// `+998` qo'shimchasi inputda PREFIX sifatida ko'rsatiladi (editable matndan
/// alohida), shuning uchun `field()` faqat mahalliy 9 ta raqamni saqlaydi.
/// Saqlash uchun esa `full()` to'liq `+998 XX XXX XX XX` shaklini qaytaradi.
class UzPhoneFormatter {
  UzPhoneFormatter._();

  static const int _localDigits = 9;

  static String _digits(String input) => input.replaceAll(RegExp(r'\D'), '');

  /// Input maydoniga qo'yiladigan qism — faqat mahalliy raqamlar
  /// `XX XXX XX XX` formatida (`+998` kirishda prefixText sifatida ko'rinadi).
  static String field(String input) {
    var d = _digits(input);
    // To'liq `998...` past qilinsa ham mahalliy qismini ajratamiz.
    if (d.startsWith('998')) {
      d = d.substring(3);
    }
    if (d.length > _localDigits) {
      d = d.substring(0, _localDigits);
    }

    final buffer = StringBuffer();
    for (int i = 0; i < d.length; i++) {
      if (i == 2 || i == 5 || i == 7) buffer.write(' ');
      buffer.write(d[i]);
    }
    return buffer.toString();
  }

  /// Saqlash uchun to'liq `+998 XX XXX XX XX` shakli. Bo'sh bo'lsa `''` qaytaradi.
  static String full(String input) {
    final local = field(input);
    return local.isEmpty ? '' : '+998 $local';
  }

  /// Input validatsiyasi — aynan 9 ta mahalliy raqam kerak.
  static String? validateField(String input) {
    final d = _digits(input);
    if (d.isEmpty) return 'Telefon raqamni kiriting';
    if (d.length < _localDigits) return 'Raqam to\'liq emas (+998 XX XXX XX XX)';
    return null;
  }
}
