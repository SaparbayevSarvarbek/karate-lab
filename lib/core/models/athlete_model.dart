import 'test_model.dart';

class AthleteModel {
  final String id;
  final String name;
  final int age;
  final String level; // Boshlang'ich, O'rta, Ilg'or, Pro
  final String club;
  final String belt;
  final int heightCm;
  final int weightKg;
  final double avgScore;
  final int activeDays;
  final int testsCount;
  final int trainingYears;
  final int weeklyTraining;
  final String imageUrl;
  final List<TestResultModel> tests;

  const AthleteModel({
    required this.id,
    required this.name,
    required this.age,
    required this.level,
    required this.club,
    required this.belt,
    required this.heightCm,
    required this.weightKg,
    required this.avgScore,
    required this.activeDays,
    required this.testsCount,
    required this.trainingYears,
    required this.weeklyTraining,
    required this.tests,
    this.imageUrl = '',
  });

  String get fullAgeLabel => '$age yosh';
  String get statsLabel => 'Faol kunlar: $activeDays';
}
