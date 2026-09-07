import 'package:dio/dio.dart';

/// API so'rovlarida yuzaga keladigan barcha xatoliklarning yagona turi.
class ApiException implements Exception {
  final String message;
  final int statusCode;

  const ApiException({
    required this.message,
    this.statusCode = 0,
  });

  factory ApiException.fromDioException(DioException e) {
    return ApiException(
      message: _mapMessage(e),
      statusCode: e.response?.statusCode ?? 0,
    );
  }

  bool get isUnauthorized => statusCode == 401;
  bool get isForbidden => statusCode == 403;
  bool get isNotFound => statusCode == 404;

  static String _mapMessage(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return 'Serverga ulanish vaqti tugadi. Internetni tekshirib qayta urinib ko\'ring.';
      case DioExceptionType.connectionError:
        return 'Internet bilan bog\'lanish imkoni bo\'lmadi.';
      case DioExceptionType.badResponse:
        return _mapHttpError(e);
      case DioExceptionType.cancel:
        return 'So\'rov bekor qilindi.';
      case DioExceptionType.badCertificate:
        return 'Xavfsizlik sertifikati bilan bog\'liq xatolik.';
      case DioExceptionType.transformTimeout:
      case DioExceptionType.unknown:
        return 'Server bilan bog\'lanishda xatolik. Keyinroq urinib ko\'ring.';
    }
  }

  static String _mapHttpError(DioException e) {
    final data = e.response?.data;

    if (data is Map) {
      final error = data['error'];
      if (error is Map) {
        final detail = error['detail'] ?? error['message'];
        if (detail is String && detail.isNotEmpty) return detail;

        final nonField = error['nonFieldErrors'];
        if (nonField is List && nonField.isNotEmpty) {
          return nonField.join(', ');
        }

        for (final entry in error.entries) {
          final value = entry.value;
          if (value is List && value.isNotEmpty) return value.first.toString();
          if (value is String && value.isNotEmpty) return value;
        }
      }

      final detail = data['detail'] ?? data['message'];
      if (detail is String && detail.isNotEmpty) return detail;
    }

    switch (e.response?.statusCode) {
      case 400:
        return 'So\'rovda xatolik bor. Ma\'lumotlarni tekshirib qaytadan urinib ko\'ring.';
      case 401:
        return 'Sessiya muddati tugagan. Qaytadan tizimga kiring.';
      case 403:
        return 'Bu amalga ruxsat yo\'q.';
      case 404:
        return 'Ma\'lumot topilmadi.';
      case 500:
        return 'Serverda nosozlik yuz berdi. Keyinroq urinib ko\'ring.';
      default:
        return 'Xatolik yuz berdi (${e.response?.statusCode ?? '?'})';
    }
  }

  @override
  String toString() => message;
}
