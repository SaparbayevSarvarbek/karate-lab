import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import '../api/api_client.dart';
import '../api/api_constants.dart';
import '../api/api_exception.dart';
import '../api/models/exercise_models.dart';

/// Mashqlar repository (Swagger: Exercises).
abstract class ExerciseRepository {
  Future<Either<ApiException, List<Exercise>>> getExercises();
  Future<Either<ApiException, Exercise>> getExerciseById(int id);
  Future<Either<ApiException, Exercise>> createExercise(
    CreateExerciseRequest request, {
    File? image,
    File? video,
    String category = '',
  });
  Future<Either<ApiException, Exercise>> updateExercise(
    int id,
    CreateExerciseRequest request,
  );
  Future<Either<ApiException, void>> deleteExercise(int id);
}

class ExerciseRepositoryImpl implements ExerciseRepository {
  final ApiClient _apiClient;

  ExerciseRepositoryImpl(this._apiClient);

  @override
  Future<Either<ApiException, List<Exercise>>> getExercises() async {
    try {
      final items = await _apiClient.getList(ApiConstants.exercises);
      return Right(items.map(Exercise.fromJson).toList());
    } on ApiException catch (e) {
      return Left(e);
    }
  }

  @override
  Future<Either<ApiException, Exercise>> getExerciseById(int id) async {
    try {
      final data = await _apiClient.getObject(ApiConstants.exerciseDetail(id));
      if (data == null) {
        return const Left(ApiException(message: 'Mashq topilmadi'));
      }
      return Right(Exercise.fromJson(data));
    } on ApiException catch (e) {
      return Left(e);
    }
  }

  @override
  Future<Either<ApiException, Exercise>> createExercise(
    CreateExerciseRequest request, {
    File? image,
    File? video,
    String category = '',
  }) async {
    try {
      Map<String, dynamic>? result;
      if (image != null || video != null) {
        final formData = FormData.fromMap({
          'title': request.title,
          'duration': request.duration,
          'description': request.description,
          'category': category,
          if (image != null)
            'image': await MultipartFile.fromFile(
              image.path,
              filename: image.path.split(Platform.pathSeparator).last,
            ),
          if (video != null)
            'video': await MultipartFile.fromFile(
              video.path,
              filename: video.path.split(Platform.pathSeparator).last,
            ),
        });
        result = await _apiClient.postObject(
          ApiConstants.exercises,
          formData: formData,
        );
      } else {
        final payload = request.toJson();
        if (category.isNotEmpty) payload['category'] = category;
        result = await _apiClient.postObject(
          ApiConstants.exercises,
          data: payload,
        );
      }
      if (result == null) {
        return const Left(ApiException(message: 'Server javob bermadi'));
      }
      return Right(Exercise.fromJson(result));
    } on ApiException catch (e) {
      return Left(e);
    }
  }

  @override
  Future<Either<ApiException, Exercise>> updateExercise(
    int id,
    CreateExerciseRequest request,
  ) async {
    try {
      final data = await _apiClient.putObject(
        ApiConstants.exerciseDetail(id),
        data: request.toJson(),
      );
      if (data == null) {
        return const Left(ApiException(message: 'Server javob bermadi'));
      }
      return Right(Exercise.fromJson(data));
    } on ApiException catch (e) {
      return Left(e);
    }
  }

  @override
  Future<Either<ApiException, void>> deleteExercise(int id) async {
    try {
      await _apiClient.deleteItem(ApiConstants.exerciseDetail(id));
      return const Right(null);
    } on ApiException catch (e) {
      return Left(e);
    }
  }
}
