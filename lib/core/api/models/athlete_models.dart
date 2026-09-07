// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';

part 'athlete_models.freezed.dart';
part 'athlete_models.g.dart';

/// Swagger: `Athlete` — sportchi ma'lumotlari.
///
/// `avatar` faqat o'qish uchun (GET), yozishda yuborilmaydi.
/// Server kalitlari [ApiPayload] orqali camelCase ga normallashtiriladi.
@freezed
abstract class Athlete with _$Athlete {
  const Athlete._();

  const factory Athlete({
    @Default(0) int id,
    @Default('') String username,
    @Default('') String firstName,
    @Default('') String lastName,
    String? birthDate,
    String? phone,
    @JsonKey(includeToJson: false) String? avatar,
  }) = _Athlete;

  factory Athlete.fromJson(Map<String, dynamic> json) =>
      _$AthleteFromJson(json);

  String get fullName => '$firstName $lastName'.trim();

  int get age {
    if (birthDate == null || birthDate!.length < 4) return 0;
    final year = int.tryParse(birthDate!.substring(0, 4));
    if (year == null) return 0;
    return DateTime.now().year - year;
  }
}

/// Swagger: `POST /athletes/` — yangi atlet yaratish/tahrirlash so'rovi
/// (`firstName`, `lastName`, `birthDate` — 'YYYY-MM-DD').
@freezed
abstract class CreateAthleteRequest with _$CreateAthleteRequest {
  const factory CreateAthleteRequest({
    required String firstName,
    required String lastName,
    required String birthDate,
  }) = _CreateAthleteRequest;

  factory CreateAthleteRequest.fromJson(Map<String, dynamic> json) =>
      _$CreateAthleteRequestFromJson(json);
}
