import 'dart:async';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import '../services/shared_prefs_service.dart';
import 'api_constants.dart';
import 'api_exception.dart';
import 'api_payload.dart';

class ApiClient {
  final Dio _dio;
  final SharedPrefsService _prefs;

  static void Function()? onUnauthorized;

  static const _retryKey = '_authRetry';
  static Future<String?>? _deviceModelFuture;

  bool _isRefreshing = false;
  final List<Completer<String?>> _refreshWaiters = [];

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
          sendTimeout: const Duration(milliseconds: ApiConstants.sendTimeout),
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
        ),
      ) {
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final deviceModel = await (_deviceModelFuture ??= _loadDeviceModel());
          if (deviceModel != null) {
            options.headers['X-Device-Model'] = deviceModel;
          }

          if (!_isPublicPath(options.path)) {
            final extra = options.extra;
            final alreadyRetried = extra[_retryKey] == true;
            if (!alreadyRetried) {
              final token = _prefs.getAccessToken();
              if (token != null && token.isNotEmpty) {
                options.headers['Authorization'] = 'Bearer $token';
              }
            }
          }
          return handler.next(options);
        },
        onError: (error, handler) async {
          if (error.response?.statusCode == 401) {
            final path = error.requestOptions.path;
            final authHeader =
                error.requestOptions.headers['Authorization'] as String? ?? '';
            final hadBearer =
                authHeader.startsWith('Bearer ') &&
                authHeader.length > 'Bearer '.length;
            final alreadyRetried =
                error.requestOptions.extra[_retryKey] == true;

            if (_isPublicPath(path)) {
              return handler.next(error);
            }

            if (!hadBearer || alreadyRetried) {
              await _prefs.clearTokens();
              onUnauthorized?.call();
              return handler.next(error);
            }

            final newToken = await _getRefreshedToken();
            if (newToken != null) {
              final opts = error.requestOptions;
              opts.headers['Authorization'] = 'Bearer $newToken';
              opts.extra[_retryKey] = true;
              try {
                final response = await _dio.fetch<dynamic>(opts);
                return handler.resolve(response);
              } on DioException catch (e) {
                return handler.next(e);
              }
            }
            await _prefs.clearTokens();
            onUnauthorized?.call();
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

  static Future<String?> _loadDeviceModel() async {
    try {
      final device = await DeviceInfoPlugin().deviceInfo;
      if (device is AndroidDeviceInfo) {
        final parts = [
          device.brand.trim(),
          device.model.trim(),
        ].where((part) => part.isNotEmpty);
        return parts.join(' ');
      }
      if (device is IosDeviceInfo) {
        final model = device.utsname.machine.trim();
        return model.isEmpty ? device.model : '${device.model} ($model)';
      }
      return null;
    } on PlatformException catch (error) {
      debugPrint('[KarateLab] Device model unavailable: ${error.message}');
      return null;
    } on MissingPluginException catch (error) {
      debugPrint('[KarateLab] Device info plugin unavailable: $error');
      return null;
    }
  }

  bool _isPublicPath(String path) {
    return path.contains(ApiConstants.login) ||
        path.contains(ApiConstants.register) ||
        path.contains(ApiConstants.refresh) ||
        path.contains(ApiConstants.appVersion);
  }

  Future<String?> _getRefreshedToken() async {
    if (_isRefreshing) {
      final completer = Completer<String?>();
      _refreshWaiters.add(completer);
      return completer.future;
    }

    _isRefreshing = true;
    final newToken = await _doRefresh();
    _isRefreshing = false;

    for (final waiter in _refreshWaiters) {
      waiter.complete(newToken);
    }
    _refreshWaiters.clear();

    return newToken;
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

  Future<List<Map<String, dynamic>>> getList(
    String path, {
    Map<String, dynamic>? queryParameters,
  }) async {
    final response = await _request(
      () => _dio.get<dynamic>(path, queryParameters: queryParameters),
    );
    return ApiPayload.asList(response.data);
  }

  Future<Map<String, dynamic>?> getObject(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    final response = await _request(
      () => _dio.get<dynamic>(
        path,
        queryParameters: queryParameters,
        options: options,
      ),
    );
    return ApiPayload.asObject(response.data);
  }

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

  Future<Map<String, dynamic>?> putObject(String path, {dynamic data}) async {
    final response = await _request(() => _dio.put<dynamic>(path, data: data));
    return ApiPayload.asObject(response.data);
  }

  Future<Map<String, dynamic>?> patchObject(String path, {dynamic data}) async {
    final response = await _request(
      () => _dio.patch<dynamic>(path, data: data),
    );
    return ApiPayload.asObject(response.data);
  }

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
