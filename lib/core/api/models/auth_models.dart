// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';

part 'auth_models.freezed.dart';
part 'auth_models.g.dart';

/// Login uchun yuboriladigan so'rov (Swagger: `Login`).
@freezed
abstract class LoginRequest with _$LoginRequest {
  const factory LoginRequest({
    required String username,
    required String password,
  }) = _LoginRequest;

  factory LoginRequest.fromJson(Map<String, dynamic> json) =>
      _$LoginRequestFromJson(json);
}

/// Ro'yxatdan o'tish so'rovi (`POST /auth/register/`).
@freezed
abstract class RegisterRequest with _$RegisterRequest {
  const factory RegisterRequest({
    required String username,
    required String password,
    required String firstName,
    required String lastName,
    required String role,
    @Default('') String phone,
    String? dateOfBirth,
    int? height,
    int? weight,
    String? group,
  }) = _RegisterRequest;

  factory RegisterRequest.fromJson(Map<String, dynamic> json) =>
      _$RegisterRequestFromJson(json);
}

/// Login natijasida qaytadigan javob.
@freezed
abstract class LoginResponse with _$LoginResponse {
  const factory LoginResponse({
    required String accessToken,
    required String refreshToken,
    required String role,
    @Default(AppUserInfo.empty) AppUserInfo user,
  }) = _LoginResponse;

  factory LoginResponse.fromJson(Map<String, dynamic> json) =>
      _$LoginResponseFromJson(json);
}

/// Token ichidagi foydalanuvchi ma'lumotlari.
@freezed
abstract class AppUserInfo with _$AppUserInfo {
  const AppUserInfo._();

  const factory AppUserInfo({
    @Default(0) int id,
    @Default('') String username,
    String? firstName,
    String? lastName,
    String? email,
  }) = _AppUserInfo;

  static const AppUserInfo empty = AppUserInfo();

  factory AppUserInfo.fromJson(Map<String, dynamic> json) =>
      _$AppUserInfoFromJson(json);

  String get displayName {
    final full = [firstName ?? '', lastName ?? '']
        .where((s) => s.trim().isNotEmpty)
        .join(' ');
    return full.isNotEmpty ? full : username;
  }
}

/// Logout uchun yuboriladigan so'rov (Swagger: `RefreshToken`).
@freezed
abstract class RefreshTokenRequest with _$RefreshTokenRequest {
  const factory RefreshTokenRequest({
    @JsonKey(name: 'refreshToken') required String refreshToken,
  }) = _RefreshTokenRequest;

  factory RefreshTokenRequest.fromJson(Map<String, dynamic> json) =>
      _$RefreshTokenRequestFromJson(json);
}

/// Token yangilash natijasida qaytadigan javob.
@freezed
abstract class RefreshTokenResponse with _$RefreshTokenResponse {
  const factory RefreshTokenResponse({
    required String accessToken,
  }) = _RefreshTokenResponse;

  factory RefreshTokenResponse.fromJson(Map<String, dynamic> json) =>
      _$RefreshTokenResponseFromJson(json);
}
