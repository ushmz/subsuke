import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsBLoC {
  final _preferenceController = BehaviorSubject();
  final _notificationScheduleController =
      BehaviorSubject<TimeOfDay>.seeded(TimeOfDay.now());
  final _notificationScheduleEnabled = BehaviorSubject<bool>.seeded(false);
  final _defaultPaymentMethod = BehaviorSubject<int>.seeded(0);
  final _defaultCarouselIndex = BehaviorSubject<int>.seeded(0);

  Stream<void> get onPreferenceUpdated => _preferenceController.stream;
  Stream<TimeOfDay> get onScheduleChanged =>
      _notificationScheduleController.stream;
  Stream<bool> get onNoticationToggled => _notificationScheduleEnabled.stream;
  Stream<int> get onPaymentMethodChanged => _defaultPaymentMethod.stream;
  Stream<int> get onCarouselIndexChanged => _defaultCarouselIndex.stream;

  SettingsBLoC() {
    () async {
      final prefs = await SharedPreferences.getInstance();

      _notificationScheduleEnabled.sink
          .add(prefs.getBool('notification') ?? false);

      final timeStr = prefs.getString('schedule');
      if (timeStr != null) {
        final hm = timeStr.split(':');
        final t = TimeOfDay(hour: int.parse(hm[0]), minute: int.parse(hm[1]));
        _notificationScheduleController.sink.add(t);
      } else {
        _notificationScheduleController.sink.add(TimeOfDay.now());
      }

      _defaultPaymentMethod.sink.add(prefs.getInt('payment') ?? 0);
      _defaultCarouselIndex.sink.add(prefs.getInt('carousel') ?? 0);
      _preferenceController.sink.add(null);
    }();
  }

  // Preferences get _getPreferences => _preferenceController.value;

  bool isNotificationEnabled() {
    return _notificationScheduleEnabled.stream.value;
  }

  Future<void> setNotificationEnabled(bool val) async {
    final prefs = await SharedPreferences.getInstance();
    final success = await prefs.setBool('notification', val);
    if (success) {
      _notificationScheduleEnabled.sink.add(val);
      _preferenceController.sink.add(null);
    } else {
      _notificationScheduleEnabled.sink.addError('Failed to save preference');
    }
  }

  TimeOfDay getNotificationSchedule() {
    return _notificationScheduleController.stream.value;
  }

  Future<void> setNotificationSchedule(TimeOfDay val) async {
    final prefs = await SharedPreferences.getInstance();
    final ok = await prefs.setString('schedule', '${val.hour}:${val.minute}');

    if (ok) {
      _notificationScheduleController.sink.add(val);
      _preferenceController.sink.add(null);
    } else {
      _notificationScheduleController.sink
          .addError('Failed to save preference');
    }
  }

  Future<void> setDefaultPaymentMethod(int id) async {
    final prefs = await SharedPreferences.getInstance();
    final ok = await prefs.setInt('payment', id);
    if (ok) {
      _defaultPaymentMethod.sink.add(id);
      _preferenceController.sink.add(null);
    } else {
      _defaultPaymentMethod.sink.addError('Failed to save preference');
    }
  }

  int getDefaultPaymentMethod() {
    return _defaultPaymentMethod.value;
  }

  Future<void> setDefaultCarousel(int idx) async {
    final prefs = await SharedPreferences.getInstance();
    final ok = await prefs.setInt('carousel', idx);
    if (ok) {
      _defaultCarouselIndex.sink.add(idx);
      _preferenceController.sink.add(null);
    } else {
      _defaultCarouselIndex.sink.addError('Failed to save preference');
    }
  }

  int getDefaultCarousel() {
    return _defaultCarouselIndex.value;
  }

  void dispose() {
    _preferenceController.close();
    _notificationScheduleEnabled.close();
    _notificationScheduleController.close();
    _defaultPaymentMethod.close();
    _defaultCarouselIndex.close();
  }
}
