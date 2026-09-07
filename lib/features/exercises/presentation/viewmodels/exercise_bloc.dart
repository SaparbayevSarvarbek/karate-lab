import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/repositories/exercise_repository.dart';
import '../../../../core/api/models/exercise_models.dart';

part 'exercise_event.dart';
part 'exercise_state.dart';

class ExerciseBloc extends Bloc<ExerciseEvent, ExerciseState> {
  final ExerciseRepository _repository;

  ExerciseBloc(this._repository) : super(ExerciseInitial()) {
    on<LoadExercises>(_onLoadExercises);
    on<CreateExercise>(_onCreateExercise);
    on<DeleteExercise>(_onDeleteExercise);
  }

  Future<void> _onLoadExercises(
    LoadExercises event,
    Emitter<ExerciseState> emit,
  ) async {
    emit(ExerciseLoading());
    final result = await _repository.getExercises();
    result.fold(
      (error) => emit(ExerciseError(error.message)),
      (exercises) => emit(ExercisesLoaded(exercises)),
    );
  }

  Future<void> _onCreateExercise(
    CreateExercise event,
    Emitter<ExerciseState> emit,
  ) async {
    emit(ExerciseActionLoading());
    final result = await _repository.createExercise(event.request);
    result.fold(
      (error) => emit(ExerciseError(error.message)),
      (_) => add(const LoadExercises()),
    );
  }

  Future<void> _onDeleteExercise(
    DeleteExercise event,
    Emitter<ExerciseState> emit,
  ) async {
    emit(ExerciseActionLoading());
    final result = await _repository.deleteExercise(event.id);
    result.fold(
      (error) => emit(ExerciseError(error.message)),
      (_) => add(const LoadExercises()),
    );
  }
}
