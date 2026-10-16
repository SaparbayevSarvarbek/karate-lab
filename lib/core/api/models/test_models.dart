// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';

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

/// Test ichidagi bitta qadam. Atlet taymer bilan bajaradi.
@freezed
abstract class TestStep with _$TestStep {
  const TestStep._();

  const factory TestStep({
    @Default(0) int id,
    @Default('') String title,
    @Default('') String description,
    @Default('') String repetitions,
    @Default(0) int duration,
    @JsonKey(name: 'image') String? imageUrl,
  }) = _TestStep;

  factory TestStep.fromJson(Map<String, dynamic> json) =>
      _$TestStepFromJson(json);

  bool get hasImage => imageUrl != null && imageUrl!.isNotEmpty;
}

/// Swagger: `Test` — murabbiy yaratgan test (qadamlari bilan).
@freezed
abstract class TestEntity with _$TestEntity {
  const TestEntity._();

  const factory TestEntity({
    @Default(0) int id,
    @Default('') String name,
    @Default('') String description,
    @Default('') String category,
    @Default('') String age,
    @Default('') String goal,
    @Default(<String>[]) List<String> qualities,
    String? coverUrl,
    @Default(<TestStep>[]) List<TestStep> steps,
    DateTime? createdAt,
    @Default(true) bool isActive,
    int? ownerId,
    @Default('') String ownerName,
  }) = _TestEntity;

  factory TestEntity.fromJson(Map<String, dynamic> json) =>
      _$TestEntityFromJson(json);

  bool get hasCover => coverUrl != null && coverUrl!.isNotEmpty;

  int get totalDuration => steps.fold<int>(0, (sum, s) => sum + s.duration);
}

/// Swagger: `/my-tests/` — test + sportchining natijasi (biriktirish yo'q).
@freezed
abstract class TestResult with _$TestResult {
  const TestResult._();

  const factory TestResult({
    @Default(0) int id,
    @Default(0) int testId,
    @Default('') String name,
    @Default('') String description,
    @Default('') String category,
    @Default('') String age,
    @Default('') String goal,
    @Default(<String>[]) List<String> qualities,
    String? coverUrl,
    @Default(<TestStep>[]) List<TestStep> steps,
    @JsonKey(unknownEnumValue: TestStatus.unknown)
    @Default(TestStatus.unknown)
    TestStatus status,
    double? score,
    @Default('') String notes,
    TestEvaluation? result,
    DateTime? startedAt,
    DateTime? finishedAt,
    int? athleteId,
  }) = _TestResult;

  factory TestResult.fromJson(Map<String, dynamic> json) =>
      _$TestResultFromJson(json);

  bool get isCompleted => status == TestStatus.completed;
  bool get isInProgress => status == TestStatus.inProgress;
  bool get hasCover => coverUrl != null && coverUrl!.isNotEmpty;
}

/// Baholash natijasi — umumiy ball, baho va qadamlar diagrammasi.
@freezed
abstract class TestEvaluation with _$TestEvaluation {
  const factory TestEvaluation({
    @Default(0) double score,
    @Default('') String rating,
    @Default('grey') String color,
    int? age,
    @Default(<StepResult>[]) List<StepResult> steps,
  }) = _TestEvaluation;

  factory TestEvaluation.fromJson(Map<String, dynamic> json) =>
      _$TestEvaluationFromJson(json);
}

/// Bitta qadam natijasi (me'yor bilan solishtirilgan).
@freezed
abstract class StepResult with _$StepResult {
  const factory StepResult({
    @Default(0) int stepId,
    @Default(0) int order,
    @Default('') String title,
    @Default(0) double seconds,
    @Default(0) int reps,
    @Default('') String target,
    @Default(0) double percent,
    @Default('') String rating,
    @Default('grey') String color,
  }) = _StepResult;

  factory StepResult.fromJson(Map<String, dynamic> json) =>
      _$StepResultFromJson(json);
}

/// Swagger: `POST /tests/` — testni yaratish so'rovi.
@freezed
abstract class CreateTestRequest with _$CreateTestRequest {
  const factory CreateTestRequest({
    required String name,
    @Default('') String description,
    @Default('') String category,
    @Default('') String age,
    @Default('') String goal,
    @Default(<String>[]) List<String> qualities,
  }) = _CreateTestRequest;

  factory CreateTestRequest.fromJson(Map<String, dynamic> json) =>
      _$CreateTestRequestFromJson(json);
}

/// Yaratilayotgan test ichidagi bitta qadam metadatasi.
/// Rasm fayli repository'ga alohida parallel ro'yxatda beriladi.
class TestStepInput {
  final int? id;
  final String title;
  final String description;
  final String repetitions;
  final int duration;

  TestStepInput({
    this.id,
    this.title = '',
    this.description = '',
    this.repetitions = '',
    this.duration = 0,
  });

  Map<String, dynamic> toJson() => {
        if (id != null) 'id': id,
        'title': title,
        'description': description,
        'repetitions': repetitions,
        'duration': duration,
      };
}

/// Test bajarilganda bitta qadam natijasi (`finish` so'rovida).
@freezed
abstract class FinishStepInput with _$FinishStepInput {
  const factory FinishStepInput({
    required int stepId,
    @Default(0) double seconds,
    @Default(0) int reps,
  }) = _FinishStepInput;

  factory FinishStepInput.fromJson(Map<String, dynamic> json) =>
      _$FinishStepInputFromJson(json);
}

/// Swagger: `finish` — testni yakunlash (`notes` + `stepTimes`).
@freezed
abstract class FinishTestRequest with _$FinishTestRequest {
  const factory FinishTestRequest({
    @Default('') String notes,
    @Default(<FinishStepInput>[]) List<FinishStepInput> stepTimes,
  }) = _FinishTestRequest;

  factory FinishTestRequest.fromJson(Map<String, dynamic> json) =>
      _$FinishTestRequestFromJson(json);
}