// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'settings_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AppSettings _$AppSettingsFromJson(Map<String, dynamic> json) => _AppSettings(
  id: (json['id'] as num?)?.toInt() ?? 0,
  language: json['language'] as String? ?? 'uz',
  notificationPreferences:
      json['notificationPreferences'] as Map<String, dynamic>?,
);

Map<String, dynamic> _$AppSettingsToJson(_AppSettings instance) =>
    <String, dynamic>{
      'id': instance.id,
      'language': instance.language,
      'notificationPreferences': instance.notificationPreferences,
    };

_ChangePasswordRequest _$ChangePasswordRequestFromJson(
  Map<String, dynamic> json,
) => _ChangePasswordRequest(
  oldPassword: json['oldPassword'] as String,
  newPassword: json['newPassword'] as String,
);

Map<String, dynamic> _$ChangePasswordRequestToJson(
  _ChangePasswordRequest instance,
) => <String, dynamic>{
  'oldPassword': instance.oldPassword,
  'newPassword': instance.newPassword,
};

_UserSession _$UserSessionFromJson(Map<String, dynamic> json) => _UserSession(
  id: (json['id'] as num?)?.toInt() ?? 0,
  deviceInfo: json['deviceInfo'] as String? ?? '',
  ipAddress: json['ipAddress'] as String?,
  isActive: json['isActive'] as bool? ?? true,
  createdAt: json['createdAt'] == null
      ? null
      : DateTime.parse(json['createdAt'] as String),
);

Map<String, dynamic> _$UserSessionToJson(_UserSession instance) =>
    <String, dynamic>{
      'id': instance.id,
      'deviceInfo': instance.deviceInfo,
      'ipAddress': instance.ipAddress,
      'isActive': instance.isActive,
      'createdAt': instance.createdAt?.toIso8601String(),
    };
