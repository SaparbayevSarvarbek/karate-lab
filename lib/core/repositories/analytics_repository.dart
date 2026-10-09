import 'package:dartz/dartz.dart';

import '../api/api_client.dart';
import '../api/api_constants.dart';
import '../api/api_exception.dart';
import '../api/models/analytics_models.dart';

/// Analytics repository for athlete and coach statistics.
abstract class AnalyticsRepository {
  Future<Either<ApiException, AthleteStatistics>> getAthleteStatistics();
  Future<Either<ApiException, CoachStatistics>> getCoachStatistics();
  Future<Either<ApiException, List<AthleteSummary>>> getCoachAthletes();
  Future<Either<ApiException, AthleteStatistics>> getCoachAthleteStatistics(int athleteId);
}

class AnalyticsRepositoryImpl implements AnalyticsRepository {
  final ApiClient _apiClient;

  AnalyticsRepositoryImpl(this._apiClient);

  @override
  Future<Either<ApiException, AthleteStatistics>> getAthleteStatistics() async {
    try {
      final data = await _apiClient.getObject(ApiConstants.athleteStatistics);
      if (data == null) {
        return const Left(ApiException(message: 'Statistika topilmadi'));
      }
      return Right(AthleteStatistics.fromJson(data));
    } on ApiException catch (e) {
      return Left(e);
    }
  }

  @override
  Future<Either<ApiException, CoachStatistics>> getCoachStatistics() async {
    try {
      final data = await _apiClient.getObject(ApiConstants.coachStatistics);
      if (data == null) {
        return const Left(ApiException(message: 'Statistika topilmadi'));
      }
      return Right(CoachStatistics.fromJson(data));
    } on ApiException catch (e) {
      return Left(e);
    }
  }

  @override
  Future<Either<ApiException, List<AthleteSummary>>> getCoachAthletes() async {
    try {
      final items = await _apiClient.getList(ApiConstants.coachAthletes);
      return Right(items.map(AthleteSummary.fromJson).toList());
    } on ApiException catch (e) {
      return Left(e);
    }
  }

  @override
  Future<Either<ApiException, AthleteStatistics>> getCoachAthleteStatistics(
    int athleteId,
  ) async {
    try {
      final data = await _apiClient.getObject(
        ApiConstants.coachAthleteStatistics(athleteId),
      );
      if (data == null) {
        return const Left(ApiException(message: 'Statistika topilmadi'));
      }
      return Right(AthleteStatistics.fromJson(data));
    } on ApiException catch (e) {
      return Left(e);
    }
  }
}
