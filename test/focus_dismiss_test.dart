import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:krate_lab/core/theme/app_theme.dart';
import 'package:krate_lab/core/widgets/custom_text_field.dart';

void main() {
  testWidgets('tapping outside a text field dismisses its focus', (
    tester,
  ) async {
    final controller = TextEditingController();
    addTearDown(controller.dispose);

    await tester.pumpWidget(
      ScreenUtilInit(
        designSize: const Size(390, 844),
        builder: (context, child) => MaterialApp(
          theme: AppTheme.lightTheme,
          home: GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
            child: Scaffold(
              body: Column(
                children: [
                  CustomTextField(
                    controller: controller,
                    hintText: 'Matn kiriting',
                  ),
                  const Expanded(child: ColoredBox(color: Colors.white)),
                ],
              ),
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.byType(TextFormField));
    await tester.pump();
    final focusNode = tester
        .widget<EditableText>(find.byType(EditableText))
        .focusNode;
    expect(focusNode.hasFocus, isTrue);

    await tester.tapAt(const Offset(300, 500));
    await tester.pump();
    expect(focusNode.hasFocus, isFalse);
  });
}
