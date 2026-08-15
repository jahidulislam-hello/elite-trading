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
    final data = response.data['data'] as Map<String, dynamic>? ?? {};
    final rawList = data['notifications'] as List? ?? [];
    return NotificationListResult(
      notifications: rawList
          .map((e) => NotificationModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      unreadCount: data['unreadCount'] as int? ?? 0,
      totalNotifications: data['totalNotifications'] as int? ?? 0,
      pagination: response.data['pagination'] as Map<String, dynamic>?,
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
        final msg = responseData['message'] as String?;
        throw ServerException(
            msg?.isNotEmpty == true ? msg! : fallback, null);
      }
    }
  }
}
