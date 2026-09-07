// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';

part 'profile_models.freezed.dart';
part 'profile_models.g.dart';

/// Swagger: `Profile` — joriy foydalanuvchi profili.
@freezed
abstract class Profile with _$Profile {
  const Profile._();

  const factory Profile({
    @Default(0) int id,
    @Default('') String username,
    @Default('') String fullName,
    @Default('') String phone,
    @Default('') String role,
    String? email,
    String? avatar,
    String? birthDate,
    int? heightCm,
    int? weightKg,
  }) = _Profile;

  factory Profile.fromJson(Map<String, dynamic> json) =>
      _$ProfileFromJson(json);

  bool get isCoach => role.toUpperCase() == 'COACH';

  String get roleLabel => isCoach ? 'Murabbiy' : 'Sportchi';
}

/// Swagger: `PUT /profile/` — profilni yangilash so'rovi.
@freezed
abstract class UpdateProfileRequest with _$UpdateProfileRequest {
  const factory UpdateProfileRequest({
    required String fullName,
    required String phone,
    String? birthDate,
    int? heightCm,
    int? weightKg,
  }) = _UpdateProfileRequest;

  factory UpdateProfileRequest.fromJson(Map<String, dynamic> json) =>
      _$UpdateProfileRequestFromJson(json);
}
