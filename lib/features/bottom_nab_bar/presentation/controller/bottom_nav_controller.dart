import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../notification/presentation/screen/notification_screen.dart';
import '../../../Post/presentation/screen/post_screen.dart';
import '../../../history/presentation/screen/history_screen.dart';
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
    if (selectedIndex.value == index) return;
    selectedIndex.value = index;
  }
}