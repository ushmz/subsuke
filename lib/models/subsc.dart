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
  final int? remindBefore;
  final PaymentInterval interval;
  final String paymentMethod;
  final String note;

  const SubscriptionItem({
    required this.id,
    required this.name,
    required this.price,
    required this.next,
    required this.interval,
    required this.note,
    required this.paymentMethod,
    this.remindBefore,
  });

  int get getID => id;

  // [TODO] Ulid is String value
  // See : https://pub.dev/packages/ulid
  /* static assignUUID() { */
  /*     id = Ulid(); */
  /* } */

  Map<String, dynamic> toJson() => {
        DBConsts.subscriptionsIDColumnName: id,
        DBConsts.subscriptionsNameColumnName: name,
        DBConsts.subscriptionsPriceColumnName: price,
        DBConsts.subscriptionsPaymentColumnName: paymentMethod,
        DBConsts.subscriptionsIntervalColumnName: interval.getID,
        DBConsts.subscriptionsNextColumnName: next.toIso8601String(),
        DBConsts.subscriptionsRemindBeforeColumnName: remindBefore,
        DBConsts.subscriptionsNoteColumnName: note,
      };

  Map<String, dynamic> toInsertMap() => {
        DBConsts.subscriptionsNameColumnName: name,
        DBConsts.subscriptionsPriceColumnName: price,
        DBConsts.subscriptionsPaymentColumnName: paymentMethod,
        DBConsts.subscriptionsIntervalColumnName: interval.getID,
        DBConsts.subscriptionsNextColumnName: next.toIso8601String(),
        DBConsts.subscriptionsRemindBeforeColumnName: remindBefore,
        DBConsts.subscriptionsNoteColumnName: note,
      };

  factory SubscriptionItem.fromJson(Map<String, dynamic> json) =>
      SubscriptionItem(
        id: json['id'],
        name: json['name'],
        price: json['price'],
        paymentMethod: json['payment_methods'],
        interval: getPaymentInterval(json['interval']),
        next: DateTime.parse(json['next']),
        remindBefore: json['remind_before'],
        note: json['note'],
      );

  factory SubscriptionItem.fromSQLResultRow(Map<String, dynamic> json) =>
      SubscriptionItem(
        id: json[DBConsts.subscriptionsIDColumnName],
        name: json[DBConsts.subscriptionsNameColumnName],
        price: json[DBConsts.subscriptionsPriceColumnName],
        paymentMethod: json[DBConsts.subscriptionsPaymentColumnName],
        interval:
            getPaymentInterval(json[DBConsts.subscriptionsIntervalColumnName]),
        next: DateTime.parse(json[DBConsts.subscriptionsNextColumnName]),
        remindBefore: json[DBConsts.subscriptionsRemindBeforeColumnName],
        note: json[DBConsts.subscriptionsNoteColumnName],
      );

  // TODO : Avoid new object?
  SubscriptionItem updateNextPayment() {
    DateTime updated;
    switch (interval) {
      case PaymentInterval.Daily:
        updated = DateTime(next.year, next.month, next.day + 1);
        break;
      case PaymentInterval.Weekly:
        updated = DateTime(next.year, next.month, next.day + 7);
        break;
      case PaymentInterval.Fortnightly:
        updated = DateTime(next.year, next.month, next.day + 14);
        break;
      case PaymentInterval.Monthly:
        updated = DateTime(next.year, next.month + 1, next.day);
        break;
      case PaymentInterval.Yearly:
        updated = DateTime(next.year + 1, next.month, next.day);
        break;
    }
    return SubscriptionItem(
      id: id,
      name: name,
      price: price,
      paymentMethod: paymentMethod,
      interval: interval,
      next: updated,
      remindBefore: remindBefore,
      note: note,
    );
  }
}

int calcActualMonthlyPrice(List<SubscriptionItem> items) {
  final n = DateTime.now();
  final days = new DateTime(n.year, n.month, 0).day;

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

typedef ProratedPrice = Map<PaymentInterval, int>;
ProratedPrice calcProratedPrice(List<SubscriptionItem> items) {
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
  return {
    PaymentInterval.Daily: daily,
    PaymentInterval.Weekly: weekly,
    PaymentInterval.Monthly: monthly,
    PaymentInterval.Yearly: yearly
  };
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

extension PaymentIntervalExt on PaymentInterval {
  int get getID {
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

  String get getUnitName {
    switch (this) {
      case PaymentInterval.Daily:
        return "日";
      case PaymentInterval.Weekly:
      case PaymentInterval.Fortnightly:
        return "週";
      case PaymentInterval.Monthly:
        return "月";
      case PaymentInterval.Yearly:
        return "年";
    }
  }

  String get getText {
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
