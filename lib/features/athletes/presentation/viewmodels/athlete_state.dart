part of 'athlete_bloc.dart';

abstract class AthleteState extends Equatable {
  const AthleteState();

  @override
  List<Object?> get props => [];
}

class AthleteInitial extends AthleteState {}

class AthleteLoading extends AthleteState {}

class AthleteActionLoading extends AthleteState {}

class AthletesLoaded extends AthleteState {
  final List<Athlete> athletes;

  const AthletesLoaded(this.athletes);

  @override
  List<Object?> get props => [athletes];
}

class AthleteLoaded extends AthleteState {
  final Athlete athlete;

  const AthleteLoaded(this.athlete);

  @override
  List<Object?> get props => [athlete];
}

class AthleteError extends AthleteState {
  final String message;

  const AthleteError(this.message);

  @override
  List<Object?> get props => [message];
}
