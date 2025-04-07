import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:readwise_plus/main.dart';

void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    // แก้ตรงนี้ 👇
    await tester.pumpWidget(const ReadWiseApp());

    expect(find.text('0'), findsOneWidget);
    expect(find.text('1'), findsNothing);

    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();

    expect(find.text('0'), findsNothing);
    expect(find.text('1'), findsOneWidget);
  });
}
