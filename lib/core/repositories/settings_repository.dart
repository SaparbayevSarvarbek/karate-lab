import 'package:dartz/dartz.dart';

import '../api/api_client.dart';
import '../api/api_constants.dart';
import '../api/api_exception.dart';
import '../api/models/notification_models.dart';
import '../api/models/settings_models.dart';

/// Sozlamalar, bildirishnomalar va xavfsizlik repository
/// (Swagger: Settings, Notifications, Security).
abstract class SettingsRepository {
  Future<Either<ApiException, List<AppNotification>>> getNotifications();
  Future<Either<ApiException, void>> markNotificationRead(int id);
  Future<Either<ApiException, void>> deleteNotification(int id);

  Future<Either<ApiException, AppSettings>> getSettings();
  Future<Either<ApiException, void>> updateLanguage(String language);
  Future<Either<ApiException, void>> updateNotificationPreferences(
    Map<String, dynamic> preferences,
  );
  Future<Either<ApiException, void>> changePassword(
    ChangePasswordRequest request,
  );

  Future<Either<ApiException, List<UserSession>>> getSessions();
  Future<Either<ApiException, void>> deleteSession(int id);
  Future<Either<ApiException, void>> logoutOtherDevices();
}

class SettingsRepositoryImpl implements SettingsRepository {
  final ApiClient _apiClient;

  SettingsRepositoryImpl(this._apiClient);

  @override
  Future<Either<ApiException, List<AppNotification>>> getNotifications() async {
    try {
      final items = await _apiClient.getList(ApiConstants.notifications);
      return Right(items.map(AppNotification.fromJson).toList());
    } on ApiException catch (e) {
      return Left(e);
    }
  }

  @override
  Future<Either<ApiException, void>> markNotificationRead(int id) async {
    try {
      await _apiClient.patchObject(ApiConstants.markNotificationRead(id));
      return const Right(null);
    } on ApiException catch (e) {
      return Left(e);
    }
  }

  @override
  Future<Either<ApiException, void>> deleteNotification(int id) async {
    try {
      await _apiClient.deleteItem(ApiConstants.notificationDetail(id));
      return const Right(null);
    } on ApiException catch (e) {
      return Left(e);
    }
  }

  @override
  Future<Either<ApiException, AppSettings>> getSettings() async {
    try {
      final data = await _apiClient.getObject(ApiConstants.settings);
      if (data == null) {
        return const Left(ApiException(message: 'Server javob bermadi'));
      }
      return Right(AppSettings.fromJson(data));
    } on ApiException catch (e) {
      return Left(e);
    }
  }

  @override
  Future<Either<ApiException, void>> updateLanguage(String language) async {
    try {
      await _apiClient.putObject(
        ApiConstants.settingsLanguage,
        data: {'language': language},
      );
      return const Right(null);
    } on ApiException catch (e) {
      return Left(e);
    }
  }

  @override
  Future<Either<ApiException, void>> updateNotificationPreferences(
    Map<String, dynamic> preferences,
  ) async {
    try {
      await _apiClient.putObject(
        ApiConstants.settingsNotifications,
        data: preferences,
      );
      return const Right(null);
    } on ApiException catch (e) {
      return Left(e);
    }
  }

  @override
  Future<Either<ApiException, void>> changePassword(
    ChangePasswordRequest request,
  ) async {
    try {
      await _apiClient.putObject(
        ApiConstants.settingsPassword,
        data: request.toJson(),
      );
      return const Right(null);
    } on ApiException catch (e) {
      return Left(e);
    }
  }

  @override
  Future<Either<ApiException, List<UserSession>>> getSessions() async {
    try {
      final items = await _apiClient.getList(ApiConstants.securitySessions);
      return Right(items.map(UserSession.fromJson).toList());
    } on ApiException catch (e) {
      return Left(e);
    }
  }

  @override
  Future<Either<ApiException, void>> deleteSession(int id) async {
    try {
      await _apiClient.deleteItem(ApiConstants.securitySessionDetail(id));
      return const Right(null);
    } on ApiException catch (e) {
      return Left(e);
    }
  }

  @override
  Future<Either<ApiException, void>> logoutOtherDevices() async {
    try {
      await _apiClient.deleteItem(ApiConstants.securitySessions);
      return const Right(null);
    } on ApiException catch (e) {
      return Left(e);
    }
  }
}
