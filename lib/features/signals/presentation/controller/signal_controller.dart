import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/exceptions/app_exceptions.dart';
import '../../data/model/signal_model.dart';
import '../../signal_service.dart';
import '../screen/all_singnal_screen.dart';
import '../screen/signal_details_screen.dart';

class SignalController extends GetxController {
  // ─── Service ──────────────────────────────────────────────────────────────
  final SignalService _service = SignalService();

  // ─── User display name (loaded from auth/profile later) ──────────────────
  final RxString userName = 'Trader'.obs;

  // ─── Market hours ────────────────────────────────────────────────────────
  final RxList<MarketHourModel> marketHours = <MarketHourModel>[].obs;
  final RxBool isMarketHoursLoading = false.obs;

  // ─── Signal feed ──────────────────────────────────────────────────────────
  final RxList<SignalModel> signals = <SignalModel>[].obs;
  final RxBool isSignalsLoading = false.obs;
  final RxString signalsError = ''.obs;
  final RxString accessLevel = 'full'.obs; // 'full' | 'limited' | etc.

  // ─── Search & category filter ─────────────────────────────────────────────
  final TextEditingController searchController = TextEditingController();
  final RxString selectedCategory = 'All'.obs;
  final List<String> categories = const ['All', 'Forex', 'Crypto', 'Commodity', 'Index'];
  final RxString searchQuery = ''.obs;

  List<SignalModel> get filteredSignals {
    return signals.where((s) {
      final matchesCategory = selectedCategory.value == 'All' ||
          s.category.toLowerCase() == selectedCategory.value.toLowerCase();
      final matchesSearch = searchQuery.value.isEmpty ||
          s.asset.toLowerCase().contains(searchQuery.value.toLowerCase());
      return matchesCategory && matchesSearch;
    }).toList();
  }

  void selectCategory(String category) => selectedCategory.value = category;
  void onSearchChanged(String value) => searchQuery.value = value;

  int get totalSignals => signals.length;

  // ─── Signal detail ────────────────────────────────────────────────────────
  final Rx<SignalDetailModel?> currentSignalDetail =
      Rx<SignalDetailModel?>(null);
  // Keep the list-item ref for quick access to basic info before detail loads
  final Rx<SignalModel?> currentSignalListItem = Rx<SignalModel?>(null);
  final RxBool isDetailLoading = false.obs;
  final RxString detailError = ''.obs;

  final RxBool isFavorite = false.obs;
  final RxBool alertsEnabled = false.obs;
  final RxInt selectedTabIndex = 0.obs; // 0 = Summary, 1 = Details
  final RxString selectedTimeframe = '1W'.obs;
  final List<String> timeframes = const ['1H', '24H', '3D', '1W', '1M', '6M'];

  // Chart data
  final Rx<SignalChartData?> chartData = Rx<SignalChartData?>(null);
  final RxBool isChartLoading = false.obs;

  // ─── Lifecycle ────────────────────────────────────────────────────────────
  @override
  void onInit() {
    super.onInit();
    loadMarketHours();
    loadSignals();
  }

  // ─── Data loading ─────────────────────────────────────────────────────────

  Future<void> loadMarketHours() async {
    isMarketHoursLoading.value = true;
    try {
      final hours = await _service.getMarketHours();
      marketHours.value = hours;
    } catch (_) {
      // Market hours are non-critical — silently fall back to empty
    } finally {
      isMarketHoursLoading.value = false;
    }
  }

  Future<void> loadSignals({bool refresh = false}) async {
    if (refresh) signals.clear();
    isSignalsLoading.value = true;
    signalsError.value = '';
    try {
      final result = await _service.getSignals(
        category: selectedCategory.value == 'All' ? null : selectedCategory.value,
      );
      signals.value = result.signals;
      accessLevel.value = result.access;
    } on AppException catch (e) {
      signalsError.value = e.message;
    } catch (_) {
      signalsError.value = 'Failed to load signals. Please try again.';
    } finally {
      isSignalsLoading.value = false;
    }
  }

  // ─── Navigation ───────────────────────────────────────────────────────────

  void onSeeAllSignalsPressed() => Get.to(() => const AllSingnalScreen());

  void openSignalDetail(SignalModel listItem) {
    currentSignalListItem.value = listItem;
    currentSignalDetail.value = null;
    isFavorite.value = false;
    alertsEnabled.value = false;
    selectedTabIndex.value = 0;
    selectedTimeframe.value = '1W';
    chartData.value = null;
    Get.to(() => const SignalDetailScreen());
    _loadSignalDetail(listItem.id);
  }

  Future<void> _loadSignalDetail(String id) async {
    isDetailLoading.value = true;
    detailError.value = '';
    try {
      final detail = await _service.getSignalDetail(id);
      currentSignalDetail.value = detail;
      isFavorite.value = detail.header.isFavorite;
      alertsEnabled.value = detail.userActions.alertsEnabled;
      // Load chart for the default timeframe
      await loadChart(id, timeframe: detail.chart.defaultTimeframe);
    } on AppException catch (e) {
      detailError.value = e.message;
    } catch (_) {
      detailError.value = 'Failed to load signal details.';
    } finally {
      isDetailLoading.value = false;
    }
  }

  // ─── Chart ────────────────────────────────────────────────────────────────

  Future<void> loadChart(String id, {String timeframe = '1W'}) async {
    isChartLoading.value = true;
    try {
      final data = await _service.getSignalChart(id, timeframe: timeframe);
      chartData.value = data;
    } catch (_) {
      // Chart is non-critical
    } finally {
      isChartLoading.value = false;
    }
  }

  void selectTimeframe(String tf) {
    selectedTimeframe.value = tf;
    final id = currentSignalListItem.value?.id ??
        currentSignalDetail.value?.header.id;
    if (id != null) loadChart(id, timeframe: tf);
  }

  // ─── User actions ─────────────────────────────────────────────────────────

  void selectDetailTab(int index) => selectedTabIndex.value = index;

  Future<void> toggleFavorite() async {
    final id = currentSignalListItem.value?.id ??
        currentSignalDetail.value?.header.id;
    if (id == null) return;
    final newValue = !isFavorite.value;
    isFavorite.value = newValue; // optimistic
    try {
      await _service.setFavorite(id, enabled: newValue);
    } catch (_) {
      isFavorite.value = !newValue; // revert on error
      _showError('Failed to update favorite.');
    }
  }

  Future<void> onEnableAlertsPressed() async {
    final id = currentSignalListItem.value?.id ??
        currentSignalDetail.value?.header.id;
    final detail = currentSignalDetail.value;
    if (id == null) return;
    if (detail != null && !detail.userActions.canEnableAlerts) {
      _showError('Alerts cannot be enabled for this signal.');
      return;
    }
    final newValue = !alertsEnabled.value;
    alertsEnabled.value = newValue; // optimistic
    try {
      await _service.setAlerts(id, enabled: newValue);
      final asset = currentSignalListItem.value?.asset ??
          currentSignalDetail.value?.header.asset ?? '';
      _showSuccess(newValue
          ? 'Alerts enabled for $asset.'
          : 'Alerts disabled for $asset.');
    } catch (_) {
      alertsEnabled.value = !newValue; // revert
      _showError('Failed to update alerts.');
    }
  }

  // ─── Snackbar helpers ─────────────────────────────────────────────────────

  void _showError(String msg) {
    if (Get.isSnackbarOpen) Get.closeAllSnackbars();
    Get.snackbar(
      'Error',
      msg,
      backgroundColor: const Color(0xFF3A1010),
      colorText: Colors.white,
      snackPosition: SnackPosition.TOP,
      margin: const EdgeInsets.all(16),
      borderRadius: 12,
      duration: const Duration(seconds: 4),
      icon: const Icon(Icons.error_outline, color: Colors.redAccent),
    );
  }

  void _showSuccess(String msg) {
    if (Get.isSnackbarOpen) Get.closeAllSnackbars();
    Get.snackbar(
      'Success',
      msg,
      backgroundColor: const Color(0xFF0F3A1A),
      colorText: Colors.white,
      snackPosition: SnackPosition.TOP,
      margin: const EdgeInsets.all(16),
      borderRadius: 12,
      duration: const Duration(seconds: 3),
      icon: const Icon(Icons.check_circle_outline, color: Colors.greenAccent),
    );
  }

  // ─── Dispose ──────────────────────────────────────────────────────────────

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }
}
