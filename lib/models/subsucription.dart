import 'package:flutter/foundation.dart';
import 'package:subsuke/models/cycles.dart';

// enum Cycle { Daily, Weekly, Monthly, Yearly }

class Subscription {
  @required
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
  });
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
  List<Subscription> subscriptions;
  double _daily = 0;
  double _weekly = 0;
  double _monthly = 0;
  double _yearly = 9;
  Subscriptions(List<Subscription> subscriptions) {
    this.subscriptions = subscriptions;
    for (Subscription s in subscriptions) {
      switch (s.cycle) {
        case PaymentCycle.ONCE_DAY:
          this._daily += s.price;
          this._weekly += s.price * 7;
          this._monthly += s.price * 31;
          this._yearly += s.price * 365;
          break;
        case PaymentCycle.ONCE_WEEK:
          this._daily += s.price / 7;
          this._weekly += s.price;
          this._monthly += s.price * 4;
          this._yearly += s.price * 4 * 12;
          break;
        case PaymentCycle.ONCE_MONTH:
          this._daily += s.price / 31;
          this._weekly += s.price / 4;
          this._monthly += s.price;
          this._yearly += s.price * 12;
          break;
        case PaymentCycle.ONCE_YEAR:
          this._daily += s.price / 365;
          this._weekly += s.price / 12 / 4;
          this._monthly += s.price / 12;
          this._yearly += s.price;
          break;
      }
    }
  }

  List<Subscription> get getSubscriptions => subscriptions;

  int getDailyPrice() {
    return this._daily.round();
  }

  int getWeeklyPrice() {
    return this._weekly.round();
  }

  int getMonthlyPrice() {
    return this._monthly.round();
  }

  int getYearlyPrice() {
    return this._yearly.round();
  }
}
