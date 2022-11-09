import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:subsuke/ui/pages/config/config.ios.dart';

void main() {
  testWidgets("check time test", (WidgetTester tester) async {
    await [
      tester.pumpWidget(MaterialApp(
          home: PaymentReminderSchedulePickerRow(
        pickedValue: TimeOfDay(hour: 12, minute: 0),
        onChange: ((val) {
          print(val);
        }),
      )

          // home: ReminderTestButtonRow(send: notification),
          ))
    ];
    // await tester.tap(find.text("リマインダーの時刻"));
    // await tester.pump();
    expect(find.text("リマインダーの時刻"), findsOneWidget);
  });
}
