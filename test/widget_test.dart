// KarateLab AI uchun smoke test.
// Ilova ishga tushganda SplashView'da "KarateLab AI" ko'rinishini tekshiradi.

import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:krate_lab/main.dart';

void main() {
  testWidgets('App starts and shows splash title', (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({});

    await tester.pumpWidget(const KarateLabApp());
    await tester.pump();

    expect(find.text('KarateLab AI'), findsOneWidget);

    // SplashView 2 soniyadan keyin navigatsiya qiladi; timer'ni yopish uchun
    // yetarlicha vaqt beramiz.
    await tester.pump(const Duration(seconds: 3));
  });
}
