import 'package:flutter_test/flutter_test.dart';
import 'package:krate_lab/core/l10n/app_translations.dart';
import 'package:krate_lab/features/mashqlar/presentation/viewmodels/mashqlar_bloc.dart';

MashqItem _item({required String kind, required String subtitle}) =>
    MashqItem(kind: kind, id: 1, title: 'Exercise', subtitle: subtitle);

void main() {
  setUpAll(() async {
    await Tr.ensureLoaded();
  });

  test('technical filter only matches technical-category exercises', () {
    expect(
      _item(kind: 'texnik', subtitle: 'Technical').matchesCategory('Texnik'),
      isTrue,
    );
    expect(
      _item(kind: 'texnik', subtitle: 'MJT').matchesCategory('Texnik'),
      isFalse,
    );
    expect(
      _item(kind: 'texnik', subtitle: 'UJT').matchesCategory('Texnik'),
      isFalse,
    );
  });

  test('UJT and MJT filters match package tests and exercise categories', () {
    expect(
      _item(kind: 'ujt', subtitle: '12-14').matchesCategory('UJT'),
      isTrue,
    );
    expect(
      _item(kind: 'mjt', subtitle: '12-14').matchesCategory('MJT'),
      isTrue,
    );
    expect(
      _item(kind: 'texnik', subtitle: 'MJT').matchesCategory('MJT'),
      isTrue,
    );
    expect(
      _item(kind: 'ujt', subtitle: '12-14').matchesCategory('Texnik'),
      isFalse,
    );
  });
}
