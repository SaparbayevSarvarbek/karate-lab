import 'package:dartz/dartz.dart';

import '../api/api_client.dart';
import '../api/api_constants.dart';
import '../api/api_exception.dart';
import '../api/models/auth_models.dart';
import '../l10n/app_translations.dart';
import '../services/shared_prefs_service.dart';

/// Autentifikatsiya repository (Swagger: Authentication).
abstract class AuthRepository {
  Future<Either<ApiException, LoginResponse>> login(
    String username,
    String password,
  );
  Future<Either<ApiException, LoginResponse>> register(RegisterRequest request);
  Future<Either<ApiException, void>> logout();
  Future<Either<ApiException, String>> refreshAccessToken();
}

class AuthRepositoryImpl implements AuthRepository {
  final ApiClient _apiClient;
  final SharedPrefsService _prefs;

  AuthRepositoryImpl(this._apiClient, this._prefs);

  @override
  Future<Either<ApiException, LoginResponse>> login(
    String username,
    String password,
  ) async {
    try {
      final request = LoginRequest(username: username, password: password);
      final data = await _apiClient.postObject(
        ApiConstants.login,
        data: request.toJson(),
      );
      if (data == null) {
        return Left(ApiException(message: Tr.t('serverNoResponse')));
      }

      final loginResponse = LoginResponse.fromJson(data);

      await _prefs.saveAccessToken(loginResponse.accessToken);
      await _prefs.saveRefreshToken(loginResponse.refreshToken);
      await _prefs.saveSelectedRole(loginResponse.role.toLowerCase());

      return Right(loginResponse);
    } on ApiException catch (e) {
      return Left(e);
    }
  }

  @override
  Future<Either<ApiException, LoginResponse>> register(
    RegisterRequest request,
  ) async {
    try {
      final data = await _apiClient.postObject(
        ApiConstants.register,
        data: request.toJson(),
      );
      if (data == null) {
        return Left(ApiException(message: Tr.t('serverNoResponse')));
      }

      final loginResponse = LoginResponse.fromJson(data);

      await _prefs.saveAccessToken(loginResponse.accessToken);
      await _prefs.saveRefreshToken(loginResponse.refreshToken);
      await _prefs.saveSelectedRole(loginResponse.role.toLowerCase());

      return Right(loginResponse);
    } on ApiException catch (e) {
      return Left(e);
    }
  }

  @override
  Future<Either<ApiException, void>> logout() async {
    final refreshToken = _prefs.getRefreshToken();
    await _prefs.clearTokens();
    if (refreshToken == null) return const Right(null);

    try {
      await _apiClient.postObject(
        ApiConstants.logout,
        data: RefreshTokenRequest(refreshToken: refreshToken).toJson(),
      );
      return const Right(null);
    } on ApiException catch (error) {
      return Left(error);
    }
  }

  @override
  Future<Either<ApiException, String>> refreshAccessToken() async {
    try {
      final refreshToken = _prefs.getRefreshToken();
      if (refreshToken == null) {
        return Left(
          ApiException(message: Tr.t('refreshTokenMissing'), statusCode: 401),
        );
      }

      final data = await _apiClient.postObject(
        ApiConstants.refresh,
        data: RefreshTokenRequest(refreshToken: refreshToken).toJson(),
      );
      if (data == null) {
        return Left(ApiException(message: Tr.t('serverNoResponse')));
      }

      final response = RefreshTokenResponse.fromJson(data);
      await _prefs.saveAccessToken(response.accessToken);
      return Right(response.accessToken);
    } on ApiException catch (e) {
      return Left(e);
    }
  }
}
