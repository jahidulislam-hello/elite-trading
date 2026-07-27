enum NotificationType { signal, update, alert }

class NotificationItemModel {
  final String id;
  final NotificationType type;
  final String title;
  final String description;
  final String timeAgo;
  final String dateGroup; // 'TODAY', 'YESTERDAY' etc.
  final bool isUnread;

  const NotificationItemModel({
    required this.id,
    required this.type,
    required this.title,
    required this.description,
    required this.timeAgo,
    required this.dateGroup,
    this.isUnread = false,
  });
}