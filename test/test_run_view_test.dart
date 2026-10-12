// Test bajarish sahifasi (`TestRunView`) uchun widget testlar.
//
// Bu sahifa eng ko'p holatga ega qism: taymer, qadam navigatsiyasi va
// yakunlash ogohlantirishi. Testlar shu xatti-harakatni qulflab qo'yadi.

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:krate_lab/core/api/models/test_models.dart';
import 'package:krate_lab/core/l10n/app_translations.dart';
import 'package:krate_lab/core/theme/app_theme.dart';
import 'package:krate_lab/features/tests/presentation/views/test_run_view.dart';

TestResult _result({int steps = 3}) => TestResult(
      id: 1,
      testId: 1,
      name: 'Asosiy texnika testi',
      status: TestStatus.inProgress,
      steps: [
        for (var i = 0; i < steps; i++)
          TestStep(id: i + 1, title: 'Qadam ${i + 1}', duration: 30),
      ],
    );

Future<void> _pump(WidgetTester tester, TestResult result) async {
  tester.view.physicalSize = const Size(1080, 2400);
  tester.view.devicePixelRatio = 3.0;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);

  await tester.pumpWidget(
    ScreenUtilInit(
      designSize: const Size(390, 844),
      builder: (context, child) => MaterialApp(
        theme: AppTheme.lightTheme,
        home: TestRunView(result: result),
      ),
    ),
  );
  await tester.pump();
}

void main() {
  setUpAll(() async {
    await Tr.ensureLoaded();
  });

  testWidgets('test nomi va joriy qadam ko\'rinadi', (tester) async {
    await _pump(tester, _result());

    expect(find.text('Asosiy texnika testi'), findsOneWidget);
    expect(find.text('Qadam 1'), findsOneWidget);
    expect(find.text('Qadam 2'), findsNothing);
  });

  testWidgets('"Keyingi" bosilganda keyingi qadamga o\'tadi', (tester) async {
    await _pump(tester, _result());

    await tester.tap(find.text(Tr.t('testRunNext')));
    await tester.pumpAndSettle();

    expect(find.text('Qadam 2'), findsOneWidget);
    expect(find.text('Qadam 1'), findsNothing);
  });

  testWidgets('oxirgi qadamda tugma "Yakunlash" bo\'ladi', (tester) async {
    await _pump(tester, _result(steps: 2));

    expect(find.text(Tr.t('testRunNext')), findsOneWidget);

    await tester.tap(find.text(Tr.t('testRunNext')));
    await tester.pumpAndSettle();

    expect(find.text(Tr.t('testRunFinish')), findsOneWidget);
    expect(find.text(Tr.t('testRunNext')), findsNothing);
  });

  testWidgets('vaqt qayd etilmasa yakunlashda ogohlantiradi', (tester) async {
    await _pump(tester, _result(steps: 2));

    await tester.tap(find.text(Tr.t('testRunNext')));
    await tester.pumpAndSettle();
    await tester.tap(find.text(Tr.t('testRunFinish')));
    await tester.pumpAndSettle();

    // Taymer umuman ishlamagan → 0 ball bo'lishi haqida ogohlantirish.
    expect(find.text(Tr.t('testRunNoTimesTitle')), findsOneWidget);
  });
}
