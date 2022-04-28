class SubscriptionItem {
  final int id;
  final String name;
  final int price;
  final DateTime next;
  final PaymentInterval interval;
  final String? note;
  final String? paymentMethod;

  const SubscriptionItem(
    this.id,
    this.name,
    this.price,
    this.next,
    this.interval, {
    this.note,
    this.paymentMethod,
  });

  int get getID => id;

  // [TODO] Ulid is String value
  // See : https://pub.dev/packages/ulid
  /* static assignUUID() { */
  /*     id = Ulid(); */
  /* } */

  Map<String, dynamic> toMap() => {
        "id": id,
        "name": name,
        "price": price,
        "next": next.toUtc().toIso8601String(),
        "interval": interval.intervalID,
        /* "note": note */
      };

  Map<String, dynamic> toInsertMap() => {
        "name": name,
        "price": price,
        "next": next.toUtc().toIso8601String(),
        "interval": interval.intervalID,
        /* "note": note, */
      };

  factory SubscriptionItem.fromMap(Map<String, dynamic> json) =>
      SubscriptionItem(
        json['id'],
        json['name'],
        json['price'],
        DateTime.parse(json['next']).toLocal(),
        getPaymentInterval(json['interval']),
        /* json['note'], */
      );

  SubscriptionItem updateNextPayment() {
    switch (interval) {
      case PaymentInterval.Daily:
        return SubscriptionItem(
          id,
          name,
          price,
          DateTime(next.year, next.month, next.day + 1),
          interval,
          /* note, */
        );
      case PaymentInterval.Weekly:
        return SubscriptionItem(
          id,
          name,
          price,
          DateTime(next.year, next.month, next.day + 7),
          interval,
          /* note, */
        );
      case PaymentInterval.Fortnightly:
        return SubscriptionItem(
          id,
          name,
          price,
          DateTime(next.year, next.month, next.day + 14),
          interval,
          /* note, */
        );
      case PaymentInterval.Monthly:
        return SubscriptionItem(
          id,
          name,
          price,
          DateTime(next.year, next.month + 1, next.day),
          interval,
          /* note, */
        );
      case PaymentInterval.Yearly:
        return SubscriptionItem(
          id,
          name,
          price,
          DateTime(next.year + 1, next.month, next.day),
          interval,
          /* note, */
        );
    }
  }
}

enum PaymentInterval {
  Daily,
  Weekly,
  Fortnightly,
  Monthly,
  Yearly,
}

extension PaymentIntervalExt on PaymentInterval {
  int get intervalID {
    switch (this) {
      case PaymentInterval.Daily:
        return 1;
      case PaymentInterval.Weekly:
        return 2;
      case PaymentInterval.Fortnightly:
        return 3;
      case PaymentInterval.Monthly:
        return 4;
      case PaymentInterval.Yearly:
        return 5;
    }
  }
}

PaymentInterval getPaymentInterval(int id) {
  switch (id) {
    case 1:
      return PaymentInterval.Daily;
    case 2:
      return PaymentInterval.Weekly;
    case 3:
      return PaymentInterval.Fortnightly;
    case 4:
      return PaymentInterval.Monthly;
    case 5:
      return PaymentInterval.Yearly;
    default:
      return PaymentInterval.Monthly;
  }
}
