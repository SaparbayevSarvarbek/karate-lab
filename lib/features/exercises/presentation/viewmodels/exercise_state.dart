part of 'exercise_bloc.dart';

abstract class ExerciseState extends Equatable {
  const ExerciseState();

  @override
  List<Object?> get props => [];
}

class ExerciseInitial extends ExerciseState {}

class ExerciseLoading extends ExerciseState {}

class ExerciseActionLoading extends ExerciseState {}

class ExercisesLoaded extends ExerciseState {
  final List<Exercise> exercises;

  const ExercisesLoaded(this.exercises);

  @override
  List<Object?> get props => [exercises];
}

class ExerciseError extends ExerciseState {
  final String message;

  const ExerciseError(this.message);

  @override
  List<Object?> get props => [message];
}
