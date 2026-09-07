import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/repositories/dashboard_repository.dart';
import '../../../../core/api/models/dashboard_models.dart';

part 'dashboard_event.dart';
part 'dashboard_state.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  final DashboardRepository _repository;

  DashboardBloc(this._repository) : super(DashboardInitial()) {
    on<LoadCoachDashboard>(_onLoadCoachDashboard);
    on<LoadAthleteDashboard>(_onLoadAthleteDashboard);
  }

  Future<void> _onLoadCoachDashboard(
    LoadCoachDashboard event,
    Emitter<DashboardState> emit,
  ) async {
    emit(DashboardLoading());
    final result = await _repository.getDashboard();
    result.fold(
      (error) => emit(DashboardError(error.message)),
      (data) => emit(CoachDashboardLoaded(data)),
    );
  }

  Future<void> _onLoadAthleteDashboard(
    LoadAthleteDashboard event,
    Emitter<DashboardState> emit,
  ) async {
    emit(DashboardLoading());
    final result = await _repository.getMyStatistics();
    result.fold(
      (error) => emit(DashboardError(error.message)),
      (data) => emit(AthleteDashboardLoaded(data)),
    );
  }
}
