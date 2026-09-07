/// API javoblarini xavfsiz o'qish uchun yordamchi.
///
/// Server javoblari to'g'ridan-to'g'ri obyekt/ro'yxat yoki
/// `{success, data:{...}}` ko'rinishida kelishi mumkin. Shu sababli
/// ma'lumotlar normallashtirib olinadi.
class ApiPayload {
  ApiPayload._();

  /// Kalitlarni `snake_case` dan `camelCase` ga o'tkazadi (mavjud camelCase
  /// kalitlar o'zgarmaydi). Server ikkala formatda javob berishi mumkinligi
  /// uchun bu barcha modellarni bir xil camelCase ko'rinishida ushlab turadi.
  static Map<String, dynamic> normalizeKeys(Map<String, dynamic> map) {
    final result = <String, dynamic>{};
    map.forEach((key, value) {
      final camel = _toCamelCase(key);
      result[camel] = _normalizeValue(value);
    });
    return result;
  }

  static dynamic _normalizeValue(dynamic value) {
    if (value is Map) {
      return normalizeKeys(Map<String, dynamic>.from(value));
    }
    if (value is List) {
      return value.map(_normalizeValue).toList(growable: true);
    }
    return value;
  }

  static String _toCamelCase(String input) {
    if (!input.contains('_')) return input;
    final parts = input.split('_').where((s) => s.isNotEmpty).toList();
    if (parts.isEmpty) return input;
    final buffer = StringBuffer(parts.first);
    for (final part in parts.skip(1)) {
      buffer.write(part[0].toUpperCase());
      buffer.write(part.substring(1));
    }
    return buffer.toString();
  }

  /// `data` ni obyekt (Map) ga keltiradi va kalitlarni normallashtiradi.
  /// Agar `data` wrapper ichida bo'lsa (`{"success":true,"data":{...}}`),
  /// ichkidagi obyekt qaytariladi.
  static Map<String, dynamic>? asObject(dynamic data) {
    if (data is Map) {
      final map = Map<String, dynamic>.from(data);
      final nested = map['data'];
      if (nested is Map) return normalizeKeys(Map<String, dynamic>.from(nested));
      return normalizeKeys(map);
    }
    return null;
  }

  /// `data` ni ro'yxatga keltiradi.
  /// To'gridan-to'g'ri massiv, `{"data":[...]}` yoki DRF paginatsiya
  /// `{"count":N,"results":[...]}` formatlarini qo'llaydi.
  static List<Map<String, dynamic>> asList(dynamic data) {
    if (data is List) {
      return data
          .whereType<Map>()
          .map((e) => normalizeKeys(Map<String, dynamic>.from(e)))
          .toList(growable: true);
    }
    if (data is Map) {
      final map = Map<String, dynamic>.from(data);
      final candidates = <dynamic>[map['data'], map['results'], map['items']];
      for (final c in candidates) {
        if (c is List) {
          return c
              .whereType<Map>()
              .map((e) => normalizeKeys(Map<String, dynamic>.from(e)))
              .toList(growable: true);
        }
      }
      if (candidates.any((c) => c is Map)) {
        return const [];
      }
    }
    return <Map<String, dynamic>>[];
  }

  /// `{count, next, previous, results}` ko'rinishidagi paginatsiya javobidan
  /// jami elementlar sonini o'qiydi.
  static int? readCount(dynamic data) {
    if (data is Map) {
      final c = data['count'] ?? data['total'];
      if (c is int) return c;
      if (c is String) return int.tryParse(c);
    }
    return null;
  }

  /// Dinamik qiymatni int ga xavfsiz aylantiradi.
  static int? toInt(dynamic v) {
    if (v == null) return null;
    if (v is int) return v;
    if (v is num) return v.toInt();
    if (v is String) return int.tryParse(v);
    return null;
  }

  /// Dinamik qiymatni double ga xavfsiz aylantiradi.
  static double? toDouble(dynamic v) {
    if (v == null) return null;
    if (v is double) return v;
    if (v is num) return v.toDouble();
    if (v is String) return double.tryParse(v);
    return null;
  }
}
