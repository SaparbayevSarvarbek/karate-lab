part of 'test_bloc.dart';

abstract class TestState extends Equatable {
  const TestState();

  @override
  List<Object?> get props => [];
}

class TestInitial extends TestState {}

class TestLoading extends TestState {}

class TestActionLoading extends TestState {}

class AllTestsLoaded extends TestState {
  final List<TestEntity> tests;

  const AllTestsLoaded(this.tests);

  @override
  List<Object?> get props => [tests];
}

class MyTestsLoaded extends TestState {
  final List<TestResult> tests;

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

class TestFinished extends TestState {
  final TestResult result;

  const TestFinished(this.result);

  @override
  List<Object?> get props => [result];
}

class TestError extends TestState {
  final String message;

  const TestError(this.message);

  @override
  List<Object?> get props => [message];
}
