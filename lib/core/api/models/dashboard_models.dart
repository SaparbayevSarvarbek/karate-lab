import 'package:freezed_annotation/freezed_annotation.dart';

part 'dashboard_models.freezed.dart';
part 'dashboard_models.g.dart';

/// Swagger: `GET /dashboard/` — roliga mos statistika.
///
/// Murabbiy uchun: `totalAthletes`, `activeAthletes`, `totalTests`,
/// `totalExercises`. Atlet uchun: `avgScore`, `activeDays`, `completedTests`.
/// Barcha maydonlar neytral qilib yig'ilgan, endpoint goliga qarab
/// foydalaniladi.
@freezed
abstract class DashboardData with _$DashboardData {
  const factory DashboardData({
    String? role,
    int? totalAthletes,
    int? activeAthletes,
    int? totalTests,
    int? totalExercises,
    double? avgScore,
    int? activeDays,
    int? completedTests,
    List<RecentTestResult>? recentTests,
  }) = _DashboardData;

  factory DashboardData.fromJson(Map<String, dynamic> json) =>
      _$DashboardDataFromJson(json);
}

/// Swagger: `GET /my-statistics/` — atletning shaxsiy statistikasi.
@freezed
abstract class MyStatistics with _$MyStatistics {
  const factory MyStatistics({
    double? avgScore,
    int? activeDays,
    int? completedTests,
    @Default([]) List<RecentTestResult> recentTests,
  }) = _MyStatistics;

  factory MyStatistics.fromJson(Map<String, dynamic> json) =>
      _$MyStatisticsFromJson(json);
}

/// Atletning so'nggi test natijalari.
@freezed
abstract class RecentTestResult with _$RecentTestResult {
  const factory RecentTestResult({
    @Default('') String testName,
    @Default(0) double score,
    DateTime? completedAt,
  }) = _RecentTestResult;

  factory RecentTestResult.fromJson(Map<String, dynamic> json) =>
      _$RecentTestResultFromJson(json);
}
