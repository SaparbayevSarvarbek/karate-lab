import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/api/models/test_models.dart';
import '../../../../core/repositories/test_repository.dart';

part 'test_event.dart';
part 'test_state.dart';

class TestBloc extends Bloc<TestEvent, TestState> {
  final TestRepository _repository;

  TestBloc(this._repository) : super(TestInitial()) {
    on<LoadAllTests>(_onLoadAllTests);
    on<LoadMyTests>(_onLoadMyTests);
    on<StartMyTest>(_onStartMyTest);
    on<FinishMyTest>(_onFinishMyTest);
    on<FinishMyTestWithResult>(_onFinishMyTestWithResult);
    on<LoadCoachTests>(_onLoadCoachTests);
    on<CreateCoachTest>(_onCreateCoachTest);
  }

  Future<void> _onLoadAllTests(
    LoadAllTests event,
    Emitter<TestState> emit,
  ) async {
    emit(TestLoading());
    final result = await _repository.getAllTests();
    result.fold(
      (error) => emit(TestError(error.message)),
      (tests) => emit(AllTestsLoaded(tests)),
    );
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

  Future<void> _onFinishMyTestWithResult(
    FinishMyTestWithResult event,
    Emitter<TestState> emit,
  ) async {
    emit(TestActionLoading());
    final result = await _repository.finishTest(event.id, event.request);
    result.fold(
      (error) => emit(TestError(error.message)),
      (result) => emit(TestFinished(result)),
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
    final result = await _repository.createTest(
      event.request,
      cover: event.cover as File?,
      steps: event.steps,
      stepImages: event.stepImages.cast<File?>(),
    );
    result.fold((error) => emit(TestError(error.message)), (test) {
      emit(TestCreated(test));
      add(const LoadCoachTests());
    });
  }
}
