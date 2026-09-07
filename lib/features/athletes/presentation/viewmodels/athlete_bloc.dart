import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/repositories/athlete_repository.dart';
import '../../../../core/api/models/athlete_models.dart';

part 'athlete_event.dart';
part 'athlete_state.dart';

class AthleteBloc extends Bloc<AthleteEvent, AthleteState> {
  final AthleteRepository _repository;

  AthleteBloc(this._repository) : super(AthleteInitial()) {
    on<LoadAthletes>(_onLoadAthletes);
    on<LoadAthleteById>(_onLoadAthleteById);
    on<AddAthlete>(_onAddAthlete);
    on<DeleteAthlete>(_onDeleteAthlete);
  }

  Future<void> _onLoadAthletes(
    LoadAthletes event,
    Emitter<AthleteState> emit,
  ) async {
    emit(AthleteLoading());
    final result = await _repository.getAthletes(
      page: event.page,
      size: event.size,
    );
    result.fold(
      (error) => emit(AthleteError(error.message)),
      (athletes) => emit(AthletesLoaded(athletes)),
    );
  }

  Future<void> _onLoadAthleteById(
    LoadAthleteById event,
    Emitter<AthleteState> emit,
  ) async {
    emit(AthleteLoading());
    final result = await _repository.getAthleteById(event.id);
    result.fold(
      (error) => emit(AthleteError(error.message)),
      (athlete) => emit(AthleteLoaded(athlete)),
    );
  }

  Future<void> _onAddAthlete(
    AddAthlete event,
    Emitter<AthleteState> emit,
  ) async {
    emit(AthleteActionLoading());
    final result = await _repository.createAthlete(event.request);
    result.fold(
      (error) => emit(AthleteError(error.message)),
      (_) => add(const LoadAthletes()),
    );
  }

  Future<void> _onDeleteAthlete(
    DeleteAthlete event,
    Emitter<AthleteState> emit,
  ) async {
    emit(AthleteActionLoading());
    final result = await _repository.deleteAthlete(event.id);
    result.fold(
      (error) => emit(AthleteError(error.message)),
      (_) => add(const LoadAthletes()),
    );
  }
}
