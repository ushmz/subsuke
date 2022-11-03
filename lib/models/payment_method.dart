import 'package:subsuke/db/consts.dart';

class PaymentMethod {
  final int id;
  final String name;

  const PaymentMethod(this.id, this.name);

  Map<String, dynamic> toMap() => {
        DBConsts.paymentMethodIDColumnName: id,
        DBConsts.paymentMethodNameColumnName: name,
      };

  Map<String, dynamic> toInsertMap() => {
        DBConsts.paymentMethodNameColumnName: name,
      };

  factory PaymentMethod.fromMap(Map<String, dynamic> json) => PaymentMethod(
        json[DBConsts.paymentMethodIDColumnName],
        json[DBConsts.paymentMethodNameColumnName],
      );
}
