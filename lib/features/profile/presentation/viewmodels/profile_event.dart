part of 'profile_bloc.dart';

abstract class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object?> get props => [];
}

class LoadProfile extends ProfileEvent {
  const LoadProfile();
}

class UpdateProfileData extends ProfileEvent {
  final UpdateProfileRequest request;
  final String successMessage;

  const UpdateProfileData({
    required this.request,
    this.successMessage = 'Profil yangilandi',
  });

  @override
  List<Object?> get props => [request];
}

class UploadProfileAvatar extends ProfileEvent {
  final String filePath;

  const UploadProfileAvatar(this.filePath);

  @override
  List<Object?> get props => [filePath];
}

class ChangeSecurityPassword extends ProfileEvent {
  final ChangePasswordRequest request;

  const ChangeSecurityPassword(this.request);

  @override
  List<Object?> get props => [request];
}

class LoadActiveSessions extends ProfileEvent {
  const LoadActiveSessions();
}

class TerminateOtherSessions extends ProfileEvent {
  const TerminateOtherSessions();
}
