import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:subsuke/models/settings.dart';

class SettingsBloc {
  final _settingsController = BehaviorSubject<SettingStates>();

  Function(SettingStates) get setSettings => _settingsController.sink.add;
  Stream<SettingStates> get onSettingsChanged => _settingsController.stream;

  SettingsBloc() {
    // Get from "PreferedStatement" or somewhere.
    final settings = SettingStates(true, TimeOfDay.now());
    setSettings(settings);
  }

  bool getNotificationEnabled() {
    final enabled = _settingsController.value.isNotificationEnabled;
    return enabled;
  }

  void setNotificationEnabled(SettingStates current, bool val) {
    // Write value to "PreferedStatement" or somewhere.
    final settings = SettingStates(val, current.notificationSchedule);
    setSettings(settings);
  }

  TimeOfDay getNotificationSchedule() {
    return _settingsController.value.notificationSchedule;
  }

  void setNotificationSchedule(SettingStates current, TimeOfDay schedule) {
    final settings = SettingStates(current.isNotificationEnabled, schedule);
    setSettings(settings);
  }

  void dispose() {
    _settingsController.close();
  }
}
