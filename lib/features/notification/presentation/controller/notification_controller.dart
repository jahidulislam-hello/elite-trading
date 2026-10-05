import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

import '../../../../core/exceptions/app_exceptions.dart';
import '../../data/model/notification_model.dart';
import '../../notification_service.dart';

class NotificationController extends GetxController {
  // ─── Service ──────────────────────────────────────────────────────────────
  final NotificationService _service = NotificationService();

  // ─── State ────────────────────────────────────────────────────────────────
  final RxList<NotificationModel> notifications = <NotificationModel>[].obs;
  final RxBool isLoading = false.obs;
  final RxString error = ''.obs;
  final RxInt unreadCount = 0.obs;

  int get totalNotifications => notifications.length;

  /// Group notifications by dateGroup for the UI list
  Map<String, List<NotificationModel>> get groupedNotifications {
    final Map<String, List<NotificationModel>> map = {};
    for (final n in notifications) {
      map.putIfAbsent(n.dateGroup, () => []).add(n);
    }
    return map;
  }

  // ─── Lifecycle ────────────────────────────────────────────────────────────
  @override
  void onInit() {
    super.onInit();
    loadNotifications();
  }

  // ─── Load notifications ───────────────────────────────────────────────────
  Future<void> loadNotifications({bool refresh = false}) async {
    if (refresh) notifications.clear();
    isLoading.value = true;
    error.value = '';
    try {
      final result = await _service.getNotifications();
      notifications.value = result.notifications;
      unreadCount.value = result.unreadCount;
    } on AppException catch (e) {
      debugPrint('loadNotifications AppException: ${e.message}');
      error.value = e.message;
    } catch (e, s) {
      debugPrint('loadNotifications unexpected error: $e\n$s');
      error.value = 'Failed to load notifications.';
    } finally {
      isLoading.value = false;
    }
  }

  // ─── Mark single notification as read ────────────────────────────────────
  Future<void> markAsRead(String id) async {
    final index = notifications.indexWhere((n) => n.id == id);
    if (index < 0 || !notifications[index].isUnread) return;

    // Optimistic update
    final old = notifications[index];
    notifications[index] = NotificationModel(
      id: old.id,
      title: old.title,
      message: old.message,
      audience: old.audience,
      category: old.category,
      status: old.status,
      sentAt: old.sentAt,
      timeAgo: old.timeAgo,
      sentLabel: old.sentLabel,
      isRead: true,
    );
    if (unreadCount.value > 0) unreadCount.value--;

    try {
      await _service.markAsRead(id);
    } catch (_) {
      // Revert on error
      notifications[index] = old;
      unreadCount.value++;
    }
  }

  // ─── Mark all as read ─────────────────────────────────────────────────────
  Future<void> markAllAsRead() async {
    final hadUnread = unreadCount.value;
    // Optimistic: mark all read locally
    for (int i = 0; i < notifications.length; i++) {
      if (notifications[i].isUnread) {
        final n = notifications[i];
        notifications[i] = NotificationModel(
          id: n.id,
          title: n.title,
          message: n.message,
          audience: n.audience,
          category: n.category,
          status: n.status,
          sentAt: n.sentAt,
          timeAgo: n.timeAgo,
          sentLabel: n.sentLabel,
          isRead: true,
        );
      }
    }
    unreadCount.value = 0;

    try {
      await _service.markAllAsRead();
    } catch (_) {
      // Revert by reloading
      unreadCount.value = hadUnread;
      await loadNotifications(refresh: true);
    }
  }

  // ─── Clear (local only) ───────────────────────────────────────────────────
  void clearAll() {
    notifications.clear();
    unreadCount.value = 0;
  }

}

