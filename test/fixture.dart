import 'dart:convert';
import 'dart:io';

typedef Fixture = Map<String, dynamic>;

String _fixture(String name) {
  return File('./test/fixtures/$name').readAsStringSync();
}

Fixture getSubscriptionItemsSortFixtures() {
  final content = _fixture('subscription_items_sort.json');
  return jsonDecode(content);
}
