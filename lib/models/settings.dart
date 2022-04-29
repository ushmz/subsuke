import 'package:flutter/material.dart';

class Preferences {
  final bool isNotificationEnabled;
  final TimeOfDay notificationSchedule;

  Preferences(this.isNotificationEnabled, this.notificationSchedule);
}
