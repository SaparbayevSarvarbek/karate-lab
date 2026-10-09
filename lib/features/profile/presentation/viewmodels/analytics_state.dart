part of 'analytics_bloc.dart';

abstract class AnalyticsState extends Equatable {
  const AnalyticsState();

  @override
  List<Object?> get props => [];
}

class AnalyticsInitial extends AnalyticsState {}

class AnalyticsLoading extends AnalyticsState {}

class AthleteStatisticsLoaded extends AnalyticsState {
  final AthleteStatistics statistics;

  const AthleteStatisticsLoaded(this.statistics);

  @override
  List<Object?> get props => [statistics];
}

class CoachStatisticsLoaded extends AnalyticsState {
  final CoachStatistics statistics;

  const CoachStatisticsLoaded(this.statistics);

  @override
  List<Object?> get props => [statistics];
}

class CoachAthletesLoaded extends AnalyticsState {
  final List<AthleteSummary> athletes;

  const CoachAthletesLoaded(this.athletes);

  @override
  List<Object?> get props => [athletes];
}

class AnalyticsError extends AnalyticsState {
  final String message;

  const AnalyticsError(this.message);

  @override
  List<Object?> get props => [message];
}
