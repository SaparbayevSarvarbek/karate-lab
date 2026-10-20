// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';

part 'exercise_models.freezed.dart';
part 'exercise_models.g.dart';

/// Mashq ichidagi bitta bosqich (step).
/// Nom, tavsif, rasm, takrorlash va vaqt (soniya) dan iborat.
@freezed
abstract class ExerciseStep with _$ExerciseStep {
  const ExerciseStep._();

  const factory ExerciseStep({
    @Default(0) int id,
    @Default('') String title,
    @Default('') String description,
    @Default('') String repetitions,
    @Default('') String rest,
    @Default(0) int duration,
    @JsonKey(name: 'image') String? imageUrl,
  }) = _ExerciseStep;

  factory ExerciseStep.fromJson(Map<String, dynamic> json) =>
      _$ExerciseStepFromJson(json);

  bool get hasImage => imageUrl != null && imageUrl!.isNotEmpty;
  String get durationLabel => duration >= 60
      ? '${duration ~/ 60}n ${(duration % 60).toString().padLeft(2, '0')}s'
      : '${duration}s';
}

/// Swagger: `Exercise` — mashq.
///
/// Struktura: nom, yosh chegarasi, turi (Texnik/UJT/MJT), umumiy rasm,
/// maqsad, rivojlanadigan sifatlar va bosqichlar.
@freezed
abstract class Exercise with _$Exercise {
  const Exercise._();

  const factory Exercise({
    @Default(0) int id,
    @Default('') String title,
    @Default(0) int duration,
    @Default('') String description,
    @Default('') String category,
    @Default('') String age,
    @Default('') String goal,
    @Default(<String>[]) List<String> qualities,
    @JsonKey(includeToJson: false) String? image,
    @JsonKey(includeToJson: false) String? videoUrl,
    @JsonKey(includeToJson: false) String? createdAt,
    @Default(<ExerciseStep>[]) List<ExerciseStep> steps,
  }) = _Exercise;

  factory Exercise.fromJson(Map<String, dynamic> json) =>
      _$ExerciseFromJson(json);

  String get durationLabel => duration >= 60
      ? '${duration ~/ 60}n ${(duration % 60).toString().padLeft(2, '0')}s'
      : '${duration}s';

  bool get hasVideo => videoUrl != null && videoUrl!.isNotEmpty;
  bool get hasImage => image != null && image!.isNotEmpty;
}

/// Swagger: `POST /exercises/` — mashq yaratish/tahrirlash so'rovi.
@freezed
abstract class CreateExerciseRequest with _$CreateExerciseRequest {
  const factory CreateExerciseRequest({
    required String title,
    @Default(0) int duration,
    @Default('') String description,
    @Default('') String category,
    @Default('') String age,
    @Default('') String goal,
    @Default(<String>[]) List<String> qualities,
  }) = _CreateExerciseRequest;

  factory CreateExerciseRequest.fromJson(Map<String, dynamic> json) =>
      _$CreateExerciseRequestFromJson(json);
}

/// Yaratilayotgan mashq ichidagi bitta bosqich metadatasi.
/// Rasm fayli repository'ga alohida parallel ro'yxatda beriladi.
class ExerciseStepInput {
  final int? id;
  final String title;
  final String description;
  final String repetitions;
  final String rest;
  final int duration;

  ExerciseStepInput({
    this.id,
    this.title = '',
    this.description = '',
    this.repetitions = '',
    this.rest = '',
    this.duration = 0,
  });

  Map<String, dynamic> toJson() => {
    if (id != null) 'id': id,
    'title': title,
    'description': description,
    'repetitions': repetitions,
    'rest': rest,
    'duration': duration,
  };
}
