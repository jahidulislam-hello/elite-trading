import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../data/model/market_hour_model.dart';
import '../../data/model/take_profile_model.dart';
import '../screen/all_singnal_screen.dart';


class SignalController extends GetxController {
  //---------------- Greeting ----------------
  final String userName = 'Alex Thompson';
  final String userAvatar = 'asset/image/profile/alex.png';
  final RxBool hasNotification = true.obs;

  //---------------- Global market hours ----------------
  final List<MarketHourModel> marketHours = const [
    MarketHourModel(flag: '🇦🇺', name: 'Sydney', isOpen: false, time: '18:17:35', utcRange: '22:00-07:00 UTC'),
    MarketHourModel(flag: '🇯🇵', name: 'Tokyo', isOpen: true, time: '18:17:35', utcRange: '22:00-07:00 UTC'),
    MarketHourModel(flag: '🇬🇧', name: 'London', isOpen: true, time: '18:17:35', utcRange: '22:00-07:00 UTC'),
    MarketHourModel(flag: '🇺🇸', name: 'New York', isOpen: false, time: '18:17:35', utcRange: '22:00-07:00 UTC'),
  ];

  //---------------- Signals ----------------
  final RxList<SignalModel> signals = <SignalModel>[].obs;
  int get totalSignals => signals.length;

  //---------------- All signal screen: category + search ----------------

  final TextEditingController searchController = TextEditingController();
  final RxString selectedCategory = 'All'.obs;
  final List<String> categories = const ['All', 'Forex', 'Crypto', 'Gold'];
  final RxString searchQuery = ''.obs;

  List<SignalModel> get filteredSignals {
    return signals.where((s) {
      final matchesCategory = selectedCategory.value == 'All' ||
          s.categoryLabel.toLowerCase() == selectedCategory.value.toLowerCase();
      final matchesSearch = searchQuery.value.isEmpty ||
          s.pair.toLowerCase().contains(searchQuery.value.toLowerCase());
      return matchesCategory && matchesSearch;
    }).toList();
  }

  void selectCategory(String category) => selectedCategory.value = category;
  void onSearchChanged(String value) => searchQuery.value = value;

  //---------------- Bottom nav ----------------
  final RxInt currentNavIndex = 0.obs;
  void selectNavIndex(int index) => currentNavIndex.value = index;

  void onSeeAllSignalsPressed() => Get.to(() => const AllSingnalScreen());

  @override
  void onInit() {
    super.onInit();
    _loadDummySignals();
  }

  void _loadDummySignals() {
    signals.assignAll([
      const SignalModel(
        id: '1',
        pair: 'BTC/USDT',
        categoryLabel: 'Crypto',
        subtitleLabel: 'Cryptocurrency',
        type: SignalType.buy,
        isLive: true,
        entryPrice: 67420.00,
        stopLoss: 65800.00,
        stopLossPercent: -2.40,
        takeProfits: [
          TakeProfitModel(label: 'TP1', price: 69000.00, isHit: true),
          TakeProfitModel(label: 'TP2', price: 71500.00),
          TakeProfitModel(label: 'TP3', price: 74500.00),
        ],
        riskReward: '1:2.0',
        timeAgo: '2h ago',
      ),
      const SignalModel(
        id: '2',
        pair: 'BTC/USDT',
        categoryLabel: 'Crypto',
        subtitleLabel: 'Cryptocurrency',
        type: SignalType.sell,
        isLive: false,
        entryPrice: 67420.00,
        stopLoss: 65800.00,
        stopLossPercent: -2.40,
        takeProfits: [
          TakeProfitModel(label: 'TP1', price: 69000.00, isHit: true),
          TakeProfitModel(label: 'TP2', price: 71500.00),
          TakeProfitModel(label: 'TP3', price: 74500.00),
        ],
        riskReward: '1:2.0',
        timeAgo: '2h ago',
      ),
      const SignalModel(
        id: '3',
        pair: 'EUR/USD',
        categoryLabel: 'Forex',
        subtitleLabel: 'Forex',
        type: SignalType.buy,
        isLive: true,
        entryPrice: 1.0850,
        stopLoss: 1.0800,
        stopLossPercent: -0.46,
        takeProfits: [
          TakeProfitModel(label: 'TP1', price: 1.0900, isHit: true),
          TakeProfitModel(label: 'TP2', price: 1.0950),
          TakeProfitModel(label: 'TP3', price: 1.1000),
        ],
        riskReward: '1:2.0',
        timeAgo: '3h ago',
      ),
      const SignalModel(
        id: '4',
        pair: 'XAU/USD',
        categoryLabel: 'Gold',
        subtitleLabel: 'Metals',
        type: SignalType.buy,
        isLive: true,
        entryPrice: 2385.00,
        stopLoss: 2365.00,
        stopLossPercent: -0.84,
        takeProfits: [
          TakeProfitModel(label: 'TP1', price: 2410.00, isHit: true),
          TakeProfitModel(label: 'TP2', price: 2430.00),
          TakeProfitModel(label: 'TP3', price: 2450.00),
        ],
        riskReward: '1:2.5',
        timeAgo: '5h ago',
      ),
    ]);
  }
}