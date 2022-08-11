class DBConsts {
  static const filename = 'subscriptions.db';
  static const version = 2;

  static const subscriptionsTablename = 'subscriptions';
  static const subscriptionsIDColumnName = 'id';
  static const subscriptionsNameColumnName = 'name';
  static const subscriptionsPriceColumnName = 'price';
  static const subscriptionsNextColumnName = 'next';
  static const subscriptionsIntervalColumnName = 'interval';
  static const subscriptionsPaymentColumnName = 'payment_method';
  static const subscriptionsNoteColumnName = 'note';

  static const notificationsTableName = 'notifications';
  static const notificationsIDColumnName = 'notification_id';
  static const notificationsTitleColumnName = 'title';
  static const notificationsBodyColumnName = 'body';
  static const notificationsReceivedAtColumnName = 'received_at';
  static const notificationsIsUnreadColumnName = 'unread';

  static const paymentMethodTableName = 'payment_methods';
  static const paymentMethodIDColumnName = 'method_id';
  static const paymentMethodNameColumnName = 'method_name';

  static final scripts = {
    '2': [],
  };
}
