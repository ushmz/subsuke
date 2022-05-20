class NotificationMessage {
  final int id;
  final String title;
  final String body;
  final DateTime receivedAt;
  final bool isUnread;

  const NotificationMessage(
    this.id,
    this.title,
    this.body,
    this.receivedAt,
    this.isUnread,
  );

  int get getID => id;

  // [TODO] Ulid is String value
  // See : https://pub.dev/packages/ulid
  /* static assignUUID() { */
  /*     id = Ulid(); */
  /* } */

  Map<String, dynamic> toMap() => {
        "id": id,
        "title": title,
        "body": body,
        "received_at": receivedAt.toUtc().toIso8601String(),
        "unread": isUnread ? 1 : 0,
      };

  Map<String, dynamic> toInsertMap() => {
        "title": title,
        "body": body,
        "received_at": receivedAt.toUtc().toIso8601String(),
        "unread": isUnread ? 1 : 0,
      };

  factory NotificationMessage.fromMap(Map<String, dynamic> json) =>
      NotificationMessage(
        json['id'],
        json['title'],
        json['body'],
        DateTime.parse(json['received_at']).toLocal(),
        json['unread'] == 1,
      );
}

