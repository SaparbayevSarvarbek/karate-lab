import 'package:flutter_test/flutter_test.dart';
import 'package:krate_lab/core/api/api_constants.dart';

/// `--dart-define` orqali berilgan manzilni tekshirish uchun:
///   flutter test --dart-define=API_BASE_URL=http://10.0.0.5:8000
const _defined = String.fromEnvironment('API_BASE_URL');

void main() {
  group('ApiConstants.baseUrl', () {
    test('--dart-define berilganda aynan o\'sha manzil ishlatiladi', () {
      if (_defined.isEmpty) {
        // define berilmagan — bu yo'l alohida ishga tushirilganda tekshiriladi.
        return;
      }
      expect(ApiConstants.baseUrl, _defined);
    });

    test('define berilmasa ham bo\'sh bo\'lmagan manzil qaytaradi', () {
      if (_defined.isNotEmpty) return;
      expect(ApiConstants.baseUrl, isNotEmpty);
    });

    test('har doim to\'g\'ri http(s) origin bo\'ladi', () {
      final uri = Uri.parse(ApiConstants.baseUrl);
      expect(uri.scheme, anyOf('http', 'https'));
      expect(uri.host, isNotEmpty);
      expect(ApiConstants.baseUrl, isNot(endsWith('/')));
    });

    test('release build uchun production domen belgilangan', () {
      expect(ApiConstants.productionUrl, 'https://carate.uz');
    });
  });

  group('ApiConstants.resolveMediaUrl', () {
    test('nisbiy /media/... yo\'lini baseUrl bilan birlashtiradi', () {
      expect(
        ApiConstants.resolveMediaUrl('/media/avatars/a.jpg'),
        '${ApiConstants.baseUrl}/media/avatars/a.jpg',
      );
    });

    test('allaqachon to\'liq URL bo\'lsa o\'zgartirmaydi', () {
      const absolute = 'https://carate.uz/media/x.jpg';
      expect(ApiConstants.resolveMediaUrl(absolute), absolute);
    });
  });
}
