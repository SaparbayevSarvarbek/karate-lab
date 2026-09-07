// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dashboard_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_DashboardData _$DashboardDataFromJson(Map<String, dynamic> json) =>
    _DashboardData(
      role: json['role'] as String?,
      totalAthletes: (json['totalAthletes'] as num?)?.toInt(),
      activeAthletes: (json['activeAthletes'] as num?)?.toInt(),
      totalTests: (json['totalTests'] as num?)?.toInt(),
      totalExercises: (json['totalExercises'] as num?)?.toInt(),
      avgScore: (json['avgScore'] as num?)?.toDouble(),
      activeDays: (json['activeDays'] as num?)?.toInt(),
      completedTests: (json['completedTests'] as num?)?.toInt(),
      recentTests: (json['recentTests'] as List<dynamic>?)
          ?.map((e) => RecentTestResult.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$DashboardDataToJson(_DashboardData instance) =>
    <String, dynamic>{
      'role': instance.role,
      'totalAthletes': instance.totalAthletes,
      'activeAthletes': instance.activeAthletes,
      'totalTests': instance.totalTests,
      'totalExercises': instance.totalExercises,
      'avgScore': instance.avgScore,
      'activeDays': instance.activeDays,
      'completedTests': instance.completedTests,
      'recentTests': instance.recentTests,
    };

_MyStatistics _$MyStatisticsFromJson(Map<String, dynamic> json) =>
    _MyStatistics(
      avgScore: (json['avgScore'] as num?)?.toDouble(),
      activeDays: (json['activeDays'] as num?)?.toInt(),
      completedTests: (json['completedTests'] as num?)?.toInt(),
      recentTests:
          (json['recentTests'] as List<dynamic>?)
              ?.map((e) => RecentTestResult.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$MyStatisticsToJson(_MyStatistics instance) =>
    <String, dynamic>{
      'avgScore': instance.avgScore,
      'activeDays': instance.activeDays,
      'completedTests': instance.completedTests,
      'recentTests': instance.recentTests,
    };

_RecentTestResult _$RecentTestResultFromJson(Map<String, dynamic> json) =>
    _RecentTestResult(
      testName: json['testName'] as String? ?? '',
      score: (json['score'] as num?)?.toDouble() ?? 0,
      completedAt: json['completedAt'] == null
          ? null
          : DateTime.parse(json['completedAt'] as String),
    );

Map<String, dynamic> _$RecentTestResultToJson(_RecentTestResult instance) =>
    <String, dynamic>{
      'testName': instance.testName,
      'score': instance.score,
      'completedAt': instance.completedAt?.toIso8601String(),
    };
