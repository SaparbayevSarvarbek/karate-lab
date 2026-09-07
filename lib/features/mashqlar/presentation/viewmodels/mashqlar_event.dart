part of 'mashqlar_bloc.dart';

abstract class MashqlarEvent extends Equatable {
  const MashqlarEvent();

  @override
  List<Object?> get props => [];
}

class LoadMashqlar extends MashqlarEvent {
  const LoadMashqlar();
}
