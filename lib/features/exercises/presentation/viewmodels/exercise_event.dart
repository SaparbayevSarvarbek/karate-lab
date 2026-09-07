part of 'exercise_bloc.dart';

abstract class ExerciseEvent extends Equatable {
  const ExerciseEvent();

  @override
  List<Object?> get props => [];
}

class LoadExercises extends ExerciseEvent {
  const LoadExercises();
}

class CreateExercise extends ExerciseEvent {
  final CreateExerciseRequest request;

  const CreateExercise(this.request);

  @override
  List<Object?> get props => [request];
}

class DeleteExercise extends ExerciseEvent {
  final int id;

  const DeleteExercise(this.id);

  @override
  List<Object?> get props => [id];
}
