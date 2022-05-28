class SubscriptionItem {
  final int id;
  final String name;
  final int price;
  final DateTime next;
  final PaymentInterval interval;
  final String paymentMethod;
  final String note;

  const SubscriptionItem(
    this.id,
    this.name,
    this.price,
    this.next,
    this.interval,
    this.note,
    this.paymentMethod,
  );

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
        "payment_method": paymentMethod,
        "note": note
      };

  Map<String, dynamic> toInsertMap() => {
        "name": name,
        "price": price,
        "next": next.toUtc().toIso8601String(),
        "interval": interval.intervalID,
        "payment_method": paymentMethod,
        "note": note,
      };

  factory SubscriptionItem.fromMap(Map<String, dynamic> json) =>
      SubscriptionItem(
        json['id'],
        json['name'],
        json['price'],
        DateTime.parse(json['next']).toLocal(),
        getPaymentInterval(json['interval']),
        json['payment_method'],
        json['note'],
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
          paymentMethod,
          note,
        );
      case PaymentInterval.Weekly:
        return SubscriptionItem(
          id,
          name,
          price,
          DateTime(next.year, next.month, next.day + 7),
          interval,
          paymentMethod,
          note,
        );
      case PaymentInterval.Fortnightly:
        return SubscriptionItem(
          id,
          name,
          price,
          DateTime(next.year, next.month, next.day + 14),
          interval,
          paymentMethod,
          note,
        );
      case PaymentInterval.Monthly:
        return SubscriptionItem(
          id,
          name,
          price,
          DateTime(next.year, next.month + 1, next.day),
          interval,
          paymentMethod,
          note,
        );
      case PaymentInterval.Yearly:
        return SubscriptionItem(
          id,
          name,
          price,
          DateTime(next.year + 1, next.month, next.day),
          interval,
          paymentMethod,
          note,
        );
    }
  }
}

enum ItemSortCondition {
  None,
  PriceASC,
  PriceDESC,
  NextASC,
  NextDESC,
}

extension ItemSortConditionIDExt on ItemSortCondition {
  int get sortConditionID {
    switch (this) {
      case ItemSortCondition.None:
        return 0;
      case ItemSortCondition.PriceASC:
        return 1;
      case ItemSortCondition.PriceDESC:
        return 2;
      case ItemSortCondition.NextASC:
        return 3;
      case ItemSortCondition.NextDESC:
        return 4;
    }
  }
}

extension ItemSortConditionNameExt on ItemSortCondition {
  String get sortConditionName {
    switch (this) {
      case ItemSortCondition.None:
        return "";
      case ItemSortCondition.PriceASC:
        return "お支払い金額が小さい順";
      case ItemSortCondition.PriceDESC:
        return "お支払い金額が大きい順";
      case ItemSortCondition.NextASC:
        return "お支払日が近い順";
      case ItemSortCondition.NextDESC:
        return "お支払日が遠い順";
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

extension PaymentIntervalIDExt on PaymentInterval {
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

extension PaymentIntervalUnitTimeTextExt on PaymentInterval {
  String get intervalText {
    switch (this) {
      case PaymentInterval.Daily:
        return "1日";
      case PaymentInterval.Weekly:
        return "1週間";
      case PaymentInterval.Fortnightly:
        return "2週間";
      case PaymentInterval.Monthly:
        return "1ヶ月";
      case PaymentInterval.Yearly:
        return "1年";
    }
  }
}
