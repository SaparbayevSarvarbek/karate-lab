// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'athlete_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Athlete _$AthleteFromJson(Map<String, dynamic> json) => _Athlete(
  id: (json['id'] as num?)?.toInt() ?? 0,
  username: json['username'] as String? ?? '',
  firstName: json['firstName'] as String? ?? '',
  lastName: json['lastName'] as String? ?? '',
  birthDate: json['birthDate'] as String?,
  phone: json['phone'] as String?,
  avatar: json['avatar'] as String?,
);

Map<String, dynamic> _$AthleteToJson(_Athlete instance) => <String, dynamic>{
  'id': instance.id,
  'username': instance.username,
  'firstName': instance.firstName,
  'lastName': instance.lastName,
  'birthDate': instance.birthDate,
  'phone': instance.phone,
};

_CreateAthleteRequest _$CreateAthleteRequestFromJson(
  Map<String, dynamic> json,
) => _CreateAthleteRequest(
  firstName: json['firstName'] as String,
  lastName: json['lastName'] as String,
  birthDate: json['birthDate'] as String,
);

Map<String, dynamic> _$CreateAthleteRequestToJson(
  _CreateAthleteRequest instance,
) => <String, dynamic>{
  'firstName': instance.firstName,
  'lastName': instance.lastName,
  'birthDate': instance.birthDate,
};
