// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Profile _$ProfileFromJson(Map<String, dynamic> json) => _Profile(
  id: (json['id'] as num?)?.toInt() ?? 0,
  username: json['username'] as String? ?? '',
  fullName: json['fullName'] as String? ?? '',
  phone: json['phone'] as String? ?? '',
  role: json['role'] as String? ?? '',
  email: json['email'] as String?,
  avatar: json['avatar'] as String?,
  birthDate: json['birthDate'] as String?,
  heightCm: (json['heightCm'] as num?)?.toInt(),
  weightKg: (json['weightKg'] as num?)?.toInt(),
);

Map<String, dynamic> _$ProfileToJson(_Profile instance) => <String, dynamic>{
  'id': instance.id,
  'username': instance.username,
  'fullName': instance.fullName,
  'phone': instance.phone,
  'role': instance.role,
  'email': instance.email,
  'avatar': instance.avatar,
  'birthDate': instance.birthDate,
  'heightCm': instance.heightCm,
  'weightKg': instance.weightKg,
};

_UpdateProfileRequest _$UpdateProfileRequestFromJson(
  Map<String, dynamic> json,
) => _UpdateProfileRequest(
  fullName: json['fullName'] as String,
  phone: json['phone'] as String,
  birthDate: json['birthDate'] as String?,
  heightCm: (json['heightCm'] as num?)?.toInt(),
  weightKg: (json['weightKg'] as num?)?.toInt(),
);

Map<String, dynamic> _$UpdateProfileRequestToJson(
  _UpdateProfileRequest instance,
) => <String, dynamic>{
  'fullName': instance.fullName,
  'phone': instance.phone,
  'birthDate': instance.birthDate,
  'heightCm': instance.heightCm,
  'weightKg': instance.weightKg,
};
