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
