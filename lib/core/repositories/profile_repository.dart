import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import '../api/api_client.dart';
import '../api/api_constants.dart';
import '../api/api_exception.dart';
import '../api/models/profile_models.dart';

/// Profil repository (Swagger: Profile).
abstract class ProfileRepository {
  Future<Either<ApiException, Profile>> getProfile();
  Future<Either<ApiException, Profile>> updateProfile(
    UpdateProfileRequest request,
  );
  Future<Either<ApiException, void>> uploadAvatar(String filePath);
}

class ProfileRepositoryImpl implements ProfileRepository {
  final ApiClient _apiClient;

  ProfileRepositoryImpl(this._apiClient);

  @override
  Future<Either<ApiException, Profile>> getProfile() async {
    try {
      final data = await _apiClient.getObject(ApiConstants.profile);
      if (data == null) {
        return const Left(ApiException(message: 'Server javob bermadi'));
      }
      return Right(Profile.fromJson(data));
    } on ApiException catch (e) {
      return Left(e);
    }
  }

  @override
  Future<Either<ApiException, Profile>> updateProfile(
    UpdateProfileRequest request,
  ) async {
    try {
      final data = await _apiClient.putObject(
        ApiConstants.profile,
        data: request.toJson(),
      );
      if (data == null) {
        return const Left(ApiException(message: 'Server javob bermadi'));
      }
      return Right(Profile.fromJson(data));
    } on ApiException catch (e) {
      return Left(e);
    }
  }

  @override
  Future<Either<ApiException, void>> uploadAvatar(String filePath) async {
    try {
      final formData = FormData.fromMap({
        'avatar': await MultipartFile.fromFile(filePath),
      });
      await _apiClient.postObject(
        ApiConstants.profileAvatar,
        formData: formData,
      );
      return const Right(null);
    } on ApiException catch (e) {
      return Left(e);
    }
  }
}
