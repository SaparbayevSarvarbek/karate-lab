// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'test_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_TestAssignment _$TestAssignmentFromJson(Map<String, dynamic> json) =>
    _TestAssignment(
      id: (json['id'] as num?)?.toInt() ?? 0,
      testId: (json['testId'] as num?)?.toInt() ?? 0,
      name: json['name'] as String? ?? '',
      exercises:
          (json['exercises'] as List<dynamic>?)
              ?.map((e) => Exercise.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      status:
          $enumDecodeNullable(
            _$TestStatusEnumMap,
            json['status'],
            unknownValue: TestStatus.unknown,
          ) ??
          TestStatus.unknown,
      score: (json['score'] as num?)?.toDouble(),
      notes: json['notes'] as String? ?? '',
      assignedAt: json['assignedAt'] == null
          ? null
          : DateTime.parse(json['assignedAt'] as String),
      startedAt: json['startedAt'] == null
          ? null
          : DateTime.parse(json['startedAt'] as String),
      finishedAt: json['finishedAt'] == null
          ? null
          : DateTime.parse(json['finishedAt'] as String),
    );

Map<String, dynamic> _$TestAssignmentToJson(_TestAssignment instance) =>
    <String, dynamic>{
      'id': instance.id,
      'testId': instance.testId,
      'name': instance.name,
      'exercises': instance.exercises,
      'status': _$TestStatusEnumMap[instance.status]!,
      'score': instance.score,
      'notes': instance.notes,
      'assignedAt': instance.assignedAt?.toIso8601String(),
      'startedAt': instance.startedAt?.toIso8601String(),
      'finishedAt': instance.finishedAt?.toIso8601String(),
    };

const _$TestStatusEnumMap = {
  TestStatus.pending: 'PENDING',
  TestStatus.inProgress: 'IN_PROGRESS',
  TestStatus.completed: 'COMPLETED',
  TestStatus.unknown: 'unknown',
};

_TestEntity _$TestEntityFromJson(Map<String, dynamic> json) => _TestEntity(
  id: (json['id'] as num?)?.toInt() ?? 0,
  name: json['name'] as String? ?? '',
  exercises:
      (json['exercises'] as List<dynamic>?)
          ?.map((e) => Exercise.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  createdAt: json['createdAt'] == null
      ? null
      : DateTime.parse(json['createdAt'] as String),
);

Map<String, dynamic> _$TestEntityToJson(_TestEntity instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'exercises': instance.exercises,
      'createdAt': instance.createdAt?.toIso8601String(),
    };

_CreateTestRequest _$CreateTestRequestFromJson(Map<String, dynamic> json) =>
    _CreateTestRequest(
      name: json['name'] as String,
      exerciseIds: (json['exerciseIds'] as List<dynamic>)
          .map((e) => (e as num).toInt())
          .toList(),
    );

Map<String, dynamic> _$CreateTestRequestToJson(_CreateTestRequest instance) =>
    <String, dynamic>{
      'name': instance.name,
      'exerciseIds': instance.exerciseIds,
    };

_AssignTestRequest _$AssignTestRequestFromJson(Map<String, dynamic> json) =>
    _AssignTestRequest(
      athleteIds: (json['athleteIds'] as List<dynamic>)
          .map((e) => (e as num).toInt())
          .toList(),
    );

Map<String, dynamic> _$AssignTestRequestToJson(_AssignTestRequest instance) =>
    <String, dynamic>{'athleteIds': instance.athleteIds};

_FinishTestRequest _$FinishTestRequestFromJson(Map<String, dynamic> json) =>
    _FinishTestRequest(
      score: (json['score'] as num).toDouble(),
      notes: json['notes'] as String? ?? '',
    );

Map<String, dynamic> _$FinishTestRequestToJson(_FinishTestRequest instance) =>
    <String, dynamic>{'score': instance.score, 'notes': instance.notes};
