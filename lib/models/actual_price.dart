import 'package:subsuke/models/payment_interval.dart';
import 'package:subsuke/models/subscription_item.dart';

class ActualPrice {
  final daily;
  final weekly;
  final monthly;
  final yearly;

  ActualPrice._internal({
    required this.daily,
    required this.weekly,
    required this.monthly,
    required this.yearly,
  });

  static int _daily(List<SubscriptionItem> items, {int? y, int? m, int? d}) {
    final n = DateTime.now();
    final day = new DateTime(y ?? n.year, m ?? n.month, d ?? n.day);

    int actual = 0;
    items.forEach((item) {
      if (item.next.isAtSameMomentAs(day)) {
        actual += item.price;
      }
    });

    return actual;
  }

  // TODO Not implemented
  static int _weekly(List<SubscriptionItem> items, {int? y, int? m, int? d}) {
    final n = DateTime.now();
    final day = new DateTime(y ?? n.year, m ?? n.month, d ?? n.day);

    int actual = 0;
    items.forEach((item) {
      if (item.next.isAtSameMomentAs(day)) {
        actual += item.price;
      }
    });

    return actual;
  }

  static int _monthly(List<SubscriptionItem> items, {int? y, int? m}) {
    final n = DateTime.now();
    final days = new DateTime((y ?? n.year), (m ?? n.month) + 1, 0).day;

    int actual = 0;
    items.forEach((v) {
      switch (v.interval) {
        case PaymentInterval.Daily:
          actual += v.price * days;
          break;
        case PaymentInterval.Weekly:
          actual += v.price * (days ~/ 7);
          break;
        case PaymentInterval.Fortnightly:
          actual += v.price * (days ~/ 14);
          break;
        case PaymentInterval.Monthly:
          actual += v.price;
          break;
        case PaymentInterval.Yearly:
          if (v.next.month == n.month) {
            actual += v.price;
          }
          break;
      }
    });
    return actual;
  }

  static int _yearly(List<SubscriptionItem> items, {int? y}) {
    final n = DateTime.now();
    final year = y ?? n.year;

    int days;
    if (year % 4 == 0 && year % 100 != 0 || year % 400 == 0) {
      days = 366;
    } else {
      days = 365;
    }

    int actual = 0;
    items.forEach((v) {
      switch (v.interval) {
        case PaymentInterval.Daily:
          actual += v.price * days;
          break;
        case PaymentInterval.Weekly:
          actual += v.price * (days ~/ 7);
          break;
        case PaymentInterval.Fortnightly:
          actual += v.price * (days ~/ 14);
          break;
        case PaymentInterval.Monthly:
          actual += v.price * 12;
          break;
        case PaymentInterval.Yearly:
          actual += v.price;
      }
    });
    return actual;
  }

  factory ActualPrice.fromItems(List<SubscriptionItem> items) {
    return ActualPrice._internal(
      daily: _daily(items),
      weekly: _weekly(items),
      monthly: _monthly(items),
      yearly: _yearly(items),
    );
  }
}
