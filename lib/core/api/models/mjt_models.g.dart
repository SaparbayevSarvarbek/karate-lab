// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mjt_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_MjtStep _$MjtStepFromJson(Map<String, dynamic> json) => _MjtStep(
  id: (json['id'] as num?)?.toInt() ?? 0,
  title: json['title'] as String? ?? '',
  description: json['description'] as String? ?? '',
  repetitions: json['repetitions'] as String? ?? '',
  rest: json['rest'] as String? ?? '',
  goal: json['goal'] as String? ?? '',
  images:
      (json['images'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const <String>[],
);

Map<String, dynamic> _$MjtStepToJson(_MjtStep instance) => <String, dynamic>{
  'id': instance.id,
  'title': instance.title,
  'description': instance.description,
  'repetitions': instance.repetitions,
  'rest': instance.rest,
  'goal': instance.goal,
  'images': instance.images,
};

_MjtTest _$MjtTestFromJson(Map<String, dynamic> json) => _MjtTest(
  id: (json['id'] as num?)?.toInt() ?? 0,
  title: json['title'] as String? ?? '',
  goal: json['goal'] as String? ?? '',
  ageGroup: json['ageGroup'] as String? ?? '',
  coverUrl: json['coverUrl'] as String?,
  qualities:
      (json['qualities'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const <String>[],
  steps:
      (json['steps'] as List<dynamic>?)
          ?.map((e) => MjtStep.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const <MjtStep>[],
  createdAt: json['createdAt'] as String?,
);

Map<String, dynamic> _$MjtTestToJson(_MjtTest instance) => <String, dynamic>{
  'id': instance.id,
  'title': instance.title,
  'goal': instance.goal,
  'ageGroup': instance.ageGroup,
  'coverUrl': instance.coverUrl,
  'qualities': instance.qualities,
  'steps': instance.steps,
  'createdAt': instance.createdAt,
};
