import 'package:flutter_test/flutter_test.dart';
import 'package:krate_lab/core/l10n/app_translations.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setUpAll(Tr.ensureLoaded);

  tearDown(() async {
    await LocaleController.instance.setLanguage('uz');
  });

  test('category labels follow the selected language', () async {
    await LocaleController.instance.setLanguage('uz');
    expect(Tr.categoryName('Texnika'), 'Texnik');
    expect(Tr.categoryName('UJT'), 'UJT');

    await LocaleController.instance.setLanguage('en');
    expect(Tr.categoryName('Texnika'), 'Technical');
    expect(Tr.categoryName('MJT'), 'MJT');
  });

  test('custom category names remain unchanged', () async {
    await LocaleController.instance.setLanguage('en');
    expect(Tr.categoryName('Karate basics'), 'Karate basics');
  });
}
