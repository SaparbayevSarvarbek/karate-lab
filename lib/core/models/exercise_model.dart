class ExerciseModel {
  final String id;
  final String name;
  final String category; // Texnika, Kuch, Chidamlilik, Egiluvchanlik, Tezkorlik
  final String difficulty; // Boshlang'ich, O'rta, Murakkab
  final String description;
  final int sets;
  final int reps;
  final int durationMin;
  final List<String> tags;
  final List<String> steps;
  final String imageUrl;

  const ExerciseModel({
    required this.id,
    required this.name,
    required this.category,
    required this.difficulty,
    required this.description,
    required this.sets,
    required this.reps,
    required this.durationMin,
    required this.tags,
    required this.steps,
    this.imageUrl = '',
  });

  String get statsLabel => '$sets x $reps';
}
