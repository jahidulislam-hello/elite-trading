import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../history/presentation/container/history_container.dart';
import '../../../notification/presentation/controller/notification_controller.dart';
import '../../../notification/presentation/screen/notification_screen.dart';
import '../../../Post/presentation/controller/post_controller.dart';
import '../../../Post/presentation/screen/post_screen.dart';
import '../../../history/presentation/screen/history_screen.dart';
import '../../../signals/presentation/controller/signal_controller.dart';
import '../../../signals/presentation/screen/signal_screen.dart';

class NavItemData {
  final IconData icon;
  final String label;
  const NavItemData({required this.icon, required this.label});
}

class BottomNavController extends GetxController {
  final RxInt selectedIndex = 0.obs;

  final List<Widget> screens = const [
    SignalScreen(),
    NotificationScreen(),
    PostScreen(),
    HistoryScreen(),
  ];

  final List<NavItemData> navItems = const [
    NavItemData(icon: Icons.bolt_rounded, label: 'Signal'),
    NavItemData(icon: Icons.notifications_none_rounded, label: 'Alert'),
    NavItemData(icon: Icons.menu_book_outlined, label: 'Post'),
    NavItemData(icon: Icons.bar_chart_rounded, label: 'Result'),
  ];

  void changeTab(int index) {
    selectedIndex.value = index;
    refreshTab(index);
  }

  /// Reloads every tab — used after events that change what the user may see,
  /// such as activating a subscription.
  void refreshAllTabs() {
    for (var index = 0; index < screens.length; index++) {
      refreshTab(index);
    }
  }

  /// Re-fetches the data the given tab shows, so the user always sees the
  /// latest server state when switching tabs.
  void refreshTab(int index) {
    switch (index) {
      case 0:
        if (Get.isRegistered<SignalController>()) {
          final signal = Get.find<SignalController>();
          if (!signal.isSignalsLoading.value) signal.loadSignals();
          if (!signal.isMarketHoursLoading.value) signal.loadMarketHours();
        }
        break;
      case 1:
        if (Get.isRegistered<NotificationController>()) {
          final notification = Get.find<NotificationController>();
          if (!notification.isLoading.value) notification.loadNotifications();
        }
        break;
      case 2:
        if (Get.isRegistered<PostController>()) {
          final post = Get.find<PostController>();
          if (!post.isPostsLoading.value) post.loadPosts();
        }
        break;
      case 3:
        if (Get.isRegistered<HistoryContainer>()) {
          final history = Get.find<HistoryContainer>();
          if (!history.isLoading.value) history.loadHistory();
        }
        break;
    }
  }
}