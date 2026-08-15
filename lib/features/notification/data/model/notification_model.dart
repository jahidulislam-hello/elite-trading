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
      case 'general':
      default:
        return NotificationType.alert;
    }
  }

  /// Date group for UI grouping: TODAY / YESTERDAY / older label
  String get dateGroup {
    if (sentAt == null) return 'RECENT';
    final now = DateTime.now();
    final diff = now.difference(sentAt!).inDays;
    if (diff == 0) return 'TODAY';
    if (diff == 1) return 'YESTERDAY';
    if (diff < 7) return 'THIS WEEK';
    return 'EARLIER';
  }

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    final sentAtStr = json['sentAt'] as String?;
    return NotificationModel(
      id: json['id']?.toString() ?? '',
      title: json['title'] as String? ?? '',
      message: json['message'] as String? ?? '',
      audience: json['audience'] as String? ?? '',
      category: json['category'] as String? ?? 'General',
      status: json['status'] as String? ?? 'Sent',
      sentAt: sentAtStr != null ? DateTime.tryParse(sentAtStr) : null,
      timeAgo: json['timeAgo'] as String? ?? '',
      sentLabel: json['sentLabel'] as String? ?? '',
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
