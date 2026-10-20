import 'package:dartz/dartz.dart';

import '../api/api_client.dart';
import '../api/api_constants.dart';
import '../api/api_exception.dart';
import '../api/models/dashboard_models.dart';
import '../l10n/app_translations.dart';

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
        return Left(ApiException(message: Tr.t('serverNoResponse')));
      }
      return Right(DashboardData.fromJson(data));
    } on ApiException catch (e) {
      return Left(e);
    }
  }
}
