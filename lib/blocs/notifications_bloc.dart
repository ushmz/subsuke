import 'package:rxdart/rxdart.dart';
import 'package:subsuke/db/db_provider.dart';
import 'package:subsuke/models/notification.dart';

class NotificationsBloc {
  final _messagesController = BehaviorSubject<List<NotificationMessage>>();

  Stream<List<NotificationMessage>> get messageStream =>
      _messagesController.stream;
  Function(List<NotificationMessage>) get setNotificationMessage =>
      _messagesController.sink.add;

    int get messagesCount => _messagesController.value.length;

  NotificationsBloc() {
    /* [ */
    /*   NotificationMessage(1, "通知タイトル", "通知本文", DateTime.now(), true), */
    /*   NotificationMessage(2, "通知タイトル", "通知本文", DateTime.now(), true), */
    /*   NotificationMessage(3, "通知タイトル", "通知本文", DateTime.now(), true), */
    /*   NotificationMessage(4, "通知タイトル", "通知本文", DateTime.now(), true), */
    /*   NotificationMessage(5, "通知タイトル", "通知本文", DateTime.now(), true), */
    /*   NotificationMessage(6, "通知タイトル", "通知本文", DateTime.now(), true), */
    /* ].forEach((element) { */
    /*   DBProvider.instance?.insertNewNotification(element); */
    /* }); */
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
    DBProvider.instance.archiveAllNotification();
    getMessages();
  }

  void dispose() {
    _messagesController.close();
  }
}
