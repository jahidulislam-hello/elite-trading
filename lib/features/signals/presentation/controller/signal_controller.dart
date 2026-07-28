import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../data/model/market_hour_model.dart';
import '../../data/model/take_profile_model.dart';
import '../screen/all_singnal_screen.dart';
import '../screen/signal_details_screen.dart';

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

  //================================================================
  // SIGNAL DETAIL PAGE STATE
  //================================================================
  final Rx<SignalModel?> currentSignal = Rx<SignalModel?>(null);
  final RxBool isFavorite = false.obs;
  final RxInt selectedTabIndex = 0.obs; // 0 = Summary, 1 = Details
  final RxString selectedTimeframe = '1W'.obs;
  final List<String> timeframes = const ['1H', '24H', '3D', '1W', '1M', '6M'];

  void openSignalDetail(SignalModel signal) {
    currentSignal.value = signal;
    isFavorite.value = false;
    selectedTabIndex.value = 0;
    selectedTimeframe.value = '1W';
    Get.to(() => const SignalDetailScreen());
  }

  void toggleFavorite() => isFavorite.value = !isFavorite.value;
  void selectDetailTab(int index) => selectedTabIndex.value = index;
  void selectTimeframe(String tf) => selectedTimeframe.value = tf;

  void onEnableAlertsPressed() {
    final signal = currentSignal.value;
    if (signal == null) return;
    Get.snackbar('Alerts Enabled', 'You will be notified about ${signal.pair} updates');
  }

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
        tradeType: 'Swing Trade',
        publishedDate: 'Jul 23 · 09:15',
        previousClose: 67200.00,
        openingPrice: 67420.00,
        change24hPercent: 2.35,
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
        tradeType: 'Day Trade',
        publishedDate: 'Jul 23 · 11:40',
        previousClose: 67900.00,
        openingPrice: 67650.00,
        change24hPercent: -1.10,
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
        tradeType: 'Swing Trade',
        publishedDate: 'Jul 23 · 08:05',
        previousClose: 1.0830,
        openingPrice: 1.0845,
        change24hPercent: 0.62,
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
        tradeType: 'Swing Trade',
        publishedDate: 'Jul 23 · 06:50',
        previousClose: 2378.00,
        openingPrice: 2382.00,
        change24hPercent: 1.18,
      ),
    ]);
  }
}