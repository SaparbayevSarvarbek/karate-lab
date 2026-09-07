import 'package:freezed_annotation/freezed_annotation.dart';

part 'ujt_models.freezed.dart';
part 'ujt_models.g.dart';

/// UJT testi ichidagi bitta mashq (step).
@freezed
abstract class UjtStep with _$UjtStep {
  const factory UjtStep({
    @Default(0) int id,
    @Default('') String title,
    @Default('') String description,
    @Default('') String repetitions,
    @Default('') String rest,
    @Default('') String distance,
    @Default(<String>[]) List<String> images,
  }) = _UjtStep;

  factory UjtStep.fromJson(Map<String, dynamic> json) => _$UjtStepFromJson(json);
}

/// `GET /ujt-tests/` — UJT testi (ro'yxat ko'rinishida steps siz).
@freezed
abstract class UjtTest with _$UjtTest {
  const UjtTest._();

  const factory UjtTest({
    @Default(0) int id,
    @Default('') String title,
    @Default('') String goal,
    @Default('') String ageGroup,
    String? coverUrl,
    @Default(<String>[]) List<String> qualities,
    @Default(<UjtStep>[]) @JsonKey(includeFromJson: false) List<UjtStep> steps,
    String? createdAt,
  }) = _UjtTest;

  factory UjtTest.fromJson(Map<String, dynamic> json) => _$UjtTestFromJson(json);

  bool get hasCover => coverUrl != null && coverUrl!.isNotEmpty;
}
