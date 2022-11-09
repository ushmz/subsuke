import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:subsuke/ui/components/ui_parts/app_bar.dart';
import 'package:subsuke/ui/pages/config/config.ios.dart';

import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as timezone;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

void main() {
  testWidgets('app bar confirm test', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
      home: MainAppBar(),
    ));
    expect(find.text("Subsuke"), findsOneWidget);
  });
}
