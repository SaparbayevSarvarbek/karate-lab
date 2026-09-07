import 'package:dartz/dartz.dart';

import '../api/api_client.dart';
import '../api/api_constants.dart';
import '../api/api_exception.dart';
import '../api/models/test_models.dart';

/// Testlar repository (Swagger: Tests, Athlete Tests).
abstract class TestRepository {
  Future<Either<ApiException, List<TestAssignment>>> getMyTests();
  Future<Either<ApiException, TestAssignment>> startTest(int id);
  Future<Either<ApiException, void>> finishTest(
    int id,
    FinishTestRequest request,
  );
  Future<Either<ApiException, List<TestEntity>>> getCoachTests();
  Future<Either<ApiException, TestEntity>> createTest(CreateTestRequest request);
  Future<Either<ApiException, void>> assignTest(
    int id,
    AssignTestRequest request,
  );
}

class TestRepositoryImpl implements TestRepository {
  final ApiClient _apiClient;

  TestRepositoryImpl(this._apiClient);

  @override
  Future<Either<ApiException, List<TestAssignment>>> getMyTests() async {
    try {
      final items = await _apiClient.getList(ApiConstants.myTests);
      return Right(items.map(TestAssignment.fromJson).toList());
    } on ApiException catch (e) {
      return Left(e);
    }
  }

  @override
  Future<Either<ApiException, TestAssignment>> startTest(int id) async {
    try {
      final data = await _apiClient.postObject(ApiConstants.startTest(id));
      if (data == null) {
        return const Left(ApiException(message: 'Server javob bermadi'));
      }
      return Right(TestAssignment.fromJson(data));
    } on ApiException catch (e) {
      return Left(e);
    }
  }

  @override
  Future<Either<ApiException, void>> finishTest(
    int id,
    FinishTestRequest request,
  ) async {
    try {
      await _apiClient.postObject(
        ApiConstants.finishTest(id),
        data: request.toJson(),
      );
      return const Right(null);
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
  Future<Either<ApiException, TestEntity>> createTest(
    CreateTestRequest request,
  ) async {
    try {
      final data = await _apiClient.postObject(
        ApiConstants.tests,
        data: request.toJson(),
      );
      if (data == null) {
        return const Left(ApiException(message: 'Server javob bermadi'));
      }
      return Right(TestEntity.fromJson(data));
    } on ApiException catch (e) {
      return Left(e);
    }
  }

  @override
  Future<Either<ApiException, void>> assignTest(
    int id,
    AssignTestRequest request,
  ) async {
    try {
      await _apiClient.postObject(
        ApiConstants.assignTest(id),
        data: request.toJson(),
      );
      return const Right(null);
    } on ApiException catch (e) {
      return Left(e);
    }
  }
}
