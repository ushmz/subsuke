import 'package:flutter/foundation.dart';

class Subscription {
  final int id;
  final String name;
  final String billingAt;
  final int price;
  final String cycle;

  const Subscription({
    @required this.id,
    @required this.name,
    @required this.billingAt,
    @required this.price,
    @required this.cycle,
  })  : assert(id != null),
        assert(name != null),
        assert(billingAt != null),
        assert(price != null),
        assert(cycle != null);

  int get getId => id;

  Map<String, dynamic> toMap() => {
        "id": id,
        "name": name,
        "billingAt": billingAt,
        "price": price,
        "cycle": cycle
      };

  factory Subscription.fromMap(Map<String, dynamic> json) => Subscription(
        id: json['id'],
        name: json['name'],
        billingAt: json['billingAt'],
        price: json['price'],
        cycle: json['cycle'],
      );
}

class Subscriptions {
  final List<Subscription> subscriptions;
  const Subscriptions({@required this.subscriptions})
      : assert(subscriptions != null);

  List<Subscription> get getSubscriptions => subscriptions;

  int dailyPrice() {
    return 0;
  }

  int weeklyPrice() {
    return 0;
  }

  int monthlyPrice() {
    return 0;
  }

  int yearlyPrice() {
    return 0;
  }
}
