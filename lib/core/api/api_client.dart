import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import '../services/shared_prefs_service.dart';
import 'api_constants.dart';
import 'api_exception.dart';
import 'api_payload.dart';

/// HTTP so'rovlarini boshqaruvchi asosiy mijoz.
///
/// - JWT tokenni har bir so'rov boshiga avtomatik qo'shadi;
/// - 401 kelganda refresh token orqali tokenni yangilab, so'rovni takrorlaydi;
/// - refresh ham muvaffaqiyatsiz bo'lsa tokenlarni tozalab `/login` ga o'tkazadi;
/// - `{success:false, error:{...}}` envelope formatidan xato xabarini ajratadi;
/// - `{success:true, data:{...}}` wrapper ini yechib, faqat ma'lumotni qaytaradi.
class ApiClient {
  final Dio _dio;
  final SharedPrefsService _prefs;

  /// Token butunlay yaroqsiz bo'lganda chaqiriladi (login'ga o'tish uchun).
  static void Function()? onUnauthorized;

  Future<String?>? _refreshing;

  static const _publicPaths = <String>{
    ApiConstants.login,
    ApiConstants.register,
    ApiConstants.refresh,
  };

  ApiClient(this._prefs)
      : _dio = Dio(
          BaseOptions(
            baseUrl: ApiConstants.baseUrl,
            connectTimeout: const Duration(
              milliseconds: ApiConstants.connectTimeout,
            ),
            receiveTimeout: const Duration(
              milliseconds: ApiConstants.receiveTimeout,
            ),
            sendTimeout: const Duration(
              milliseconds: ApiConstants.sendTimeout,
            ),
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            },
          ),
        ) {
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          if (!_publicPaths.contains(options.path)) {
            final token = _prefs.getAccessToken();
            if (token != null && token.isNotEmpty) {
              options.headers['Authorization'] = 'Bearer $token';
            }
          }
          return handler.next(options);
        },
        onError: (error, handler) async {
          if (error.response?.statusCode == 401) {
            final path = error.requestOptions.path;
            final authHeader =
                error.requestOptions.headers['Authorization'] as String? ?? '';
            final hadBearer = authHeader.startsWith('Bearer ') &&
                authHeader.length > 'Bearer '.length;

            if (!_publicPaths.contains(path) && hadBearer) {
              final newToken = await _refreshAccessToken();
              if (newToken != null) {
                error.requestOptions.headers['Authorization'] =
                    'Bearer $newToken';
                return handler.resolve(await _dio.fetch(error.requestOptions));
              }
              await _prefs.clearTokens();
              onUnauthorized?.call();
            }
          }
          return handler.next(error);
        },
      ),
    );

    _dio.interceptors.add(
      PrettyDioLogger(
        requestHeader: true,
        requestBody: true,
        responseBody: true,
        responseHeader: false,
        error: true,
        compact: true,
        maxWidth: 90,
      ),
    );
  }

  /// Refresh token bilan yangi access token oladi. Bir vaqtda bir nechta
  /// 401 kelsa ham bitta refresh so'rovi yuboriladi. Muvaffaqiyatda yangi
  /// token SharedPrefs ga saqlanadi.
  Future<String?> _refreshAccessToken() {
    _refreshing ??= _doRefresh().whenComplete(() => _refreshing = null);
    return _refreshing!;
  }

  Future<String?> _doRefresh() async {
    final refreshToken = _prefs.getRefreshToken();
    if (refreshToken == null || refreshToken.isEmpty) return null;
    try {
      final response = await _dio.post(
        ApiConstants.refresh,
        data: {'refreshToken': refreshToken},
      );
      final payload = ApiPayload.asObject(response.data);
      final accessToken = payload?['accessToken'] as String?;
      if (accessToken != null && accessToken.isNotEmpty) {
        await _prefs.saveAccessToken(accessToken);
        return accessToken;
      }
      return null;
    } catch (_) {
      return null;
    }
  }

  /// `GET` ro'yxat so'rovi. Natija normalizatsiya qilingan Map lar ro'yxati.
  Future<List<Map<String, dynamic>>> getList(
    String path, {
    Map<String, dynamic>? queryParameters,
  }) async {
    final response = await _request(
      () => _dio.get<dynamic>(path, queryParameters: queryParameters),
    );
    return ApiPayload.asList(response.data);
  }

  /// `GET` bitta obyekt so'rovi.
  Future<Map<String, dynamic>?> getObject(
    String path, {
    Map<String, dynamic>? queryParameters,
  }) async {
    final response = await _request(
      () => _dio.get<dynamic>(path, queryParameters: queryParameters),
    );
    return ApiPayload.asObject(response.data);
  }

  /// `POST` so'rovi. Multipart fayl yuklash uchun [formData] bering.
  Future<Map<String, dynamic>?> postObject(
    String path, {
    dynamic data,
    FormData? formData,
  }) async {
    final response = await _request(
      () => _dio.post<dynamic>(path, data: formData ?? data),
    );
    return ApiPayload.asObject(response.data);
  }

  /// `PUT` so'rovi.
  Future<Map<String, dynamic>?> putObject(String path, {dynamic data}) async {
    final response = await _request(() => _dio.put<dynamic>(path, data: data));
    return ApiPayload.asObject(response.data);
  }

  /// `PATCH` so'rovi.
  Future<Map<String, dynamic>?> patchObject(String path, {dynamic data}) async {
    final response =
        await _request(() => _dio.patch<dynamic>(path, data: data));
    return ApiPayload.asObject(response.data);
  }

  /// `DELETE` so'rovi. Server odatda 204 qaytaradi.
  Future<void> deleteItem(String path, {dynamic data}) async {
    await _request(() => _dio.delete<dynamic>(path, data: data));
  }

  Future<Response<dynamic>> _request(
    Future<Response<dynamic>> Function() call,
  ) async {
    try {
      final response = await call();
      _throwIfEnvelopeError(response);
      return response;
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }

  /// 2xx qaytsa ham, envelope ichida `success:false` bo'lishi mumkin.
  void _throwIfEnvelopeError(Response<dynamic> response) {
    final data = response.data;
    if (data is Map && data['success'] == false) {
      throw ApiException(
        message: _extractErrorMessage(data),
        statusCode: response.statusCode ?? 500,
      );
    }
  }

  static String _extractErrorMessage(Map envelope) {
    final error = envelope['error'];
    if (error is Map) {
      final detail = error['detail'] ?? error['message'];
      if (detail is String && detail.isNotEmpty) return detail;

      final nonField = error['nonFieldErrors'];
      if (nonField is List && nonField.isNotEmpty) return nonField.join(', ');

      for (final entry in error.entries) {
        final value = entry.value;
        if (value is List && value.isNotEmpty) return value.first.toString();
        if (value is String && value.isNotEmpty) return value;
      }
    }
    return 'Serverda xatolik yuz berdi';
  }
}
