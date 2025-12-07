import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:my_app/main.dart';

void main() {
  testWidgets('App launches and shows home screen', (
    WidgetTester tester,
  ) async {
    // Build our app
    await tester.pumpWidget(const MainApp());

    // Verify that app title is present
    expect(find.text('Мои задачи'), findsOneWidget);

    // Verify that advice widget is present
    expect(find.text('Совет дня'), findsOneWidget);
  });
}
