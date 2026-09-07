// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ujt_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_UjtStep _$UjtStepFromJson(Map<String, dynamic> json) => _UjtStep(
  id: (json['id'] as num?)?.toInt() ?? 0,
  title: json['title'] as String? ?? '',
  description: json['description'] as String? ?? '',
  repetitions: json['repetitions'] as String? ?? '',
  rest: json['rest'] as String? ?? '',
  distance: json['distance'] as String? ?? '',
  images:
      (json['images'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const <String>[],
);

Map<String, dynamic> _$UjtStepToJson(_UjtStep instance) => <String, dynamic>{
  'id': instance.id,
  'title': instance.title,
  'description': instance.description,
  'repetitions': instance.repetitions,
  'rest': instance.rest,
  'distance': instance.distance,
  'images': instance.images,
};

_UjtTest _$UjtTestFromJson(Map<String, dynamic> json) => _UjtTest(
  id: (json['id'] as num?)?.toInt() ?? 0,
  title: json['title'] as String? ?? '',
  goal: json['goal'] as String? ?? '',
  ageGroup: json['ageGroup'] as String? ?? '',
  coverUrl: json['coverUrl'] as String?,
  qualities:
      (json['qualities'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const <String>[],
  createdAt: json['createdAt'] as String?,
);

Map<String, dynamic> _$UjtTestToJson(_UjtTest instance) => <String, dynamic>{
  'id': instance.id,
  'title': instance.title,
  'goal': instance.goal,
  'ageGroup': instance.ageGroup,
  'coverUrl': instance.coverUrl,
  'qualities': instance.qualities,
  'createdAt': instance.createdAt,
};
