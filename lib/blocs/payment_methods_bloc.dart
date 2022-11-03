import 'package:rxdart/rxdart.dart';
import 'package:subsuke/db/db_provider.dart';
import 'package:subsuke/models/payment_method.dart';

class PaymentMethodBLoC {
  final _paymentMethodsController = BehaviorSubject<List<PaymentMethod>>();

  Stream<List<PaymentMethod>> get methodsStream =>
      _paymentMethodsController.stream;

  Future<void> fetchAllPaymentMethods() async {
    final list = await DBProvider.instance.getAllPaymentMethods();
    _paymentMethodsController.sink.add(list);
  }

  Future<List<PaymentMethod>> getAllPaymentMethods() async {
    final list = await DBProvider.instance.getAllPaymentMethods();
    return list;
  }

  final _selectedMethod = BehaviorSubject<PaymentMethod>();
  Stream<PaymentMethod> get methodStream => _selectedMethod.stream;
  Function(PaymentMethod) get setPaymentMethod => _selectedMethod.sink.add;

  void setPaymentMethodString(String method) async {
    final methods = await getAllPaymentMethods();
    final m = methods.firstWhere(
      (m) => m.name == method,
      orElse: () => methods[0],
    );
    _selectedMethod.sink.add(m);
  }

  PaymentMethod get getMethod => _selectedMethod.value;
  int get getMethodID => _selectedMethod.value.id;
  String get getMethodName => _selectedMethod.value.name;

  PaymentMethodBLoC() {
    fetchAllPaymentMethods();
  }

  void dispose() {
    _paymentMethodsController.close();
    _selectedMethod.close();
  }
}
