// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';

import 'exercise_models.dart';

part 'test_models.freezed.dart';
part 'test_models.g.dart';

/// Swagger: `StatusEnum` — test holati.
enum TestStatus {
  @JsonValue('PENDING')
  pending,
  @JsonValue('IN_PROGRESS')
  inProgress,
  @JsonValue('COMPLETED')
  completed,
  unknown;

  String get label {
    switch (this) {
      case TestStatus.pending:
        return 'Kutilmoqda';
      case TestStatus.inProgress:
        return 'Jarayonda';
      case TestStatus.completed:
        return 'Bajarildi';
      case TestStatus.unknown:
        return 'Noma\'lum';
    }
  }
}

/// Swagger: `TestAssignment` — atletga biriktirilgan test.
@freezed
abstract class TestAssignment with _$TestAssignment {
  const TestAssignment._();

  const factory TestAssignment({
    @Default(0) int id,
    @Default(0) int testId,
    @Default('') String name,
    @Default([]) List<Exercise> exercises,
    @JsonKey(unknownEnumValue: TestStatus.unknown)
    @Default(TestStatus.unknown)
    TestStatus status,
    double? score,
    @Default('') String notes,
    DateTime? assignedAt,
    DateTime? startedAt,
    DateTime? finishedAt,
  }) = _TestAssignment;

  factory TestAssignment.fromJson(Map<String, dynamic> json) =>
      _$TestAssignmentFromJson(json);

  bool get isCompleted => status == TestStatus.completed;
  bool get isInProgress => status == TestStatus.inProgress;
}

/// Swagger: `Test` — murabbiy yaratgan test (mashqlar bilan).
///
/// Swagger'da `exerciseIds` faqat yozish uchun (`writeOnly`), javob
/// obyektiga kirmaydi — yaratish uchun [CreateTestRequest] ishlatiladi.
@freezed
abstract class TestEntity with _$TestEntity {
  const TestEntity._();

  const factory TestEntity({
    @Default(0) int id,
    @Default('') String name,
    @Default([]) List<Exercise> exercises,
    DateTime? createdAt,
  }) = _TestEntity;

  factory TestEntity.fromJson(Map<String, dynamic> json) =>
      _$TestEntityFromJson(json);

  int get totalDuration =>
      exercises.fold<int>(0, (sum, e) => sum + e.duration);
}

/// Swagger: `POST /tests/` — testni yaratish so'rovi
/// (`{"name":"Balance Test","exerciseIds":[1,2]}`).
@freezed
abstract class CreateTestRequest with _$CreateTestRequest {
  const factory CreateTestRequest({
    required String name,
    required List<int> exerciseIds,
  }) = _CreateTestRequest;

  factory CreateTestRequest.fromJson(Map<String, dynamic> json) =>
      _$CreateTestRequestFromJson(json);
}

/// Swagger: `POST /tests/{id}/assign/` — testni atletlarga biriktirish
/// (`{"athleteIds":[1,2,3]}`).
@freezed
abstract class AssignTestRequest with _$AssignTestRequest {
  const factory AssignTestRequest({
    required List<int> athleteIds,
  }) = _AssignTestRequest;

  factory AssignTestRequest.fromJson(Map<String, dynamic> json) =>
      _$AssignTestRequestFromJson(json);
}

/// Swagger: `FinishTest` — testni yakunlash (`{"score":95,"notes":"..."}`).
@freezed
abstract class FinishTestRequest with _$FinishTestRequest {
  const factory FinishTestRequest({
    required double score,
    @Default('') String notes,
  }) = _FinishTestRequest;

  factory FinishTestRequest.fromJson(Map<String, dynamic> json) =>
      _$FinishTestRequestFromJson(json);
}
