import 'package:rxdart/rxdart.dart';
import 'package:subsuke/db/db_provider.dart';
import 'package:subsuke/models/subsc.dart';

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

  final _selectedMethodController =
      BehaviorSubject<PaymentMethod>.seeded(PaymentMethod(0, ""));

  Stream<PaymentMethod> get methodStream => _selectedMethodController.stream;
  Function(PaymentMethod) get setPaymentMethod =>
      _selectedMethodController.sink.add;

  void setPaymentMethodString(String method) async {
    final methods = await getAllPaymentMethods();
    final m = methods.firstWhere((m) => m.name == method, orElse: () => methods[0]);
    _selectedMethodController.sink.add(m);
  }

  PaymentMethod get getMethod => _selectedMethodController.value;
  int get getMethodID => _selectedMethodController.value.id;
  String get getMethodName => _selectedMethodController.value.name;

  PaymentMethodBLoC() {
    fetchAllPaymentMethods();
  }

  void dispose() {
    _paymentMethodsController.close();
    _selectedMethodController.close();
  }
}
