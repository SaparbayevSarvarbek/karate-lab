part of 'analytics_bloc.dart';

abstract class AnalyticsEvent extends Equatable {
  const AnalyticsEvent();

  @override
  List<Object?> get props => [];
}

class LoadAthleteStatistics extends AnalyticsEvent {
  const LoadAthleteStatistics();
}

class LoadCoachStatistics extends AnalyticsEvent {
  const LoadCoachStatistics();
}

class LoadCoachAthletes extends AnalyticsEvent {
  const LoadCoachAthletes();
}

class LoadCoachAthleteStatistics extends AnalyticsEvent {
  final int athleteId;

  const LoadCoachAthleteStatistics(this.athleteId);

  @override
  List<Object?> get props => [athleteId];
}
