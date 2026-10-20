part of 'mashqlar_bloc.dart';

abstract class MashqlarState extends Equatable {
  const MashqlarState();

  @override
  List<Object?> get props => [];
}

class MashqlarInitial extends MashqlarState {
  const MashqlarInitial();
}

class MashqlarLoading extends MashqlarState {
  const MashqlarLoading();
}

class MashqlarLoaded extends MashqlarState {
  final List<Exercise> texnik;
  final List<UjtTest> ujt;
  final List<MjtTest> mjt;
  final String? warning;

  const MashqlarLoaded({
    required this.texnik,
    required this.ujt,
    required this.mjt,
    this.warning,
  });

  List<MashqItem> get items => [
    ...texnik.map(
      (e) => MashqItem(
        kind: 'texnik',
        id: e.id,
        title: e.title,
        subtitle: e.category,
        imageUrl: e.image,
        exercise: e,
      ),
    ),
    ...ujt.map(
      (t) => MashqItem(
        kind: 'ujt',
        id: t.id,
        title: t.title,
        subtitle: t.ageGroup,
        imageUrl: t.coverUrl,
        ujtTest: t,
      ),
    ),
    ...mjt.map(
      (t) => MashqItem(
        kind: 'mjt',
        id: t.id,
        title: t.title,
        subtitle: t.ageGroup,
        imageUrl: t.coverUrl,
        mjtTest: t,
      ),
    ),
  ];

  @override
  List<Object?> get props => [texnik, ujt, mjt, warning];
}

class MashqlarError extends MashqlarState {
  final String message;

  const MashqlarError(this.message);

  @override
  List<Object?> get props => [message];
}
