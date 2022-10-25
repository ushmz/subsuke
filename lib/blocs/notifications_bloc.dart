import 'package:rxdart/rxdart.dart';
import 'package:subsuke/db/db_provider.dart';
import 'package:subsuke/models/notification.dart';

class NotificationsBLoC {
  final _messagesController = BehaviorSubject<List<NotificationMessage>>();

  Stream<List<NotificationMessage>> get messageStream =>
      _messagesController.stream;
  Function(List<NotificationMessage>) get setNotificationMessage =>
      _messagesController.sink.add;

    int get messagesCount => _messagesController.value.length;

  NotificationsBLoC() {
    getMessages();
  }

  getMessages() async {
    final messages = await DBProvider.instance.getAllNotifications();
    _messagesController.sink.add(messages);
  }

  updateAll() async {
    DBProvider.instance.readAllNotification();
    getMessages();
  }

  update(List<int> ids) async {
    DBProvider.instance.readNotifications(ids);
    getMessages();
  }

  deleteAll() async {
    DBProvider.instance.deleteAllNotification();
    getMessages();
  }

  void dispose() {
    _messagesController.close();
  }
}
