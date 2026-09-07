part of 'test_bloc.dart';

abstract class TestEvent extends Equatable {
  const TestEvent();

  @override
  List<Object?> get props => [];
}

class LoadMyTests extends TestEvent {
  const LoadMyTests();
}

class StartMyTest extends TestEvent {
  final int id;

  const StartMyTest(this.id);

  @override
  List<Object?> get props => [id];
}

class FinishMyTest extends TestEvent {
  final int id;
  final FinishTestRequest request;

  const FinishMyTest({required this.id, required this.request});

  @override
  List<Object?> get props => [id, request];
}

class LoadCoachTests extends TestEvent {
  const LoadCoachTests();
}

class CreateCoachTest extends TestEvent {
  final CreateTestRequest request;
  final List<int> athleteIds;

  const CreateCoachTest({required this.request, this.athleteIds = const []});

  @override
  List<Object?> get props => [request, athleteIds];
}

class AssignCoachTest extends TestEvent {
  final int testId;
  final AssignTestRequest request;

  const AssignCoachTest({required this.testId, required this.request});

  @override
  List<Object?> get props => [testId, request];
}
