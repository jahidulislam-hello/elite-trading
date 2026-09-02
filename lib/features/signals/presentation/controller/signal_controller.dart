import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/exceptions/app_exceptions.dart';
import '../../../../core/services/storage_service.dart';
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

  // ─── Search & category filter (server-side via API) ───────────────────────
  final TextEditingController searchController = TextEditingController();
  final RxString selectedCategory = 'All'.obs;
  final List<String> categories =
      const ['All', 'Forex', 'Crypto', 'Commodity', 'Index'];
  final RxString searchQuery = ''.obs;
  Timer? _searchDebounce;

  /// API already applies category + searchTerm — expose the list as-is.
  List<SignalModel> get filteredSignals => signals.toList();

  void selectCategory(String category) {
    if (selectedCategory.value == category) return;
    selectedCategory.value = category;
    loadSignals(refresh: true);
  }

  void onSearchChanged(String value) {
    searchQuery.value = value;
    _searchDebounce?.cancel();
    _searchDebounce = Timer(const Duration(milliseconds: 400), () {
      loadSignals(refresh: true);
    });
  }

  int get totalSignals => signals.length;

  // ─── Signal detail ────────────────────────────────────────────────────────
  final Rx<SignalDetailModel?> currentSignalDetail =
      Rx<SignalDetailModel?>(null);
  final Rx<SignalModel?> currentSignalListItem = Rx<SignalModel?>(null);
  final RxBool isDetailLoading = false.obs;
  final RxString detailError = ''.obs;

  final RxBool isFavorite = false.obs;
  final RxBool alertsEnabled = false.obs;
  final RxInt selectedTabIndex = 0.obs;
  final RxString selectedTimeframe = '1W'.obs;
  final List<String> timeframes = const ['1H', '24H', '3D', '1W', '1M', '6M'];

  final Rx<SignalChartData?> chartData = Rx<SignalChartData?>(null);
  final RxBool isChartLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    try {
      final storage = Get.find<StorageService>();
      final cached = storage.getString(StorageKeys.userName);
      if (cached != null && cached.isNotEmpty) {
        userName.value = cached;
      }
    } catch (_) {}
    loadMarketHours();
    loadSignals();
  }

  Future<void> loadMarketHours() async {
    isMarketHoursLoading.value = true;
    try {
      final hours = await _service.getMarketHours();
      marketHours.value = hours;
    } catch (_) {
      // Market hours are non-critical
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
        category: selectedCategory.value,
        searchTerm: searchQuery.value.trim().isEmpty
            ? null
            : searchQuery.value.trim(),
      );
      signals.value = result.signals;
      accessLevel.value = result.access;
    } on AppException catch (e) {
      signalsError.value = e.message;
    } catch (e, s) {
      debugPrint('loadSignals failed: $e\n$s');
      signalsError.value = 'Failed to load signals. Please try again.';
    } finally {
      isSignalsLoading.value = false;
    }
  }

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
      final tf = detail.chart.defaultTimeframe.isNotEmpty
          ? detail.chart.defaultTimeframe
          : '1W';
      selectedTimeframe.value = tf;
      await loadChart(id, timeframe: tf);
    } on AppException catch (e) {
      detailError.value = e.message;
    } catch (e, s) {
      debugPrint('loadSignalDetail failed: $e\n$s');
      detailError.value = 'Failed to load signal details.';
    } finally {
      isDetailLoading.value = false;
    }
  }

  Future<void> loadChart(String id, {String timeframe = '1W'}) async {
    isChartLoading.value = true;
    try {
      final data = await _service.getSignalChart(id, timeframe: timeframe);
      chartData.value = data;
      selectedTimeframe.value =
          data.timeframe.isNotEmpty ? data.timeframe : timeframe;
    } catch (e, s) {
      debugPrint('loadChart failed: $e\n$s');
    } finally {
      isChartLoading.value = false;
    }
  }

  void selectTimeframe(String tf) {
    if (selectedTimeframe.value == tf && chartData.value != null) {
      if (chartData.value!.candles.isNotEmpty) return;
    }
    selectedTimeframe.value = tf;
    final id = currentSignalListItem.value?.id ??
        currentSignalDetail.value?.header.id;
    if (id != null) loadChart(id, timeframe: tf);
  }

  void selectDetailTab(int index) => selectedTabIndex.value = index;

  Future<void> toggleFavorite() async {
    final id = currentSignalListItem.value?.id ??
        currentSignalDetail.value?.header.id;
    if (id == null) return;
    final newValue = !isFavorite.value;
    isFavorite.value = newValue;
    try {
      await _service.setFavorite(id, enabled: newValue);
    } catch (_) {
      isFavorite.value = !newValue;
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
    alertsEnabled.value = newValue;
    try {
      await _service.setAlerts(id, enabled: newValue);
      final asset = currentSignalListItem.value?.asset ??
          currentSignalDetail.value?.header.asset ??
          '';
      _showSuccess(newValue
          ? 'Alerts enabled for $asset.'
          : 'Alerts disabled for $asset.');
    } catch (_) {
      alertsEnabled.value = !newValue;
      _showError('Failed to update alerts.');
    }
  }

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

  @override
  void onClose() {
    _searchDebounce?.cancel();
    searchController.dispose();
    super.onClose();
  }
}
