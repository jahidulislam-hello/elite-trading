import 'package:get/get.dart';

import '../../data/model/notification_item_model.dart';


class NotificationController extends GetxController {
  final String userAvatar = 'asset/image/profile/alex.png';

  final RxList<NotificationItemModel> notifications = <NotificationItemModel>[].obs;
  int get unreadCount => notifications.where((n) => n.isUnread).length;

  // Group notifications by dateGroup, preserving first-seen order
  Map<String, List<NotificationItemModel>> get groupedNotifications {
    final Map<String, List<NotificationItemModel>> map = {};
    for (final n in notifications) {
      map.putIfAbsent(n.dateGroup, () => []).add(n);
    }
    return map;
  }

  @override
  void onInit() {
    super.onInit();
    _loadDummyNotifications();
  }

  void _loadDummyNotifications() {
    notifications.assignAll([
      const NotificationItemModel(
        id: '1',
        type: NotificationType.signal,
        title: 'New Signal Published',
        description: 'BTC/USDT BUY at \$67,420 — Entry now open. Check your position sizing.',
        timeAgo: '2h ago',
        dateGroup: 'TODAY',
        isUnread: true,
      ),
      const NotificationItemModel(
        id: '2',
        type: NotificationType.update,
        title: 'Signal Update: EUR/USD',
        description: 'TP1 hit at 1.08100 — Move stop loss to entry. Hold for TP2 at 1.07750.',
        timeAgo: '3h ago',
        dateGroup: 'TODAY',
      ),
      const NotificationItemModel(
        id: '3',
        type: NotificationType.alert,
        title: 'High Impact News Today',
        description: 'US CPI data at 14:30 UTC. Expect high volatility across all USD pairs.',
        timeAgo: '5h ago',
        dateGroup: 'TODAY',
      ),
      const NotificationItemModel(
        id: '4',
        type: NotificationType.signal,
        title: 'New Signal Published',
        description: 'GOLD/USD BUY at \$2,847.50 — Strong bullish confluence on 4H chart.',
        timeAgo: '4h ago',
        dateGroup: 'TODAY',
      ),
      const NotificationItemModel(
        id: '5',
        type: NotificationType.update,
        title: 'Signal Update: SPX500',
        description: 'TP2 reached at 5,760. Consider trailing stop for remaining position.',
        timeAgo: '1d ago',
        dateGroup: 'TODAY',
      ),
      const NotificationItemModel(
        id: '6',
        type: NotificationType.alert,
        title: 'Weekly Report — Jul 14',
        description: '8 signals · 6 wins · 1 loss · 1 breakeven · Win rate: 75.0%',
        timeAgo: '2d ago',
        dateGroup: 'TODAY',
      ),
    ]);
  }

  void clearAll() => notifications.clear();
}