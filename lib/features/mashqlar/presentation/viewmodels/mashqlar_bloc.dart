import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/api/models/exercise_models.dart';
import '../../../../core/api/models/ujt_models.dart';
import '../../../../core/repositories/ujt_repository.dart';

part 'mashqlar_event.dart';
part 'mashqlar_state.dart';

/// Bitta yig'ma mashq elementi — Texnik yoki UJT turidan qat'i nazar bir xil ko'rinish.
class MashqItem extends Equatable {
  final String kind; // 'texnik' | 'ujt'
  final int id;
  final String title;
  final String subtitle; // texnik: category, UJT: ageGroup
  final String? imageUrl; // texnik: image, UJT: coverUrl
  final Exercise? exercise;
  final UjtTest? ujtTest;

  const MashqItem({
    required this.kind,
    required this.id,
    required this.title,
    required this.subtitle,
    this.imageUrl,
    this.exercise,
    this.ujtTest,
  });

  bool get isUjt => kind == 'ujt';

  @override
  List<Object?> get props => [kind, id, title];
}

class MashqlarBloc extends Bloc<MashqlarEvent, MashqlarState> {
  final UjtRepository _repository;

  MashqlarBloc(this._repository) : super(const MashqlarInitial()) {
    on<LoadMashqlar>(_onLoad);
  }

  Future<void> _onLoad(LoadMashqlar event, Emitter<MashqlarState> emit) async {
    emit(const MashqlarLoading());

    final texnikResult = await _repository.getTexnikExercises();
    final ujtResult = await _repository.getUjtTests();

    final errors = <String>[];
    texnikResult.fold((l) => errors.add(l.message), (r) => null);
    ujtResult.fold((l) => errors.add(l.message), (r) => null);

    final texnik = texnikResult.getOrElse(() => const <Exercise>[]);
    final ujt = ujtResult.getOrElse(() => const <UjtTest>[]);

    if (texnikResult.isLeft() && ujtResult.isLeft()) {
      emit(MashqlarError(errors.join('\n')));
      return;
    }

    emit(MashqlarLoaded(
      texnik: texnik,
      ujt: ujt,
      warning: errors.isEmpty ? null : errors.join('\n'),
    ));
  }
}
