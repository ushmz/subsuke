import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:subsuke/models/settings.dart';

class SettingsBloc {
  final _preferenceController = BehaviorSubject();
  final _notificationScheduleController =
      BehaviorSubject<TimeOfDay>.seeded(TimeOfDay.now());
  final _notificationScheduleEnabled = BehaviorSubject<bool>.seeded(false);

  Stream<void> get onPreferenceUpdated => _preferenceController.stream;
  Stream<TimeOfDay> get onScheduleChanged =>
      _notificationScheduleController.stream;
  Stream<bool> get onNoticationToggled => _notificationScheduleEnabled.stream;

  SettingsBloc() {
    () async {
      final prefs = await SharedPreferences.getInstance();

      _notificationScheduleEnabled.sink
          .add(prefs.getBool("notification") ?? false);

      final timeStr = prefs.getString("schedule");
      if (timeStr != null) {
        final time = TimeOfDay(
            hour: int.parse(timeStr.split(":")[0]),
            minute: int.parse(timeStr.split(":")[1]));
        _notificationScheduleController.sink.add(time);
      } else {
        _notificationScheduleController.sink.add(TimeOfDay.now());
      }
      _preferenceController.sink.add(null);
    }();
  }

  Preferences get _getPreferences => _preferenceController.value;

  bool isNotificationEnabled() {
    return _notificationScheduleEnabled.stream.value;
  }

  Future<void> setNotificationEnabled(bool val) async {
    final prefs = await SharedPreferences.getInstance();
    final success = await prefs.setBool("notification", val);
    if (success) {
      _notificationScheduleEnabled.sink.add(val);
      _preferenceController.sink.add(null);
    } else {
      _notificationScheduleEnabled.sink.addError("Failed to save preference");
    }
  }

  TimeOfDay getNotificationSchedule() {
    return _notificationScheduleController.stream.value;
  }

  Future<void> setNotificationSchedule(TimeOfDay val) async {
    final prefs = await SharedPreferences.getInstance();
    final success =
        await prefs.setString("schedule", "${val.hour}:${val.minute}");
    if (success) {
      _notificationScheduleController.sink.add(val);
      _preferenceController.sink.add(null);
    } else {
      _notificationScheduleController.sink
          .addError("Failed to save preference");
    }
  }

  void dispose() {
    _preferenceController.close();
    _notificationScheduleEnabled.close();
    _notificationScheduleController.close();
  }
}
