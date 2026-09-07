import 'package:freezed_annotation/freezed_annotation.dart';

part 'settings_models.freezed.dart';
part 'settings_models.g.dart';

/// Swagger: `Settings` — til va bildirishnoma sozlamalari.
@freezed
abstract class AppSettings with _$AppSettings {
  const factory AppSettings({
    @Default(0) int id,
    @Default('uz') String language,
    Map<String, dynamic>? notificationPreferences,
  }) = _AppSettings;

  factory AppSettings.fromJson(Map<String, dynamic> json) =>
      _$AppSettingsFromJson(json);
}

/// Swagger: `ChangePassword` — `PUT /settings/password/`.
@freezed
abstract class ChangePasswordRequest with _$ChangePasswordRequest {
  const factory ChangePasswordRequest({
    required String oldPassword,
    required String newPassword,
  }) = _ChangePasswordRequest;

  factory ChangePasswordRequest.fromJson(Map<String, dynamic> json) =>
      _$ChangePasswordRequestFromJson(json);
}

/// Swagger: `UserSession` — faol qurilma sessiyasi.
@freezed
abstract class UserSession with _$UserSession {
  const factory UserSession({
    @Default(0) int id,
    @Default('') String deviceInfo,
    String? ipAddress,
    @Default(true) bool isActive,
    DateTime? createdAt,
  }) = _UserSession;

  factory UserSession.fromJson(Map<String, dynamic> json) =>
      _$UserSessionFromJson(json);
}
