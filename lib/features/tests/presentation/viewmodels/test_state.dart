part of 'test_bloc.dart';

abstract class TestState extends Equatable {
  const TestState();

  @override
  List<Object?> get props => [];
}

class TestInitial extends TestState {}

class TestLoading extends TestState {}

class TestActionLoading extends TestState {}

class MyTestsLoaded extends TestState {
  final List<TestAssignment> tests;

  const MyTestsLoaded(this.tests);

  @override
  List<Object?> get props => [tests];
}

class CoachTestsLoaded extends TestState {
  final List<TestEntity> tests;

  const CoachTestsLoaded(this.tests);

  @override
  List<Object?> get props => [tests];
}

class TestCreated extends TestState {
  final TestEntity? test;

  const TestCreated(this.test);

  @override
  List<Object?> get props => [test];
}

class TestAssigned extends TestState {}

class TestError extends TestState {
  final String message;

  const TestError(this.message);

  @override
  List<Object?> get props => [message];
}
