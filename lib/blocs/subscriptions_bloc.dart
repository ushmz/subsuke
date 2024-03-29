import 'package:rxdart/rxdart.dart';
import 'package:subsuke/models/subsucription.dart';

class SubscriptionsBLoC {
  final _subscriptionsController = BehaviorSubject<List<Subscription>>();
  final _fetchRequest = BehaviorSubject<Object>();

  Function(List<Subscription>) get setSubscriptions =>
      _subscriptionsController.sink.add;
  Stream<List<Subscription>> get onChangeSubscriptions =>
      _subscriptionsController.stream;

  Function() get fetchRequest => () => _fetchRequest.sink.add('');
  Stream<void> get onFetchRequested => _fetchRequest.stream;

  SubscriptionsBLoC() {
    fetchSubscriptions();
    _fetchRequest.listen((v) => fetchSubscriptions());
  }

  Future<void> fetchSubscriptions() async {
    /* final subscriptions = await SubscriptionRepository.getAll(); */
        final subscriptions = [
            Subscription(1, "Youtube Premium", "", 1100, Cycle.Monthly),
            Subscription(2, "Youtube Premium", "", 1100, Cycle.Monthly),
            Subscription(3, "Youtube Premium", "", 1100, Cycle.Monthly),
        ];
    _subscriptionsController.sink.add(subscriptions);
  }

  Future<void> addSubscription(
      String name, String billingAt, int price, Cycle cycle) async {
    await fetchSubscriptions();
  }

  void dispose() {
    _subscriptionsController.close();
    _fetchRequest.close();
  }
}
