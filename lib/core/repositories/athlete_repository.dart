import 'package:dartz/dartz.dart';

import '../api/api_client.dart';
import '../api/api_constants.dart';
import '../api/api_exception.dart';
import '../api/models/athlete_models.dart';
import '../l10n/app_translations.dart';

/// Sportchilar repository (Swagger: Athletes, JWT talab qiladi).
abstract class AthleteRepository {
  Future<Either<ApiException, List<Athlete>>> getAthletes({
    int page = 1,
    int size = 20,
  });
  Future<Either<ApiException, Athlete>> getAthleteById(int id);
  Future<Either<ApiException, Athlete>> createAthlete(
    CreateAthleteRequest request,
  );
  Future<Either<ApiException, Athlete>> updateAthlete(
    int id,
    CreateAthleteRequest request,
  );
  Future<Either<ApiException, void>> deleteAthlete(int id);
}

class AthleteRepositoryImpl implements AthleteRepository {
  final ApiClient _apiClient;

  AthleteRepositoryImpl(this._apiClient);

  @override
  Future<Either<ApiException, List<Athlete>>> getAthletes({
    int page = 1,
    int size = 20,
  }) async {
    try {
      final items = await _apiClient.getList(
        ApiConstants.athletes,
        queryParameters: {'page': page, 'size': size},
      );
      return Right(items.map(Athlete.fromJson).toList());
    } on ApiException catch (e) {
      return Left(e);
    }
  }

  @override
  Future<Either<ApiException, Athlete>> getAthleteById(int id) async {
    try {
      final data = await _apiClient.getObject(ApiConstants.athleteDetail(id));
      if (data == null) {
        return Left(ApiException(message: Tr.t('athleteNotFound')));
      }
      return Right(Athlete.fromJson(data));
    } on ApiException catch (e) {
      return Left(e);
    }
  }

  @override
  Future<Either<ApiException, Athlete>> createAthlete(
    CreateAthleteRequest request,
  ) async {
    try {
      final data = await _apiClient.postObject(
        ApiConstants.athletes,
        data: request.toJson(),
      );
      if (data == null) {
        return Left(ApiException(message: Tr.t('serverNoResponse')));
      }
      return Right(Athlete.fromJson(data));
    } on ApiException catch (e) {
      return Left(e);
    }
  }

  @override
  Future<Either<ApiException, Athlete>> updateAthlete(
    int id,
    CreateAthleteRequest request,
  ) async {
    try {
      final data = await _apiClient.putObject(
        ApiConstants.athleteDetail(id),
        data: request.toJson(),
      );
      if (data == null) {
        return Left(ApiException(message: Tr.t('serverNoResponse')));
      }
      return Right(Athlete.fromJson(data));
    } on ApiException catch (e) {
      return Left(e);
    }
  }

  @override
  Future<Either<ApiException, void>> deleteAthlete(int id) async {
    try {
      await _apiClient.deleteItem(ApiConstants.athleteDetail(id));
      return const Right(null);
    } on ApiException catch (e) {
      return Left(e);
    }
  }
}
