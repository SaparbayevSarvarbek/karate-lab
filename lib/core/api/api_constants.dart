import 'dart:io' show Platform;

import 'package:flutter/foundation.dart' show kIsWeb;

class ApiConstants {
  ApiConstants._();

  /// Development: kompyuterdagi Django server (`0.0.0.0:8000` da yoniq).
  /// Android → USB/emulator: `adb reverse tcp:8000 tcp:8000` qilib
  /// `http://127.0.0.1:8000` orqali ulanadi.
  /// Boshqa platformalar (desktop/web) → `_lanIp` (kompyuter LAN IP'si).
  /// Fizik qurilma WiFi orqali → `_lanIp` ni LAN IP'ga o'zgartiring.
  /// Production: `https://carate.uz`.
  static const String _adbReverse = 'http://127.0.0.1:8000';
  static const String _lanIp = 'http://192.168.13.6:8000';

  static String get baseUrl {
    if (kIsWeb) return _lanIp;
    try {
      if (Platform.isAndroid) return _adbReverse;
      return _lanIp;
    } catch (_) {
      return _lanIp;
    }
  }

  static const String login = '/auth/login/';
  static const String register = '/auth/register/';
  static const String logout = '/auth/logout/';
  static const String refresh = '/auth/refresh/';

  static const String athletes = '/athletes/';
  static String athleteDetail(int id) => '/athletes/$id/';

  static const String exercises = '/exercises/';
  static String exerciseDetail(int id) => '/exercises/$id/';

  static const String ujtTests = '/ujt-tests/';
  static String ujtTestDetail(int id) => '/ujt-tests/$id/';

  static const String tests = '/tests/';
  static String assignTest(int id) => '/tests/$id/assign/';

  static const String myTests = '/my-tests/';
  static String startTest(int id) => '/my-tests/$id/start/';
  static String finishTest(int id) => '/my-tests/$id/finish/';

  static const String dashboard = '/dashboard/';
  static const String statistics = '/statistics/';
  static const String reports = '/reports/';
  static const String myStatistics = '/my-statistics/';

  static const String profile = '/profile/';
  static const String profileAvatar = '/profile/avatar/';

  static const String notifications = '/notifications/';
  static String notificationDetail(int id) => '/notifications/$id/';
  static String markNotificationRead(int id) => '/notifications/$id/read/';

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

  static const int connectTimeout = 30000;
  static const int receiveTimeout = 30000;
  static const int sendTimeout = 30000;
}
