import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/api/models/exercise_models.dart';
import '../../../../core/api/models/mjt_models.dart';
import '../../../../core/api/models/ujt_models.dart';
import '../../../../core/repositories/ujt_repository.dart';

part 'mashqlar_event.dart';
part 'mashqlar_state.dart';

/// Bitta yig'ma mashq elementi — Texnik, UJT yoki MJT turidan qat'i nazar bir xil ko'rinish.
class MashqItem extends Equatable {
  final String kind; // 'texnik' | 'ujt' | 'mjt'
  final int id;
  final String title;
  final String subtitle; // texnik: category, UJT/MJT: ageGroup
  final String? imageUrl; // texnik: image, UJT/MJT: coverUrl
  final Exercise? exercise;
  final UjtTest? ujtTest;
  final MjtTest? mjtTest;

  const MashqItem({
    required this.kind,
    required this.id,
    required this.title,
    required this.subtitle,
    this.imageUrl,
    this.exercise,
    this.ujtTest,
    this.mjtTest,
  });

  bool get isUjt {
    if (kind == 'ujt') return true;
    return kind == 'texnik' && _catIs('UJT');
  }

  bool get isMjt {
    if (kind == 'mjt') return true;
    return kind == 'texnik' && _catIs('MJT');
  }

  /// Texnik mashqning `subtitle` (category) — UJT/MJT/Texnika bo'ladi.
  bool _catIs(String name) => subtitle.toUpperCase() == name.toUpperCase();

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
    final mjtResult = await _repository.getMjtTests();

    final errors = <String>[];
    texnikResult.fold((l) => errors.add(l.message), (r) => null);
    ujtResult.fold((l) => errors.add(l.message), (r) => null);
    mjtResult.fold((l) => errors.add(l.message), (r) => null);

    final texnik = texnikResult.getOrElse(() => const <Exercise>[]);
    final ujt = ujtResult.getOrElse(() => const <UjtTest>[]);
    final mjt = mjtResult.getOrElse(() => const <MjtTest>[]);

    if (texnikResult.isLeft() && ujtResult.isLeft() && mjtResult.isLeft()) {
      emit(MashqlarError(errors.join('\n')));
      return;
    }

    emit(MashqlarLoaded(
      texnik: texnik,
      ujt: ujt,
      mjt: mjt,
      warning: errors.isEmpty ? null : errors.join('\n'),
    ));
  }
}
