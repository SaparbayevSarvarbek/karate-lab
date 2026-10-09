import 'dart:convert';
import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import '../api/api_client.dart';
import '../api/api_constants.dart';
import '../api/api_exception.dart';
import '../api/models/category_models.dart';
import '../api/models/exercise_models.dart';

/// Mashqlar repository (Swagger: Exercises).
abstract class ExerciseRepository {
  Future<Either<ApiException, List<Category>>> getCategories();
  Future<Either<ApiException, List<Exercise>>> getExercises();
  Future<Either<ApiException, Exercise>> getExerciseById(int id);
  Future<Either<ApiException, Exercise>> createExercise(
    CreateExerciseRequest request, {
    File? image,
    File? video,
    String category = '',
    String age = '',
    String goal = '',
    List<String> qualities = const [],
    List<ExerciseStepInput> steps = const [],
    List<File?> stepImages = const [],
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
  Future<Either<ApiException, List<Category>>> getCategories() async {
    try {
      final items = await _apiClient.getList(ApiConstants.categories);
      return Right(items.map(Category.fromJson).toList());
    } on ApiException catch (e) {
      return Left(e);
    }
  }

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
    String age = '',
    String goal = '',
    List<String> qualities = const [],
    List<ExerciseStepInput> steps = const [],
    List<File?> stepImages = const [],
  }) async {
    try {
      final hasMedia = image != null || video != null;
      final hasSteps = steps.isNotEmpty;

      if (hasMedia || hasSteps) {
        final formData = FormData.fromMap({
          'title': request.title,
          'duration': request.duration,
          'description': request.description,
          'category': category,
          'age': age,
          'goal': goal,
          'qualities': jsonEncode(qualities),
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
          if (hasSteps)
            'steps': jsonEncode(steps.map((s) => s.toJson()).toList()),
        });

        for (var i = 0; i < stepImages.length; i++) {
          final f = stepImages[i];
          if (f != null) {
            formData.files.add(MapEntry(
              'step_image_$i',
              await MultipartFile.fromFile(
                f.path,
                filename: f.path.split(Platform.pathSeparator).last,
              ),
            ));
          }
        }

        final result = await _apiClient.postObject(
          ApiConstants.exercises,
          formData: formData,
        );
        if (result == null) {
          return const Left(ApiException(message: 'Server javob bermadi'));
        }
        return Right(Exercise.fromJson(result));
      } else {
        final payload = request.toJson();
        final result = await _apiClient.postObject(
          ApiConstants.exercises,
          data: payload,
        );
        if (result == null) {
          return const Left(ApiException(message: 'Server javob bermadi'));
        }
        return Right(Exercise.fromJson(result));
      }
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
