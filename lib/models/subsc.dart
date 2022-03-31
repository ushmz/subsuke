import 'package:isar/isar.dart';

part 'subsc.g.dart';

@Collection()
class SubscriptionItem {
  @Id()
  int id = Isar.autoIncrement;
  String name;
  int price;
  /* Duration duration; */
  DateTime nextPaymentAt;

  SubscriptionItem(this.name, this.price, this.nextPaymentAt);
}
