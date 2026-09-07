part of 'dashboard_bloc.dart';

abstract class DashboardEvent extends Equatable {
  const DashboardEvent();

  @override
  List<Object?> get props => [];
}

class LoadCoachDashboard extends DashboardEvent {}

class LoadAthleteDashboard extends DashboardEvent {}
