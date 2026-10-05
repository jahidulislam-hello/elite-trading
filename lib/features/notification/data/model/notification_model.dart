/// Notification models matching the backend formatter output from:
///   backend/src/modules/basic_modules/notification/notification.formatter.ts
///   backend/src/modules/basic_modules/notification/notification.interface.ts

// ─── Notification type (inferred from title on backend) ──────────────────

enum NotificationType { signal, update, alert, general }

// ─── Notification Model ───────────────────────────────────────────────────

class NotificationModel {
  final String id;
  final String title;
  final String message; // backend field is 'message' not 'description'
  final String audience;
  final String category; // Signal | Trial | Market | News | General
  final String status; // Sent | Scheduled | Draft
  final DateTime? sentAt;
  final String timeAgo;
  final String sentLabel;
  final bool isRead;

  const NotificationModel({
    required this.id,
    required this.title,
    required this.message,
    required this.audience,
    required this.category,
    required this.status,
    this.sentAt,
    required this.timeAgo,
    required this.sentLabel,
    required this.isRead,
  });

  bool get isUnread => !isRead;

  /// Map backend category string to local enum
  NotificationType get type {
    switch (category.toLowerCase()) {
      case 'signal':
        return NotificationType.signal;
      case 'market':
      case 'news':
        return NotificationType.update;
      case 'trial':
      case 'alert':
        return NotificationType.alert;
      case 'general':
      default:
        return NotificationType.general;
    }
  }

  /// Date group for UI grouping: TODAY / YESTERDAY / older label
  String get dateGroup {
    if (sentAt == null) return 'RECENT';
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final sentLocal = sentAt!.toLocal();
    final sentDay = DateTime(sentLocal.year, sentLocal.month, sentLocal.day);
    final diffDays = today.difference(sentDay).inDays;
    if (diffDays <= 0) return 'TODAY';
    if (diffDays == 1) return 'YESTERDAY';
    if (diffDays < 7) return 'THIS WEEK';
    return 'EARLIER';
  }

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    final sentAtRaw = json['sentAt'] ?? json['createdAt'];
    DateTime? sentAt;
    if (sentAtRaw is String) {
      sentAt = DateTime.tryParse(sentAtRaw);
    } else if (sentAtRaw is int) {
      sentAt = DateTime.fromMillisecondsSinceEpoch(sentAtRaw);
    }

    return NotificationModel(
      id: json['id']?.toString() ?? json['_id']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      message: json['message']?.toString() ??
          json['description']?.toString() ??
          json['body']?.toString() ??
          '',
      audience: json['audience']?.toString() ?? '',
      category: json['category']?.toString() ?? 'General',
      status: json['status']?.toString() ?? 'Sent',
      sentAt: sentAt,
      timeAgo: json['timeAgo']?.toString() ?? '',
      sentLabel: json['sentLabel']?.toString() ??
          json['sent']?.toString() ??
          '',
      isRead: json['isRead'] as bool? ?? false,
    );
  }
}

// ─── Result wrapper ───────────────────────────────────────────────────────

class NotificationListResult {
  final List<NotificationModel> notifications;
  final int unreadCount;
  final int totalNotifications;
  final Map<String, dynamic>? pagination;

  const NotificationListResult({
    required this.notifications,
    required this.unreadCount,
    required this.totalNotifications,
    this.pagination,
  });
}
