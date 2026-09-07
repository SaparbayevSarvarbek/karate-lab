// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'exercise_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Exercise _$ExerciseFromJson(Map<String, dynamic> json) => _Exercise(
  id: (json['id'] as num?)?.toInt() ?? 0,
  title: json['title'] as String? ?? '',
  duration: (json['duration'] as num?)?.toInt() ?? 0,
  description: json['description'] as String? ?? '',
  category: json['category'] as String? ?? '',
  image: json['image'] as String?,
  videoUrl: json['videoUrl'] as String?,
  createdAt: json['createdAt'] as String?,
);

Map<String, dynamic> _$ExerciseToJson(_Exercise instance) => <String, dynamic>{
  'id': instance.id,
  'title': instance.title,
  'duration': instance.duration,
  'description': instance.description,
  'category': instance.category,
};

_CreateExerciseRequest _$CreateExerciseRequestFromJson(
  Map<String, dynamic> json,
) => _CreateExerciseRequest(
  title: json['title'] as String,
  duration: (json['duration'] as num).toInt(),
  description: json['description'] as String? ?? '',
);

Map<String, dynamic> _$CreateExerciseRequestToJson(
  _CreateExerciseRequest instance,
) => <String, dynamic>{
  'title': instance.title,
  'duration': instance.duration,
  'description': instance.description,
};
