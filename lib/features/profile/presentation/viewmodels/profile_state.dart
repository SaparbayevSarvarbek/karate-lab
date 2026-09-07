part of 'profile_bloc.dart';

abstract class ProfileState extends Equatable {
  const ProfileState();

  @override
  List<Object?> get props => [];
}

class ProfileInitial extends ProfileState {}

class ProfileLoading extends ProfileState {}

class ProfileSaving extends ProfileState {}

class SessionsLoading extends ProfileState {}

class ProfileLoaded extends ProfileState {
  final Profile profile;

  const ProfileLoaded(this.profile);

  @override
  List<Object?> get props => [profile];
}

class ProfileUpdated extends ProfileState {
  final Profile profile;
  final String message;

  const ProfileUpdated(this.profile, this.message);

  @override
  List<Object?> get props => [profile, message];
}

class SessionsLoaded extends ProfileState {
  final List<UserSession> sessions;

  const SessionsLoaded(this.sessions);

  @override
  List<Object?> get props => [sessions];
}

class ProfileActionSuccess extends ProfileState {
  final String message;

  const ProfileActionSuccess(this.message);

  @override
  List<Object?> get props => [message];
}

class ProfileActionError extends ProfileState {
  final String message;

  const ProfileActionError(this.message);

  @override
  List<Object?> get props => [message];
}

class ProfileError extends ProfileState {
  final String message;

  const ProfileError(this.message);

  @override
  List<Object?> get props => [message];
}
