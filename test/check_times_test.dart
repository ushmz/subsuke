import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:subsuke/ui/pages/config/config.ios.dart';

void main() {
  testWidgets("check time test", (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
      home: PaymentReminderSchedulePickerRow(
        pickedValue: TimeOfDay(hour: 12, minute: 11),
        onChange: ((val) {}),
      ),
    ));
    expect(find.text("12:11"), findsOneWidget);
  });
}
