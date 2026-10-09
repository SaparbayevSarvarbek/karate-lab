// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'test_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_TestStep _$TestStepFromJson(Map<String, dynamic> json) => _TestStep(
  id: (json['id'] as num?)?.toInt() ?? 0,
  title: json['title'] as String? ?? '',
  description: json['description'] as String? ?? '',
  repetitions: json['repetitions'] as String? ?? '',
  duration: (json['duration'] as num?)?.toInt() ?? 0,
  imageUrl: json['image'] as String?,
);

Map<String, dynamic> _$TestStepToJson(_TestStep instance) => <String, dynamic>{
  'id': instance.id,
  'title': instance.title,
  'description': instance.description,
  'repetitions': instance.repetitions,
  'duration': instance.duration,
  'image': instance.imageUrl,
};

_TestEntity _$TestEntityFromJson(Map<String, dynamic> json) => _TestEntity(
  id: (json['id'] as num?)?.toInt() ?? 0,
  name: json['name'] as String? ?? '',
  description: json['description'] as String? ?? '',
  category: json['category'] as String? ?? '',
  age: json['age'] as String? ?? '',
  goal: json['goal'] as String? ?? '',
  qualities:
      (json['qualities'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const <String>[],
  coverUrl: json['coverUrl'] as String?,
  steps:
      (json['steps'] as List<dynamic>?)
          ?.map((e) => TestStep.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const <TestStep>[],
  createdAt: json['createdAt'] == null
      ? null
      : DateTime.parse(json['createdAt'] as String),
  isActive: json['isActive'] as bool? ?? true,
  ownerId: (json['ownerId'] as num?)?.toInt(),
  ownerName: json['ownerName'] as String? ?? '',
);

Map<String, dynamic> _$TestEntityToJson(_TestEntity instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'category': instance.category,
      'age': instance.age,
      'goal': instance.goal,
      'qualities': instance.qualities,
      'coverUrl': instance.coverUrl,
      'steps': instance.steps,
      'createdAt': instance.createdAt?.toIso8601String(),
      'isActive': instance.isActive,
      'ownerId': instance.ownerId,
      'ownerName': instance.ownerName,
    };

_TestResult _$TestResultFromJson(Map<String, dynamic> json) => _TestResult(
  id: (json['id'] as num?)?.toInt() ?? 0,
  testId: (json['testId'] as num?)?.toInt() ?? 0,
  name: json['name'] as String? ?? '',
  description: json['description'] as String? ?? '',
  category: json['category'] as String? ?? '',
  age: json['age'] as String? ?? '',
  goal: json['goal'] as String? ?? '',
  qualities:
      (json['qualities'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const <String>[],
  coverUrl: json['coverUrl'] as String?,
  steps:
      (json['steps'] as List<dynamic>?)
          ?.map((e) => TestStep.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const <TestStep>[],
  status:
      $enumDecodeNullable(
        _$TestStatusEnumMap,
        json['status'],
        unknownValue: TestStatus.unknown,
      ) ??
      TestStatus.unknown,
  score: (json['score'] as num?)?.toDouble(),
  notes: json['notes'] as String? ?? '',
  result: json['result'] == null
      ? null
      : TestEvaluation.fromJson(json['result'] as Map<String, dynamic>),
  startedAt: json['startedAt'] == null
      ? null
      : DateTime.parse(json['startedAt'] as String),
  finishedAt: json['finishedAt'] == null
      ? null
      : DateTime.parse(json['finishedAt'] as String),
  athleteId: (json['athleteId'] as num?)?.toInt(),
);

Map<String, dynamic> _$TestResultToJson(_TestResult instance) =>
    <String, dynamic>{
      'id': instance.id,
      'testId': instance.testId,
      'name': instance.name,
      'description': instance.description,
      'category': instance.category,
      'age': instance.age,
      'goal': instance.goal,
      'qualities': instance.qualities,
      'coverUrl': instance.coverUrl,
      'steps': instance.steps,
      'status': _$TestStatusEnumMap[instance.status]!,
      'score': instance.score,
      'notes': instance.notes,
      'result': instance.result,
      'startedAt': instance.startedAt?.toIso8601String(),
      'finishedAt': instance.finishedAt?.toIso8601String(),
      'athleteId': instance.athleteId,
    };

const _$TestStatusEnumMap = {
  TestStatus.pending: 'PENDING',
  TestStatus.inProgress: 'IN_PROGRESS',
  TestStatus.completed: 'COMPLETED',
  TestStatus.unknown: 'unknown',
};

_TestEvaluation _$TestEvaluationFromJson(Map<String, dynamic> json) =>
    _TestEvaluation(
      score: (json['score'] as num?)?.toDouble() ?? 0,
      rating: json['rating'] as String? ?? '',
      color: json['color'] as String? ?? 'grey',
      age: (json['age'] as num?)?.toInt(),
      steps:
          (json['steps'] as List<dynamic>?)
              ?.map((e) => StepResult.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const <StepResult>[],
    );

Map<String, dynamic> _$TestEvaluationToJson(_TestEvaluation instance) =>
    <String, dynamic>{
      'score': instance.score,
      'rating': instance.rating,
      'color': instance.color,
      'age': instance.age,
      'steps': instance.steps,
    };

_StepResult _$StepResultFromJson(Map<String, dynamic> json) => _StepResult(
  stepId: (json['stepId'] as num?)?.toInt() ?? 0,
  order: (json['order'] as num?)?.toInt() ?? 0,
  title: json['title'] as String? ?? '',
  seconds: (json['seconds'] as num?)?.toDouble() ?? 0,
  reps: (json['reps'] as num?)?.toInt() ?? 0,
  target: json['target'] as String? ?? '',
  percent: (json['percent'] as num?)?.toDouble() ?? 0,
  rating: json['rating'] as String? ?? '',
  color: json['color'] as String? ?? 'grey',
);

Map<String, dynamic> _$StepResultToJson(_StepResult instance) =>
    <String, dynamic>{
      'stepId': instance.stepId,
      'order': instance.order,
      'title': instance.title,
      'seconds': instance.seconds,
      'reps': instance.reps,
      'target': instance.target,
      'percent': instance.percent,
      'rating': instance.rating,
      'color': instance.color,
    };

_CreateTestRequest _$CreateTestRequestFromJson(Map<String, dynamic> json) =>
    _CreateTestRequest(
      name: json['name'] as String,
      description: json['description'] as String? ?? '',
      category: json['category'] as String? ?? '',
      age: json['age'] as String? ?? '',
      goal: json['goal'] as String? ?? '',
      qualities:
          (json['qualities'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const <String>[],
    );

Map<String, dynamic> _$CreateTestRequestToJson(_CreateTestRequest instance) =>
    <String, dynamic>{
      'name': instance.name,
      'description': instance.description,
      'category': instance.category,
      'age': instance.age,
      'goal': instance.goal,
      'qualities': instance.qualities,
    };

_FinishStepInput _$FinishStepInputFromJson(Map<String, dynamic> json) =>
    _FinishStepInput(
      stepId: (json['stepId'] as num).toInt(),
      seconds: (json['seconds'] as num?)?.toDouble() ?? 0,
      reps: (json['reps'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$FinishStepInputToJson(_FinishStepInput instance) =>
    <String, dynamic>{
      'stepId': instance.stepId,
      'seconds': instance.seconds,
      'reps': instance.reps,
    };

_FinishTestRequest _$FinishTestRequestFromJson(Map<String, dynamic> json) =>
    _FinishTestRequest(
      notes: json['notes'] as String? ?? '',
      stepTimes:
          (json['stepTimes'] as List<dynamic>?)
              ?.map((e) => FinishStepInput.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const <FinishStepInput>[],
    );

Map<String, dynamic> _$FinishTestRequestToJson(_FinishTestRequest instance) =>
    <String, dynamic>{'notes': instance.notes, 'stepTimes': instance.stepTimes};
