// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';

part 'exercise_models.freezed.dart';
part 'exercise_models.g.dart';

/// Swagger: `Exercise` — mashq (`title`, `duration`, `description`, media).
@freezed
abstract class Exercise with _$Exercise {
  const Exercise._();

  const factory Exercise({
    @Default(0) int id,
    @Default('') String title,
    @Default(0) int duration,
    @Default('') String description,
    @Default('') String category,
    @JsonKey(includeToJson: false) String? image,
    @JsonKey(includeToJson: false) String? videoUrl,
    @JsonKey(includeToJson: false) String? createdAt,
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
    required int duration,
    @Default('') String description,
  }) = _CreateExerciseRequest;

  factory CreateExerciseRequest.fromJson(Map<String, dynamic> json) =>
      _$CreateExerciseRequestFromJson(json);
}
