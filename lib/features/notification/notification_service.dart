import '../../core/constants/api_endpoints.dart';
import '../../core/exceptions/app_exceptions.dart';
import '../../core/services/api_service.dart';
import 'data/model/notification_model.dart';

/// Handles all notification-related API calls for the mobile app.
///
/// Maps 1-to-1 with backend routes at:
///   backend/src/modules/basic_modules/notification/notification.route.ts  (app section)
class NotificationService {
  final ApiService _api;

  NotificationService({ApiService? apiService})
      : _api = apiService ?? ApiService();

  // ──────────────────────────────────────────────────────────────────────────
  // 1. GET NOTIFICATIONS (paginated feed)
  // GET /api/v1/notification/app?page=&limit=
  // Returns: { notifications, unreadCount, totalNotifications }
  // ──────────────────────────────────────────────────────────────────────────
  Future<NotificationListResult> getNotifications({
    int page = 1,
    int limit = 30,
  }) async {
    final query = <String, dynamic>{'page': page, 'limit': limit};
    final response = await _api.get(
      ApiEndpoints.notificationsApp,
      queryParameters: query,
    );
    _assertSuccess(response.data, 'Failed to load notifications.');

    final dynamic dataRaw = response.data['data'];
    List rawList = [];
    int unreadCount = 0;
    int totalNotifications = 0;

    if (dataRaw is List) {
      rawList = dataRaw;
      totalNotifications = rawList.length;
    } else if (dataRaw is Map) {
      final mapData = Map<String, dynamic>.from(dataRaw);
      final listCandidate =
          mapData['notifications'] ?? mapData['data'] ?? mapData['items'];
      if (listCandidate is List) {
        rawList = listCandidate;
      }
      unreadCount = (mapData['unreadCount'] as num?)?.toInt() ?? 0;
      totalNotifications =
          (mapData['totalNotifications'] as num?)?.toInt() ?? rawList.length;
    }

    final notifications = <NotificationModel>[];
    for (final item in rawList) {
      if (item is Map) {
        notifications.add(
          NotificationModel.fromJson(Map<String, dynamic>.from(item)),
        );
      }
    }

    return NotificationListResult(
      notifications: notifications,
      unreadCount: unreadCount,
      totalNotifications: totalNotifications,
      pagination: response.data['pagination'] is Map
          ? Map<String, dynamic>.from(response.data['pagination'] as Map)
          : null,
    );
  }

  // ──────────────────────────────────────────────────────────────────────────
  // 2. GET UNREAD COUNT
  // GET /api/v1/notification/app/unread-count
  // Returns: { unreadCount }
  // ──────────────────────────────────────────────────────────────────────────
  Future<int> getUnreadCount() async {
    final response =
        await _api.get(ApiEndpoints.notificationUnreadCount);
    _assertSuccess(response.data, 'Failed to get unread count.');
    final data = response.data['data'] as Map<String, dynamic>? ?? {};
    return data['unreadCount'] as int? ?? 0;
  }

  // ──────────────────────────────────────────────────────────────────────────
  // 3. MARK ONE NOTIFICATION AS READ
  // POST /api/v1/notification/app/:notificationId/read
  // ──────────────────────────────────────────────────────────────────────────
  Future<void> markAsRead(String notificationId) async {
    final response = await _api.post(
      ApiEndpoints.markNotificationRead(notificationId),
    );
    _assertSuccess(response.data, 'Failed to mark notification as read.');
  }

  // ──────────────────────────────────────────────────────────────────────────
  // 4. MARK ALL NOTIFICATIONS AS READ
  // POST /api/v1/notification/app/read-all
  // ──────────────────────────────────────────────────────────────────────────
  Future<void> markAllAsRead() async {
    final response =
        await _api.post(ApiEndpoints.markAllNotificationsRead);
    _assertSuccess(response.data, 'Failed to mark all notifications as read.');
  }

  // ──────────────────────────────────────────────────────────────────────────
  // Helper
  // ──────────────────────────────────────────────────────────────────────────
  void _assertSuccess(dynamic responseData, String fallback) {
    if (responseData is Map<String, dynamic>) {
      if (responseData['success'] == false) {
        final sources = responseData['errorSources'] ??
            responseData['errorSoures'] ??
            responseData['errorMessages'];
        if (sources is List && sources.isNotEmpty) {
          final messages = <String>[];
          for (final item in sources) {
            if (item is Map<String, dynamic>) {
              final msg = item['message'];
              if (msg is String && msg.trim().isNotEmpty) {
                messages.add(msg.trim());
              }
            } else if (item is String && item.trim().isNotEmpty) {
              messages.add(item.trim());
            }
          }
          if (messages.isNotEmpty) {
            throw ServerException(messages.join('. '), null);
          }
        }
        final msg = responseData['message'] as String?;
        throw ServerException(
            msg?.isNotEmpty == true ? msg! : fallback, null);
      }
    }
  }
}
