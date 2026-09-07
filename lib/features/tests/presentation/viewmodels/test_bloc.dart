import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/repositories/test_repository.dart';
import '../../../../core/api/models/test_models.dart';

part 'test_event.dart';
part 'test_state.dart';

class TestBloc extends Bloc<TestEvent, TestState> {
  final TestRepository _repository;

  TestBloc(this._repository) : super(TestInitial()) {
    on<LoadMyTests>(_onLoadMyTests);
    on<StartMyTest>(_onStartMyTest);
    on<FinishMyTest>(_onFinishMyTest);
    on<LoadCoachTests>(_onLoadCoachTests);
    on<CreateCoachTest>(_onCreateCoachTest);
    on<AssignCoachTest>(_onAssignCoachTest);
  }

  Future<void> _onLoadMyTests(
    LoadMyTests event,
    Emitter<TestState> emit,
  ) async {
    emit(TestLoading());
    final result = await _repository.getMyTests();
    result.fold(
      (error) => emit(TestError(error.message)),
      (tests) => emit(MyTestsLoaded(tests)),
    );
  }

  Future<void> _onStartMyTest(
    StartMyTest event,
    Emitter<TestState> emit,
  ) async {
    emit(TestActionLoading());
    final result = await _repository.startTest(event.id);
    result.fold(
      (error) => emit(TestError(error.message)),
      (_) => add(const LoadMyTests()),
    );
  }

  Future<void> _onFinishMyTest(
    FinishMyTest event,
    Emitter<TestState> emit,
  ) async {
    emit(TestActionLoading());
    final result = await _repository.finishTest(event.id, event.request);
    result.fold(
      (error) => emit(TestError(error.message)),
      (_) => add(const LoadMyTests()),
    );
  }

  Future<void> _onLoadCoachTests(
    LoadCoachTests event,
    Emitter<TestState> emit,
  ) async {
    emit(TestLoading());
    final result = await _repository.getCoachTests();
    result.fold(
      (error) => emit(TestError(error.message)),
      (tests) => emit(CoachTestsLoaded(tests)),
    );
  }

  Future<void> _onCreateCoachTest(
    CreateCoachTest event,
    Emitter<TestState> emit,
  ) async {
    emit(TestActionLoading());
    final result = await _repository.createTest(event.request);
    result.fold(
      (error) => emit(TestError(error.message)),
      (test) {
        if (event.athleteIds.isNotEmpty) {
          _assignAfterCreate(test.id, event.athleteIds, emit);
        } else {
          emit(TestCreated(test));
          add(const LoadCoachTests());
        }
      },
    );
  }

  Future<void> _assignAfterCreate(
    int testId,
    List<int> athleteIds,
    Emitter<TestState> emit,
  ) async {
    final result = await _repository.assignTest(
      testId,
      AssignTestRequest(athleteIds: athleteIds),
    );
    result.fold(
      (error) => emit(TestError(error.message)),
      (_) {
        emit(TestCreated(null));
        add(const LoadCoachTests());
      },
    );
  }

  Future<void> _onAssignCoachTest(
    AssignCoachTest event,
    Emitter<TestState> emit,
  ) async {
    emit(TestActionLoading());
    final result = await _repository.assignTest(event.testId, event.request);
    result.fold(
      (error) => emit(TestError(error.message)),
      (_) => emit(TestAssigned()),
    );
  }
}
