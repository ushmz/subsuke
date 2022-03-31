import 'package:rxdart/rxdart.dart';
import 'package:subsuke/db/subsc.dart';
import 'package:subsuke/models/subsc.dart';
import 'package:subsuke/models/subsucription.dart';

class SubscriptionsBloc {
  final _subscriptionsController = BehaviorSubject<List<SubscriptionItem>>();
  final _fetchRequest = BehaviorSubject<Object>();

  Function(List<SubscriptionItem>) get setSubscriptions =>
      _subscriptionsController.sink.add;
  Stream<List<SubscriptionItem>> get onChangeSubscriptions =>
      _subscriptionsController.stream;

  Function() get fetchRequest => () => _fetchRequest.sink.add('');
  Stream<void> get onFetchRequested => _fetchRequest.stream;

  SubscriptionsBloc() {
    fetchSubscriptions();
    _fetchRequest.listen((v) => fetchSubscriptions());
  }

  Future<void> fetchSubscriptions() async {
    final subscriptions = await SubscRepository.getAll();
    _subscriptionsController.sink.add(subscriptions);
  }

  Future<void> addSubscription(
      String name, int price, Duration duration, DateTime next) async {
    final item = SubscriptionItem(name, price, duration, next);
    await SubscRepository.create(item);
    await fetchSubscriptions();
  }

  void dispose() {
    _subscriptionsController.close();
    _fetchRequest.close();
  }
}
