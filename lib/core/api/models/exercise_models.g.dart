// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'exercise_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ExerciseStep _$ExerciseStepFromJson(Map<String, dynamic> json) =>
    _ExerciseStep(
      id: (json['id'] as num?)?.toInt() ?? 0,
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
      repetitions: json['repetitions'] as String? ?? '',
      rest: json['rest'] as String? ?? '',
      duration: (json['duration'] as num?)?.toInt() ?? 0,
      imageUrl: json['image'] as String?,
    );

Map<String, dynamic> _$ExerciseStepToJson(_ExerciseStep instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'repetitions': instance.repetitions,
      'rest': instance.rest,
      'duration': instance.duration,
      'image': instance.imageUrl,
    };

_Exercise _$ExerciseFromJson(Map<String, dynamic> json) => _Exercise(
  id: (json['id'] as num?)?.toInt() ?? 0,
  title: json['title'] as String? ?? '',
  duration: (json['duration'] as num?)?.toInt() ?? 0,
  description: json['description'] as String? ?? '',
  category: json['category'] as String? ?? '',
  age: json['age'] as String? ?? '',
  goal: json['goal'] as String? ?? '',
  qualities:
      (json['qualities'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const <String>[],
  image: json['image'] as String?,
  videoUrl: json['videoUrl'] as String?,
  createdAt: json['createdAt'] as String?,
  steps:
      (json['steps'] as List<dynamic>?)
          ?.map((e) => ExerciseStep.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const <ExerciseStep>[],
);

Map<String, dynamic> _$ExerciseToJson(_Exercise instance) => <String, dynamic>{
  'id': instance.id,
  'title': instance.title,
  'duration': instance.duration,
  'description': instance.description,
  'category': instance.category,
  'age': instance.age,
  'goal': instance.goal,
  'qualities': instance.qualities,
  'steps': instance.steps,
};

_CreateExerciseRequest _$CreateExerciseRequestFromJson(
  Map<String, dynamic> json,
) => _CreateExerciseRequest(
  title: json['title'] as String,
  duration: (json['duration'] as num?)?.toInt() ?? 0,
  description: json['description'] as String? ?? '',
  category: json['category'] as String? ?? '',
  age: json['age'] as String? ?? '',
  goal: json['goal'] as String? ?? '',
  qualities:
      (json['qualities'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const <String>[],
);

Map<String, dynamic> _$CreateExerciseRequestToJson(
  _CreateExerciseRequest instance,
) => <String, dynamic>{
  'title': instance.title,
  'duration': instance.duration,
  'description': instance.description,
  'category': instance.category,
  'age': instance.age,
  'goal': instance.goal,
  'qualities': instance.qualities,
};
