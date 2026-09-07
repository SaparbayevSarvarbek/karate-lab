class TestResultModel {
  final String date;
  final double score;
  final bool improved;

  const TestResultModel({
    required this.date,
    required this.score,
    required this.improved,
  });
}

class TestModel {
  final String id;
  final String name;
  final String category; // Kuch, Tezkorlik, Chidamlilik, Texnika, Muvozanat
  final String description;
  final int durationMin;
  final int questions;
  final int attempts;
  final double minScore;
  final double maxScore;
  final double avgScore;
  final int participants;
  final List<TestResultModel> history;

  const TestModel({
    required this.id,
    required this.name,
    required this.category,
    required this.description,
    required this.durationMin,
    required this.questions,
    required this.attempts,
    required this.minScore,
    required this.maxScore,
    required this.avgScore,
    required this.participants,
    required this.history,
  });
}
