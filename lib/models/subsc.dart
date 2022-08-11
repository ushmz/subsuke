import 'package:subsuke/db/consts.dart';

class PaymentMethod {
  final int id;
  final String name;

  const PaymentMethod(this.id, this.name);

  Map<String, dynamic> toMap() => {
        "id": id,
        "name": name,
      };

  Map<String, dynamic> toInsertMap() => {
        "name": name,
      };

  factory PaymentMethod.fromMap(Map<String, dynamic> json) => PaymentMethod(
        json[DBConsts.paymentMethodIDColumnName],
        json[DBConsts.paymentMethodNameColumnName],
      );
}

class SubscriptionItem {
  final int id;
  final String name;
  final int price;
  final DateTime next;
  final PaymentInterval interval;
  final PaymentMethod paymentMethod;
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
        DBConsts.subscriptionsIDColumnName: id,
        DBConsts.subscriptionsNameColumnName: name,
        DBConsts.subscriptionsPriceColumnName: price,
        DBConsts.subscriptionsNextColumnName: next.toUtc().toIso8601String(),
        DBConsts.subscriptionsIntervalColumnName: interval.intervalID,
        DBConsts.subscriptionsNoteColumnName: note,
        DBConsts.subscriptionsPaymentColumnName: paymentMethod.name,
      };

  Map<String, dynamic> toInsertMap() => {
        DBConsts.subscriptionsNameColumnName: name,
        DBConsts.subscriptionsPriceColumnName: price,
        DBConsts.subscriptionsNextColumnName: next.toUtc().toIso8601String(),
        DBConsts.subscriptionsIntervalColumnName: interval.intervalID,
        DBConsts.subscriptionsPaymentColumnName: paymentMethod.id,
        DBConsts.subscriptionsNoteColumnName: note,
      };

  factory SubscriptionItem.fromMap(Map<String, dynamic> json) =>
      SubscriptionItem(
        json[DBConsts.subscriptionsIDColumnName],
        json[DBConsts.subscriptionsNameColumnName],
        json[DBConsts.subscriptionsPriceColumnName],
        DateTime.parse(json[DBConsts.subscriptionsNextColumnName]).toLocal(),
        getPaymentInterval(json[DBConsts.subscriptionsIntervalColumnName]),
        json[DBConsts.subscriptionsNoteColumnName],
        PaymentMethod(json[DBConsts.paymentMethodIDColumnName],
            json[DBConsts.paymentMethodNameColumnName]),
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
          note,
          paymentMethod,
        );
      case PaymentInterval.Weekly:
        return SubscriptionItem(
          id,
          name,
          price,
          DateTime(next.year, next.month, next.day + 7),
          interval,
          note,
          paymentMethod,
        );
      case PaymentInterval.Fortnightly:
        return SubscriptionItem(
          id,
          name,
          price,
          DateTime(next.year, next.month, next.day + 14),
          interval,
          note,
          paymentMethod,
        );
      case PaymentInterval.Monthly:
        return SubscriptionItem(
          id,
          name,
          price,
          DateTime(next.year, next.month + 1, next.day),
          interval,
          note,
          paymentMethod,
        );
      case PaymentInterval.Yearly:
        return SubscriptionItem(
          id,
          name,
          price,
          DateTime(next.year + 1, next.month, next.day),
          interval,
          note,
          paymentMethod,
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
        return 0;
      case PaymentInterval.Weekly:
        return 1;
      case PaymentInterval.Fortnightly:
        return 2;
      case PaymentInterval.Monthly:
        return 3;
      case PaymentInterval.Yearly:
        return 4;
    }
  }
}

PaymentInterval getPaymentInterval(int id) {
  switch (id) {
    case 0:
      return PaymentInterval.Daily;
    case 1:
      return PaymentInterval.Weekly;
    case 2:
      return PaymentInterval.Fortnightly;
    case 3:
      return PaymentInterval.Monthly;
    case 4:
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

enum NotificationBefore {
  NONE,
  SAMEDAY,
  BEFORE1DAY,
  BEFORE2DAY,
  BEFORE3DAY,
  BEFORE4DAY,
  BEFORE5DAY,
  BEFORE6DAY,
  BEFORE7DAY,
  BEFORE8DAY,
  BEFORE9DAY,
  BEFORE10DAY,
  BEFORE14DAY,
}

extension NotificationBeforeText on NotificationBefore {
  String get text {
    switch (this) {
      case NotificationBefore.NONE:
        return "通知オフ";
      case NotificationBefore.SAMEDAY:
        return "当日";
      case NotificationBefore.BEFORE1DAY:
        return "1日前";
      case NotificationBefore.BEFORE2DAY:
        return "2日前";
      case NotificationBefore.BEFORE3DAY:
        return "3日前";
      case NotificationBefore.BEFORE4DAY:
        return "4日前";
      case NotificationBefore.BEFORE5DAY:
        return "5日前";
      case NotificationBefore.BEFORE6DAY:
        return "6日前";
      case NotificationBefore.BEFORE7DAY:
        return "7日前";
      case NotificationBefore.BEFORE8DAY:
        return "8日前";
      case NotificationBefore.BEFORE9DAY:
        return "9日前";
      case NotificationBefore.BEFORE10DAY:
        return "10日前";
      case NotificationBefore.BEFORE14DAY:
        return "14日前";
    }
  }
}
