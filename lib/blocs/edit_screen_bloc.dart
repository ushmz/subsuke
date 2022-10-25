import 'package:rxdart/rxdart.dart';
import 'package:subsuke/models/subsc.dart';

class EditScreenBLoC {
  final _nameTextController = BehaviorSubject.seeded('');
  final _priceNumberController = BehaviorSubject.seeded(0);
  final _nextTimeController = BehaviorSubject.seeded(DateTime.now());
  final _intervalController = BehaviorSubject.seeded(PaymentInterval.Monthly);
  final _paymentController = BehaviorSubject.seeded('');
  final _nofiticationBeforeController =
      BehaviorSubject.seeded(NotificationBefore.NONE);
  final _noteController = BehaviorSubject.seeded('');

  Function(String) get setNameText => _nameTextController.sink.add;
  Stream<String> get onChangeNameText => _nameTextController.stream;
  String get getName => _nameTextController.value;

  Function(int) get setPriceNum => _priceNumberController.sink.add;
  Stream<int> get onChangePriceNum => _priceNumberController.stream;
  int get getPrice => _priceNumberController.value;

  Function(DateTime) get setNextTime => _nextTimeController.sink.add;
  Stream<DateTime> get onChangeNextTime => _nextTimeController.stream;
  DateTime get getNextTime => _nextTimeController.value;

  Function(PaymentInterval) get setInterval => _intervalController.sink.add;
  Stream<PaymentInterval> get onChangeInterval => _intervalController.stream;
  PaymentInterval get getInterval => _intervalController.value;

  Function(String) get setPaymentMethod => _paymentController.sink.add;
  Stream<String> get onChangePayment => _paymentController.stream;
  String get getPaymentMethod => _paymentController.value;

  Function(NotificationBefore) get setNotificationBefore =>
      _nofiticationBeforeController.sink.add;
  Stream<NotificationBefore> get onChangeNotificationBefore =>
      _nofiticationBeforeController.stream;
  NotificationBefore get getNotificationBefore =>
      _nofiticationBeforeController.value;

  Function(String) get setNote => _noteController.sink.add;
  Stream<String> get onChangeNote => _noteController.stream;
  String get getNote => _noteController.value;

  void setValues(SubscriptionItem item) {
    setNameText(item.name);
    setPriceNum(item.price);
    setNextTime(item.next);
    setInterval(item.interval);
  }

  SubscriptionItem getValues() {
    return SubscriptionItem.fromMap({
      'name': _nameTextController.value,
      'price': _priceNumberController.value,
      'payment_methods': _paymentController.value,
      'interval': _intervalController.value,
      'next': _nextTimeController.value,
      'remind_before': 1,
      'note': _noteController.value,
    });
  }

  void dispose() {
    _nameTextController.close();
    _priceNumberController.close();
    _nextTimeController.close();
    _intervalController.close();
    _paymentController.close();
    _nofiticationBeforeController.close();
    _noteController.close();
  }
}
