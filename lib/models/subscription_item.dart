import 'package:subsuke/db/consts.dart';
import 'package:subsuke/models/payment_interval.dart';

class SubscriptionItem {
  final int id;
  final String name;
  final int price;
  final DateTime next;
  final int? remindBefore;
  final PaymentInterval interval;
  final String paymentMethod;
  final String note;

  SubscriptionItem({
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
