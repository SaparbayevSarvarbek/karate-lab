import 'package:freezed_annotation/freezed_annotation.dart';

part 'mjt_models.freezed.dart';
part 'mjt_models.g.dart';

/// MJT testi ichidagi bitta mashq (step).
@freezed
abstract class MjtStep with _$MjtStep {
  const factory MjtStep({
    @Default(0) int id,
    @Default('') String title,
    @Default('') String description,
    @Default('') String repetitions,
    @Default('') String rest,
    @Default('') String goal,
    @Default(<String>[]) List<String> images,
  }) = _MjtStep;

  factory MjtStep.fromJson(Map<String, dynamic> json) =>
      _$MjtStepFromJson(json);
}

/// `GET /mjt-tests/` — MJT testi (ro'yxat ko'rinishida steps siz).
@freezed
abstract class MjtTest with _$MjtTest {
  const MjtTest._();

  const factory MjtTest({
    @Default(0) int id,
    @Default('') String title,
    @Default('') String goal,
    @Default('') String ageGroup,
    String? coverUrl,
    @Default(<String>[]) List<String> qualities,
    @Default(<MjtStep>[]) List<MjtStep> steps,
    String? createdAt,
  }) = _MjtTest;

  factory MjtTest.fromJson(Map<String, dynamic> json) =>
      _$MjtTestFromJson(json);

  bool get hasCover => coverUrl != null && coverUrl!.isNotEmpty;
}
