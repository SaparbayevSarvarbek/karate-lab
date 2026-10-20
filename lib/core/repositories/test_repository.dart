import 'dart:convert';
import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import '../api/api_client.dart';
import '../api/api_constants.dart';
import '../api/api_exception.dart';
import '../api/models/test_models.dart';
import '../l10n/app_translations.dart';

/// Testlar repository (Swagger: Tests, Athlete Tests).
abstract class TestRepository {
  Future<Either<ApiException, List<TestResult>>> getMyTests();
  Future<Either<ApiException, List<TestEntity>>> getAllTests();
  Future<Either<ApiException, TestResult>> startTest(int id);
  Future<Either<ApiException, TestResult>> finishTest(
    int id,
    FinishTestRequest request,
  );
  Future<Either<ApiException, List<TestEntity>>> getCoachTests();
  Future<Either<ApiException, TestEntity>> getCoachTestDetail(int id);
  Future<Either<ApiException, TestEntity>> updateTest(
    int id,
    CreateTestRequest request, {
    File? cover,
    List<TestStepInput> steps = const [],
    List<File?> stepImages = const [],
  });
  Future<Either<ApiException, TestEntity>> createTest(
    CreateTestRequest request, {
    File? cover,
    List<TestStepInput> steps = const [],
    List<File?> stepImages = const [],
  });
}

class TestRepositoryImpl implements TestRepository {
  final ApiClient _apiClient;

  TestRepositoryImpl(this._apiClient);

  @override
  Future<Either<ApiException, List<TestResult>>> getMyTests() async {
    try {
      final items = await _apiClient.getList(ApiConstants.myTests);
      return Right(items.map(TestResult.fromJson).toList());
    } on ApiException catch (e) {
      return Left(e);
    }
  }

  @override
  Future<Either<ApiException, TestResult>> startTest(int id) async {
    try {
      final data = await _apiClient.postObject(ApiConstants.startTest(id));
      if (data == null) {
        return Left(ApiException(message: Tr.t('serverNoResponse')));
      }
      return Right(TestResult.fromJson(data));
    } on ApiException catch (e) {
      return Left(e);
    }
  }

  @override
  Future<Either<ApiException, TestResult>> finishTest(
    int id,
    FinishTestRequest request,
  ) async {
    try {
      final data = await _apiClient.postObject(
        ApiConstants.finishTest(id),
        data: request.toJson(),
      );
      if (data == null) {
        return Left(ApiException(message: Tr.t('serverNoResponse')));
      }
      return Right(TestResult.fromJson(data));
    } on ApiException catch (e) {
      return Left(e);
    }
  }

  @override
  Future<Either<ApiException, List<TestEntity>>> getAllTests() async {
    try {
      final items = await _apiClient.getList(ApiConstants.tests);
      return Right(items.map(TestEntity.fromJson).toList());
    } on ApiException catch (e) {
      return Left(e);
    }
  }

  @override
  Future<Either<ApiException, List<TestEntity>>> getCoachTests() async {
    try {
      final items = await _apiClient.getList(ApiConstants.tests);
      return Right(items.map(TestEntity.fromJson).toList());
    } on ApiException catch (e) {
      return Left(e);
    }
  }

  @override
  Future<Either<ApiException, TestEntity>> getCoachTestDetail(int id) async {
    try {
      final data = await _apiClient.getObject(ApiConstants.testDetail(id));
      if (data == null) {
        return Left(ApiException(message: Tr.t('serverNoResponse')));
      }
      return Right(TestEntity.fromJson(data));
    } on ApiException catch (e) {
      return Left(e);
    }
  }

  @override
  Future<Either<ApiException, TestEntity>> createTest(
    CreateTestRequest request, {
    File? cover,
    List<TestStepInput> steps = const [],
    List<File?> stepImages = const [],
  }) async {
    try {
      final hasSteps = steps.isNotEmpty;
      if (cover == null && !hasSteps) {
        final data = await _apiClient.postObject(
          ApiConstants.tests,
          data: request.toJson(),
        );
        if (data == null) {
          return Left(ApiException(message: Tr.t('serverNoResponse')));
        }
        return Right(TestEntity.fromJson(data));
      }

      final formData = FormData.fromMap({
        'name': request.name,
        'description': request.description,
        'category': request.category,
        'age': request.age,
        'goal': request.goal,
        'qualities': jsonEncode(request.qualities),
        if (cover != null)
          'cover': await MultipartFile.fromFile(
            cover.path,
            filename: cover.path.split(Platform.pathSeparator).last,
          ),
        if (hasSteps)
          'steps': jsonEncode(steps.map((s) => s.toJson()).toList()),
      });

      for (var i = 0; i < stepImages.length; i++) {
        final f = stepImages[i];
        if (f != null) {
          formData.files.add(
            MapEntry(
              'step_image_$i',
              await MultipartFile.fromFile(
                f.path,
                filename: f.path.split(Platform.pathSeparator).last,
              ),
            ),
          );
        }
      }

      final data = await _apiClient.postObject(
        ApiConstants.tests,
        formData: formData,
      );
      if (data == null) {
        return Left(ApiException(message: Tr.t('serverNoResponse')));
      }
      return Right(TestEntity.fromJson(data));
    } on ApiException catch (e) {
      return Left(e);
    }
  }

  @override
  Future<Either<ApiException, TestEntity>> updateTest(
    int id,
    CreateTestRequest request, {
    File? cover,
    List<TestStepInput> steps = const [],
    List<File?> stepImages = const [],
  }) async {
    try {
      final formData = FormData.fromMap({
        'name': request.name,
        'description': request.description,
        'category': request.category,
        'age': request.age,
        'goal': request.goal,
        'qualities': jsonEncode(request.qualities),
        'steps': jsonEncode(steps.map((step) => step.toJson()).toList()),
        if (cover != null)
          'cover': await MultipartFile.fromFile(
            cover.path,
            filename: cover.path.split(Platform.pathSeparator).last,
          ),
      });

      for (var i = 0; i < stepImages.length; i++) {
        final image = stepImages[i];
        if (image != null) {
          formData.files.add(
            MapEntry(
              'step_image_$i',
              await MultipartFile.fromFile(
                image.path,
                filename: image.path.split(Platform.pathSeparator).last,
              ),
            ),
          );
        }
      }

      final data = await _apiClient.putObject(
        ApiConstants.testDetail(id),
        data: formData,
      );
      if (data == null) {
        return Left(ApiException(message: Tr.t('serverNoResponse')));
      }
      return Right(TestEntity.fromJson(data));
    } on ApiException catch (e) {
      return Left(e);
    }
  }
}
