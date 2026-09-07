import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/repositories/profile_repository.dart';
import '../../../../core/repositories/settings_repository.dart';
import '../../../../core/api/models/profile_models.dart';
import '../../../../core/api/models/settings_models.dart';

part 'profile_event.dart';
part 'profile_state.dart';

/// Profil, sozlamalar, xavfsizlik va bildirishnomalar uchun ViewModel.
class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final ProfileRepository _profileRepository;
  final SettingsRepository _settingsRepository;

  ProfileBloc(this._profileRepository, this._settingsRepository)
      : super(ProfileInitial()) {
    on<LoadProfile>(_onLoadProfile);
    on<UpdateProfileData>(_onUpdateProfileData);
    on<UploadProfileAvatar>(_onUploadAvatar);
    on<ChangeSecurityPassword>(_onChangePassword);
    on<LoadActiveSessions>(_onLoadSessions);
    on<TerminateOtherSessions>(_onTerminateOtherSessions);
  }

  Future<void> _onLoadProfile(
    LoadProfile event,
    Emitter<ProfileState> emit,
  ) async {
    emit(ProfileLoading());
    final result = await _profileRepository.getProfile();
    result.fold(
      (error) => emit(ProfileError(error.message)),
      (profile) => emit(ProfileLoaded(profile)),
    );
  }

  Future<void> _onUpdateProfileData(
    UpdateProfileData event,
    Emitter<ProfileState> emit,
  ) async {
    emit(ProfileSaving());
    final result = await _profileRepository.updateProfile(event.request);
    result.fold(
      (error) => emit(ProfileActionError(error.message)),
      (profile) => emit(ProfileUpdated(profile, event.successMessage)),
    );
  }

  Future<void> _onUploadAvatar(
    UploadProfileAvatar event,
    Emitter<ProfileState> emit,
  ) async {
    emit(ProfileSaving());
    final result = await _profileRepository.uploadAvatar(event.filePath);
    result.fold(
      (error) => emit(ProfileActionError(error.message)),
      (_) => add(const LoadProfile()),
    );
  }

  Future<void> _onChangePassword(
    ChangeSecurityPassword event,
    Emitter<ProfileState> emit,
  ) async {
    emit(ProfileSaving());
    final result = await _settingsRepository.changePassword(event.request);
    result.fold(
      (error) => emit(ProfileActionError(error.message)),
      (_) => emit(ProfileActionSuccess('Parol muvaffaqiyatli yangilandi')),
    );
  }

  Future<void> _onLoadSessions(
    LoadActiveSessions event,
    Emitter<ProfileState> emit,
  ) async {
    emit(SessionsLoading());
    final result = await _settingsRepository.getSessions();
    result.fold(
      (error) => emit(ProfileActionError(error.message)),
      (sessions) => emit(SessionsLoaded(sessions)),
    );
  }

  Future<void> _onTerminateOtherSessions(
    TerminateOtherSessions event,
    Emitter<ProfileState> emit,
  ) async {
    emit(ProfileSaving());
    final result = await _settingsRepository.logoutOtherDevices();
    result.fold(
      (error) => emit(ProfileActionError(error.message)),
      (_) => emit(
        ProfileActionSuccess('Boshqa qurilmalardagi sessiyalar yakunlandi'),
      ),
    );
  }
}
