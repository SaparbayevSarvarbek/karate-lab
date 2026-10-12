import 'dart:io' show Platform;

import 'package:flutter/foundation.dart' show kIsWeb, kReleaseMode;

class ApiConstants {
  ApiConstants._();

  /// Build vaqtida manzilni almashtirish:
  ///
  /// ```
  /// flutter run --dart-define=API_BASE_URL=http://192.168.1.5:8000
  /// flutter build apk --release --dart-define=API_BASE_URL=https://carate.uz
  /// ```
  ///
  /// Berilmasa: release build → production domen; debug → quyidagi dev manzil.
  static const String _override = String.fromEnvironment('API_BASE_URL');

  /// Production backend.
  static const String productionUrl = 'https://carate.uz';

  /// Android emulator uchun host mashina manzili.
  static const String _emulator = 'http://10.0.2.2:8000';

  /// USB (`adb reverse tcp:8000 tcp:8000`) yoki iOS simulator / web uchun.
  static const String _localhost = 'http://127.0.0.1:8000';

  /// Fizik qurilma Wi-Fi orqali ulanganda ishlatiladigan LAN manzil.
  ///
  /// ⚠️ Router IP ni o'zgartirsa, bu qiymat eskiradi. Ishonchli yo'l —
  /// `--dart-define=API_BASE_URL=...` bilan berish (pastdagi misolga qarang).
  /// Joriy IP: `ipconfig | findstr IPv4`.
  static const String devLanUrl = 'http://192.168.13.20:8000';

  /// Debug build'da standart manzil (fizik qurilma + Wi-Fi).
  static const String _devDefault = devLanUrl;

  static String get baseUrl {
    if (_override.isNotEmpty) return _override;
    if (kReleaseMode) return productionUrl;
    if (kIsWeb) return _localhost;
    try {
      if (Platform.isAndroid) return _devDefault;
      return _localhost;
    } catch (_) {
      return _localhost;
    }
  }

  /// Emulator / USB rejimida ishlatish uchun tayyor manzillar.
  static String get emulatorUrl => _emulator;
  static String get localhostUrl => _localhost;

  static const String login = '/auth/login/';
  static const String register = '/auth/register/';
  static const String logout = '/auth/logout/';
  static const String refresh = '/auth/refresh/';

  static const String categories = '/categories/';

  static const String athletes = '/athletes/';
  static String athleteDetail(int id) => '/athletes/$id/';

  static const String exercises = '/exercises/';
  static String exerciseDetail(int id) => '/exercises/$id/';

  static const String ujtTests = '/ujt-tests/';
  static String ujtTestDetail(int id) => '/ujt-tests/$id/';

  static const String mjtTests = '/mjt-tests/';
  static String mjtTestDetail(int id) => '/mjt-tests/$id/';

  static const String tests = '/tests/';
  static String testDetail(int id) => '/tests/$id/';

  static const String myTests = '/my-tests/';
  static String startTest(int id) => '/my-tests/$id/start/';
  static String finishTest(int id) => '/my-tests/$id/finish/';

  static const String dashboard = '/dashboard/';
  static const String athleteStatistics = '/athlete/statistics/';
  static const String coachStatistics = '/coach/statistics/';
  static const String coachAthletes = '/coach/athletes/';
  static String coachAthleteStatistics(int id) =>
      '/coach/athletes/$id/statistics/';

  static const String profile = '/profile/';
  static const String profileAvatar = '/profile/avatar/';

  static const String settings = '/settings/';
  static const String settingsPassword = '/settings/password/';
  static const String settingsNotifications = '/settings/notifications/';
  static const String settingsLanguage = '/settings/language/';

  static const String securitySessions = '/security/sessions/';
  static String securitySessionDetail(int id) => '/security/sessions/$id/';

  static String resolveMediaUrl(String url) {
    if (url.startsWith('http://') || url.startsWith('https://')) return url;
    if (url.startsWith('/')) return baseUrl + url;
    return url;
  }

  static const int connectTimeout = 60000;
  static const int receiveTimeout = 60000;
  static const int sendTimeout = 60000;
}
