import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:subsuke/models/subsc.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as timezone;

class NotificationRepository {
  static final NotificationRepository instance = NotificationRepository._();
  static final _plugin = FlutterLocalNotificationsPlugin();

  factory NotificationRepository() {
    return instance;
  }

  NotificationRepository._() {
    tz.initializeTimeZones();
    timezone.setLocalLocation(timezone.getLocation("Asia/Tokyo"));
    _plugin.initialize(InitializationSettings(
      iOS: IOSInitializationSettings(),
      // `android/app/src/main/res/drawable` , w/o extension
      android: AndroidInitializationSettings("assets/icons/subsuke.png"),
    ));
  }

  Future<void> testNotification() {
    final schedule =
        timezone.TZDateTime.now(timezone.local).add(Duration(seconds: 1));
    return _plugin.zonedSchedule(
      schedule.hashCode,
      "テスト通知です",
      "テストメッセージです",
      schedule,
      NotificationDetails(
        android: AndroidNotificationDetails("", ""),
        iOS: IOSNotificationDetails(presentBadge: true),
      ),
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.wallClockTime,
    );
  }

  Future<void> sendNotification(SubscriptionItem item) {
    return _plugin.show(
      item.id,
      "もうすぐ${item.name}のお支払日です",
      "${item.paymentMethod}で${item.price}円のお支払いです",
      NotificationDetails(
        android: AndroidNotificationDetails("", ""),
        iOS: IOSNotificationDetails(presentBadge: true),
      ),
    );
  }

  Future<void> scheduleNotification(SubscriptionItem item) async {
    if (item.remindBefore == null) {
      return;
    }

    final prefs = await SharedPreferences.getInstance();
    // TODO : Wrap shared_preferences API to return default value if value is Null
    final timestr = prefs.getString("schedule");

    DateTime scheduled = item.next.add(Duration(days: item.remindBefore! * -1));
    if (scheduled.isBefore(DateTime.now())) {
      final nxt = item.updateNextPayment();
      scheduled = nxt.next.add(Duration(days: item.remindBefore! * -1));
    }

    final schedule = timezone.TZDateTime.local(
      scheduled.year,
      scheduled.month,
      scheduled.day,
      timestr != null ? int.parse(timestr.split(":")[0]) : scheduled.hour,
      timestr != null ? int.parse(timestr.split(":")[1]) : scheduled.minute,
    );

    return _plugin.zonedSchedule(
      item.id,
      "もうすぐ ${item.name} のお支払日です",
      "${item.price}円のお支払いです。今${item.interval.getUnitName}はどれぐらい使いましたか？",
      schedule,
      NotificationDetails(
        android:
            AndroidNotificationDetails("payment_reminder", "Payment Reminder"),
        iOS: IOSNotificationDetails(presentBadge: true),
      ),
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.wallClockTime,
    );
  }

  Future<void> updateNotification(int itemID) async {
    
  }

  // Future<void> cancelNotificationSchedule(int itemID) {
  //
  // }
}
