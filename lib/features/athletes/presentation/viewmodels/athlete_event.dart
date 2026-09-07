part of 'athlete_bloc.dart';

abstract class AthleteEvent extends Equatable {
  const AthleteEvent();

  @override
  List<Object?> get props => [];
}

class LoadAthletes extends AthleteEvent {
  final int page;
  final int size;

  const LoadAthletes({this.page = 1, this.size = 20});
}

class LoadAthleteById extends AthleteEvent {
  final int id;

  const LoadAthleteById(this.id);

  @override
  List<Object?> get props => [id];
}

class AddAthlete extends AthleteEvent {
  final CreateAthleteRequest request;

  const AddAthlete(this.request);

  @override
  List<Object?> get props => [request];
}

class DeleteAthlete extends AthleteEvent {
  final int id;

  const DeleteAthlete(this.id);

  @override
  List<Object?> get props => [id];
}
