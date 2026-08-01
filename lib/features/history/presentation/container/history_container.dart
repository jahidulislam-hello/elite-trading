import 'package:get/get.dart';

import '../../data/model/history_signal_model.dart';

class HistoryContainer extends GetxController {
  final String userAvatar = 'asset/image/profile/alex.png';

  //---------------- Performance overview ----------------
  final RxInt wins = 4.obs;
  final RxInt losses = 2.obs;
  final RxInt breakeven = 1.obs;
  double get winRate {
    final total = wins.value + losses.value + breakeven.value;
    if (total == 0) return 0;
    return (wins.value / total) * 100;
  }

  //---------------- Signals ----------------
  final RxList<HistorySignalModel> signals = <HistorySignalModel>[].obs;
  int get totalClosed => signals.length;

  //---------------- Search + filter ----------------
  final RxString searchQuery = ''.obs;
  final RxString selectedFilter = 'All'.obs;
  final List<String> filters = const ['All', 'Win', 'Loss', 'BreakEvent'];
  final RxBool isFilterPanelOpen = false.obs;

  List<HistorySignalModel> get filteredSignals {
    return signals.where((s) {
      final matchesSearch = searchQuery.value.isEmpty ||
          s.pair.toLowerCase().contains(searchQuery.value.toLowerCase());

      bool matchesFilter;
      switch (selectedFilter.value) {
        case 'Win':
          matchesFilter = s.result == HistoryResult.win;
          break;
        case 'Loss':
          matchesFilter = s.result == HistoryResult.loss;
          break;
        case 'Crypto':
          matchesFilter = s.categoryLabel.toLowerCase() == 'crypto';
          break;
        default:
          matchesFilter = true;
      }
      return matchesSearch && matchesFilter;
    }).toList();
  }

  void onSearchChanged(String value) => searchQuery.value = value;
  void selectFilter(String filter) {
    selectedFilter.value = filter;
    isFilterPanelOpen.value = false;
  }

  void toggleFilterPanel() => isFilterPanelOpen.value = !isFilterPanelOpen.value;
  void closeFilterPanel() => isFilterPanelOpen.value = false;

  @override
  void onInit() {
    super.onInit();
    _loadDummyHistory();
  }

  void _loadDummyHistory() {
    signals.assignAll([
      const HistorySignalModel(
        id: '1',
        pair: 'NAS100',
        categoryLabel: 'Index',
        side: HistorySide.buy,
        result: HistoryResult.win,
        profitPercent: 2.02,
        entryPrice: 19849.00,
        exitPrice: 20248.00,
        riskReward: '1:1.4',
        duration: '2 days',
        closedDate: 'Closed Jul 18, 2026',
      ),
      const HistorySignalModel(
        id: '2',
        pair: 'USD/CAD',
        categoryLabel: 'Forex',
        side: HistorySide.sell,
        result: HistoryResult.win,
        profitPercent: 0.45,
        entryPrice: 1.36230,
        exitPrice: 1.36280,
        riskReward: '1:1.4',
        duration: '18h',
        closedDate: 'Closed Jul 17, 2026',
      ),
      const HistorySignalModel(
        id: '3',
        pair: 'ETH/USDT',
        categoryLabel: 'Crypto',
        side: HistorySide.buy,
        result: HistoryResult.loss,
        profitPercent: -1.22,
        entryPrice: 3280.00,
        exitPrice: 3240.00,
        riskReward: '1:1.4',
        duration: '5h',
        closedDate: 'Closed Jul 16, 2026',
      ),
      const HistorySignalModel(
        id: '4',
        pair: 'GBP/JPY',
        categoryLabel: 'Forex',
        side: HistorySide.buy,
        result: HistoryResult.breakeven,
        profitPercent: 0.0,
        entryPrice: 198.50,
        exitPrice: 198.50,
        riskReward: '1:2.0',
        duration: '1 day',
        closedDate: 'Closed Jul 15, 2026',
      ),
    ]);
  }
}