import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutterproject/main.dart';

String displayText(WidgetTester tester) {
  return tester.widget<Text>(find.byKey(const Key('calculatorDisplay'))).data!;
}

void main() {
  testWidgets('adds two numbers using calculator buttons', (tester) async {
    await tester.pumpWidget(const MyApp());

    await tester.tap(find.byKey(const Key('button_7')));
    await tester.tap(find.byKey(const Key('button_+')));
    await tester.tap(find.byKey(const Key('button_5')));
    await tester.tap(find.byKey(const Key('button_=')));
    await tester.pump();

    expect(displayText(tester), '12');
  });

  testWidgets('supports subtraction and clear', (tester) async {
    await tester.pumpWidget(const MyApp());

    await tester.tap(find.byKey(const Key('button_9')));
    await tester.tap(find.byKey(const Key('button_−')));
    await tester.tap(find.byKey(const Key('button_3')));
    await tester.tap(find.byKey(const Key('button_=')));
    await tester.pump();

    expect(displayText(tester), '6');

    await tester.tap(find.byKey(const Key('button_C')));
    await tester.pump();

    expect(displayText(tester), '0');
  });

  testWidgets('shows an error when dividing by zero', (tester) async {
    await tester.pumpWidget(const MyApp());

    await tester.tap(find.byKey(const Key('button_8')));
    await tester.tap(find.byKey(const Key('button_÷')));
    await tester.tap(find.byKey(const Key('button_0')));
    await tester.tap(find.byKey(const Key('button_=')));
    await tester.pump();

    expect(displayText(tester), 'Error');
  });
  testWidgets('multiplies a decimal value', (tester) async {
    await tester.pumpWidget(const MyApp());

    await tester.tap(find.byKey(const Key('button_2')));
    await tester.tap(find.byKey(const Key('button_.')));
    await tester.tap(find.byKey(const Key('button_5')));
    await tester.tap(find.byKey(const Key('button_×')));
    await tester.tap(find.byKey(const Key('button_4')));
    await tester.tap(find.byKey(const Key('button_=')));
    await tester.pump();

    expect(displayText(tester), '10');
  });

  testWidgets('supports backspace and changing the sign', (tester) async {
    await tester.pumpWidget(const MyApp());

    await tester.tap(find.byKey(const Key('button_4')));
    await tester.tap(find.byKey(const Key('button_2')));
    await tester.tap(find.byKey(const Key('button_⌫')));
    await tester.tap(find.byKey(const Key('button_±')));
    await tester.pump();

    expect(displayText(tester), '-4');
  });
}
