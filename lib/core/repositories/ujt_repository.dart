import 'package:dartz/dartz.dart';

import '../api/api_client.dart';
import '../api/api_constants.dart';
import '../api/api_exception.dart';
import '../api/models/exercise_models.dart';
import '../api/models/ujt_models.dart';

/// Mashqlar repository: Texnik (/exercises/) + UJT (/ujt-tests/).
abstract class UjtRepository {
  Future<Either<ApiException, List<Exercise>>> getTexnikExercises();
  Future<Either<ApiException, List<UjtTest>>> getUjtTests({String search = ''});
  Future<Either<ApiException, UjtTest>> getUjtTestById(int id);
}

class UjtRepositoryImpl implements UjtRepository {
  final ApiClient _apiClient;

  UjtRepositoryImpl(this._apiClient);

  @override
  Future<Either<ApiException, List<Exercise>>> getTexnikExercises() async {
    try {
      final items = await _apiClient.getList(ApiConstants.exercises);
      return Right(items.map(Exercise.fromJson).toList());
    } on ApiException catch (e) {
      return Left(e);
    }
  }

  @override
  Future<Either<ApiException, List<UjtTest>>> getUjtTests({
    String search = '',
  }) async {
    try {
      final items = await _apiClient.getList(
        ApiConstants.ujtTests,
        queryParameters:
            search.isEmpty ? null : <String, dynamic>{'search': search},
      );
      return Right(items.map(UjtTest.fromJson).toList());
    } on ApiException catch (e) {
      return Left(e);
    }
  }

  @override
  Future<Either<ApiException, UjtTest>> getUjtTestById(int id) async {
    try {
      final data = await _apiClient.getObject(ApiConstants.ujtTestDetail(id));
      if (data == null) {
        return const Left(ApiException(message: 'UJT testi topilmadi'));
      }
      return Right(UjtTest.fromJson(data));
    } on ApiException catch (e) {
      return Left(e);
    }
  }
}
