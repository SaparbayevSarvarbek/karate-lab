import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/api/models/analytics_models.dart';
import '../../../../core/repositories/analytics_repository.dart';

part 'analytics_event.dart';
part 'analytics_state.dart';

class AnalyticsBloc extends Bloc<AnalyticsEvent, AnalyticsState> {
  final AnalyticsRepository _repository;

  AnalyticsBloc(this._repository) : super(AnalyticsInitial()) {
    on<LoadAthleteStatistics>(_onLoadAthleteStats);
    on<LoadCoachStatistics>(_onLoadCoachStats);
    on<LoadCoachAthletes>(_onLoadCoachAthletes);
    on<LoadCoachAthleteStatistics>(_onLoadCoachAthleteStats);
  }

  Future<void> _onLoadAthleteStats(
    LoadAthleteStatistics event,
    Emitter<AnalyticsState> emit,
  ) async {
    emit(AnalyticsLoading());
    final result = await _repository.getAthleteStatistics();
    result.fold(
      (error) => emit(AnalyticsError(error.message)),
      (stats) => emit(AthleteStatisticsLoaded(stats)),
    );
  }

  Future<void> _onLoadCoachStats(
    LoadCoachStatistics event,
    Emitter<AnalyticsState> emit,
  ) async {
    emit(AnalyticsLoading());
    final result = await _repository.getCoachStatistics();
    result.fold(
      (error) => emit(AnalyticsError(error.message)),
      (stats) => emit(CoachStatisticsLoaded(stats)),
    );
  }

  Future<void> _onLoadCoachAthletes(
    LoadCoachAthletes event,
    Emitter<AnalyticsState> emit,
  ) async {
    emit(AnalyticsLoading());
    final result = await _repository.getCoachAthletes();
    result.fold(
      (error) => emit(AnalyticsError(error.message)),
      (athletes) => emit(CoachAthletesLoaded(athletes)),
    );
  }

  Future<void> _onLoadCoachAthleteStats(
    LoadCoachAthleteStatistics event,
    Emitter<AnalyticsState> emit,
  ) async {
    emit(AnalyticsLoading());
    final result = await _repository.getCoachAthleteStatistics(event.athleteId);
    result.fold(
      (error) => emit(AnalyticsError(error.message)),
      (stats) => emit(AthleteStatisticsLoaded(stats)),
    );
  }
}
