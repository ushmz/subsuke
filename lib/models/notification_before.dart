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
