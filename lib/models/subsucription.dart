enum Cycle { Daily, Weekly, Monthly, Yearly }

class Subscription {
  final int id;
  final String name;
  final String billingAt;
  final int price;
  final Cycle cycle;

  const Subscription(
    this.id,
    this.name,
    this.billingAt,
    this.price,
    this.cycle,
  );

  int get getId => id;

  Map<String, dynamic> toMap() => {
        "id": id,
        "name": name,
        "billingAt": billingAt,
        "price": price,
        "cycle": cycle
      };

  factory Subscription.fromMap(Map<String, dynamic> json) => Subscription(
        json['id'],
        json['name'],
        json['billingAt'],
        json['price'],
        json['cycle'],
      );
}

class Subscriptions {
  List<Subscription> subscriptions;

  int daily;
  int weekly;
  int monthly;
  int yearly;

  Subscriptions(List<Subscription> subscriptions) : subscriptions=subscriptions, daily=0, weekly=0, monthly=0, yearly=0 {
    /* this.subscriptions = subscriptions; */
    this.subscriptions.forEach((s) {
      switch (s.cycle) {
        case Cycle.Daily:
          daily += s.price;
          weekly += s.price * 7;
          monthly += s.price * 30;
          yearly += s.price * 365;
          break;
        case Cycle.Weekly:
          daily += s.price ~/ 7;
          weekly += s.price;
          monthly += s.price * 4;
          yearly += s.price * 4 * 12;
          break;
        case Cycle.Monthly:
          daily += s.price ~/ 30;
          weekly += s.price ~/ 4;
          monthly += s.price;
          yearly += s.price * 12;
          break;
        case Cycle.Yearly:
          daily += s.price ~/ 365;
          weekly += s.price ~/ (4 * 12);
          monthly += s.price ~/ 12;
          yearly += s.price;
          break;
      }
    });
  }

  List<Subscription> get getSubscriptions => subscriptions;

  int dailyPrice() {
    return daily;
  }

  int weeklyPrice() {
    return weekly;
  }

  int monthlyPrice() {
    return monthly;
  }

  int yearlyPrice() {
    return yearly;
  }
}
