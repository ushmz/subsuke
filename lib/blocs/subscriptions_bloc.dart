import 'package:rxdart/rxdart.dart';
import 'package:subsuke/db/subscription_repository.dart';
import 'package:subsuke/models/subsucription.dart';

class SubscriptionsBloc {
  final _subscriptionsController = BehaviorSubject<List<Subscription>>();
  final _fetchRequest = BehaviorSubject<Object>();

  Function(List<Subscription>) get setSubscriptions =>
      _subscriptionsController.sink.add;
  Stream<List<Subscription>> get onChangeSubscriptions =>
      _subscriptionsController.stream;

  Function() get fetchRequest => () => _fetchRequest.sink.add('');
  Stream<void> get onFetchRequested => _fetchRequest.stream;

  SubscriptionsBloc() {
    fetchSubscriptions();
    _fetchRequest.listen((v) => fetchSubscriptions());
  }

  Future<void> fetchSubscriptions() async {
    final subscriptions = await SubscriptionRepository.getAll();
    _subscriptionsController.sink.add(subscriptions);
  }

  Future<void> addSubscription(
      String name, String billingAt, int price, String cycle) async {
    await SubscriptionRepository.create(name, billingAt, price, cycle);
    await fetchSubscriptions();
  }

  void dispose() {
    _subscriptionsController.close();
    _fetchRequest.close();
  }
}
