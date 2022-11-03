import 'package:subsuke/models/payment_interval.dart';
import 'package:subsuke/models/subscription_item.dart';

class ProratedPrice {
  final int daily;
  final int weekly;
  final int monthly;
  final int yearly;

  ProratedPrice._internal({
    required this.daily,
    required this.weekly,
    required this.monthly,
    required this.yearly,
  });

  factory ProratedPrice.fromJson(Map<PaymentInterval, int> json) {
    return ProratedPrice._internal(
      daily: json[PaymentInterval.Daily] ?? 0,
      weekly: json[PaymentInterval.Weekly] ?? 0,
      monthly: json[PaymentInterval.Monthly] ?? 0,
      yearly: json[PaymentInterval.Yearly] ?? 0,
    );
  }

  factory ProratedPrice.fromItems(List<SubscriptionItem> items) {
    int daily = 0;
    int weekly = 0;
    int monthly = 0;
    int yearly = 0;

    items.forEach(
      (data) {
        switch (data.interval) {
          case PaymentInterval.Daily:
            final y = data.price * 365;
            daily += data.price;
            weekly += data.price * 7;
            monthly += y ~/ 12;
            yearly += y;
            break;
          case PaymentInterval.Weekly:
            final y = data.price ~/ 7 * 365;
            daily += data.price ~/ 7;
            weekly += data.price;
            monthly += y ~/ 12;
            yearly += y;
            break;
          case PaymentInterval.Fortnightly:
            final y = data.price ~/ 14 * 365;
            daily += data.price ~/ 14;
            weekly += data.price ~/ 2;
            monthly += y ~/ 12;
            yearly += y;
            break;
          case PaymentInterval.Monthly:
            final d = data.price * 12 ~/ 365;
            daily += d;
            weekly += d * 7;
            monthly += data.price;
            yearly += data.price * 12;
            break;
          case PaymentInterval.Yearly:
            final d = data.price ~/ 365;
            daily += d;
            weekly += d * 7;
            monthly += data.price ~/ 12;
            yearly += data.price;
            break;
        }
      },
    );

    return ProratedPrice._internal(
      daily: daily,
      weekly: weekly,
      monthly: monthly,
      yearly: yearly,
    );
  }
}
