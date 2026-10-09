/// Analytics models for athlete and coach statistics.
/// Using plain Dart classes instead of freezed to save time.

class DataPoint {
  final String label;
  final double value;

  const DataPoint({required this.label, required this.value});

  factory DataPoint.fromJson(Map<String, dynamic> json) => DataPoint(
        label: json['label']?.toString() ?? '',
        value: (json['value'] as num?)?.toDouble() ?? 0.0,
      );
}

class AthleteStatistics {
  final String role;
  final int totalTests;
  final int completedTests;
  final int pendingTests;
  final double? averageScore;
  final double? bestScore;
  final double successRate;
  final List<RecentResult> recentResults;
  final List<DataPoint> scoreOverTime;
  final List<DataPoint> testPerformance;

  const AthleteStatistics({
    required this.role,
    required this.totalTests,
    required this.completedTests,
    required this.pendingTests,
    this.averageScore,
    this.bestScore,
    required this.successRate,
    required this.recentResults,
    required this.scoreOverTime,
    required this.testPerformance,
  });

  factory AthleteStatistics.fromJson(Map<String, dynamic> json) {
    return AthleteStatistics(
      role: json['role']?.toString() ?? 'athlete',
      totalTests: json['totalTests'] as int? ?? 0,
      completedTests: json['completedTests'] as int? ?? 0,
      pendingTests: json['pendingTests'] as int? ?? 0,
      averageScore: (json['averageScore'] as num?)?.toDouble(),
      bestScore: (json['bestScore'] as num?)?.toDouble(),
      successRate: (json['successRate'] as num?)?.toDouble() ?? 0.0,
      recentResults: (json['recentResults'] as List<dynamic>?)
              ?.map((e) => RecentResult.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      scoreOverTime: (json['scoreOverTime'] as List<dynamic>?)
              ?.map((e) => DataPoint.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      testPerformance: (json['testPerformance'] as List<dynamic>?)
              ?.map((e) => DataPoint.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }
}

class RecentResult {
  final int testId;
  final String testName;
  final double score;
  final DateTime? completedAt;

  const RecentResult({
    required this.testId,
    required this.testName,
    required this.score,
    this.completedAt,
  });

  factory RecentResult.fromJson(Map<String, dynamic> json) => RecentResult(
        testId: json['testId'] as int? ?? 0,
        testName: json['testName']?.toString() ?? '',
        score: (json['score'] as num?)?.toDouble() ?? 0.0,
        completedAt: json['completedAt'] != null
            ? DateTime.tryParse(json['completedAt'].toString())
            : null,
      );
}

class CompletionData {
  final int completed;
  final int pending;

  const CompletionData({required this.completed, required this.pending});

  factory CompletionData.fromJson(Map<String, dynamic> json) => CompletionData(
        completed: json['completed'] as int? ?? 0,
        pending: json['pending'] as int? ?? 0,
      );
}

class CoachStatistics {
  final String role;
  final int totalAthletes;
  final int totalTests;
  final int completedTests;
  final int pendingTests;
  final double? averageScore;
  final double? averagePerformance;
  final List<DataPoint> athletesPerformance;
  final List<DataPoint> scoreOverTime;
  final CompletionData completion;
  final List<DataPoint> performanceDistribution;

  const CoachStatistics({
    required this.role,
    required this.totalAthletes,
    required this.totalTests,
    required this.completedTests,
    required this.pendingTests,
    this.averageScore,
    this.averagePerformance,
    required this.athletesPerformance,
    required this.scoreOverTime,
    required this.completion,
    required this.performanceDistribution,
  });

  factory CoachStatistics.fromJson(Map<String, dynamic> json) {
    return CoachStatistics(
      role: json['role']?.toString() ?? 'coach',
      totalAthletes: json['totalAthletes'] as int? ?? 0,
      totalTests: json['totalTests'] as int? ?? 0,
      completedTests: json['completedTests'] as int? ?? 0,
      pendingTests: json['pendingTests'] as int? ?? 0,
      averageScore: (json['averageScore'] as num?)?.toDouble(),
      averagePerformance: (json['averagePerformance'] as num?)?.toDouble(),
      athletesPerformance: (json['athletesPerformance'] as List<dynamic>?)
              ?.map((e) => DataPoint.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      scoreOverTime: (json['scoreOverTime'] as List<dynamic>?)
              ?.map((e) => DataPoint.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      completion: json['completion'] != null
          ? CompletionData.fromJson(json['completion'] as Map<String, dynamic>)
          : const CompletionData(completed: 0, pending: 0),
      performanceDistribution: (json['performanceDistribution'] as List<dynamic>?)
              ?.map((e) => DataPoint.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }
}

class AthleteSummary {
  final int id;
  final String username;
  final String firstName;
  final String lastName;
  final String? avatar;
  final int totalTests;
  final int completedTests;
  final double? averageScore;
  final double? bestScore;
  final DateTime? lastActivity;
  final String performance;

  const AthleteSummary({
    required this.id,
    required this.username,
    required this.firstName,
    required this.lastName,
    this.avatar,
    required this.totalTests,
    required this.completedTests,
    this.averageScore,
    this.bestScore,
    this.lastActivity,
    required this.performance,
  });

  factory AthleteSummary.fromJson(Map<String, dynamic> json) => AthleteSummary(
        id: json['id'] as int? ?? 0,
        username: json['username']?.toString() ?? '',
        firstName: json['firstName']?.toString() ?? '',
        lastName: json['lastName']?.toString() ?? '',
        avatar: json['avatar']?.toString(),
        totalTests: json['totalTests'] as int? ?? 0,
        completedTests: json['completedTests'] as int? ?? 0,
        averageScore: (json['averageScore'] as num?)?.toDouble(),
        bestScore: (json['bestScore'] as num?)?.toDouble(),
        lastActivity: json['lastActivity'] != null
            ? DateTime.tryParse(json['lastActivity'].toString())
            : null,
        performance: json['performance']?.toString() ?? 'none',
      );

  String get fullName => '$firstName $lastName'.trim();
}
