import 'package:dartz/dartz.dart';

import '../api/api_client.dart';
import '../api/api_constants.dart';
import '../api/api_exception.dart';
import '../api/models/dashboard_models.dart';

/// Dashboard va statistika repository (Swagger: Dashboard & Analytics).
abstract class DashboardRepository {
  Future<Either<ApiException, DashboardData>> getDashboard();
}

class DashboardRepositoryImpl implements DashboardRepository {
  final ApiClient _apiClient;

  DashboardRepositoryImpl(this._apiClient);

  @override
  Future<Either<ApiException, DashboardData>> getDashboard() async {
    try {
      final data = await _apiClient.getObject(ApiConstants.dashboard);
      if (data == null) {
        return const Left(ApiException(message: 'Server javob bermadi'));
      }
      return Right(DashboardData.fromJson(data));
    } on ApiException catch (e) {
      return Left(e);
    }
  }
}
