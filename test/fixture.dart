import 'dart:convert';
import 'dart:io';

typedef Fixture = Map<String, dynamic>;

String _fixture(String name) {
  return File('./test/fixtures/$name').readAsStringSync();
}

Fixture getSubscriptionItemsFixtures() {
  final content = _fixture('subscription_items.json');
  return jsonDecode(content);
}
