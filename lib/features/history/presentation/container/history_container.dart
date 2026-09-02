import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/exceptions/app_exceptions.dart';
import '../../../signals/data/model/signal_model.dart';
import '../../../signals/signal_service.dart';

class HistoryContainer extends GetxController {
  // ─── Service ──────────────────────────────────────────────────────────────
  final SignalService _service = SignalService();

  // ─── Performance overview (from API) ─────────────────────────────────────
  final RxInt wins = 0.obs;
  final RxInt losses = 0.obs;
  final RxInt breakeven = 0.obs;
  final RxInt totalClosed = 0.obs;

  double get winRate {
    final total = wins.value + losses.value + breakeven.value;
    if (total == 0) return 0.0;
    return (wins.value / total) * 100;
  }

  // ─── History signals ──────────────────────────────────────────────────────
  final RxList<SignalHistoryModel> signals = <SignalHistoryModel>[].obs;
  final RxBool isLoading = false.obs;
  final RxString error = ''.obs;
  final RxString accessLevel = 'full'.obs;

  // ─── Search + filter ──────────────────────────────────────────────────────
  final TextEditingController searchController = TextEditingController();
  final RxString searchQuery = ''.obs;
  final RxString selectedFilter = 'All'.obs;
  final List<String> filters = const ['All', 'Win', 'Loss', 'Breakeven'];
  final RxBool isFilterPanelOpen = false.obs;
  Timer? _searchDebounce;

  /// The API already applies the result filter and search term.
  List<SignalHistoryModel> get filteredSignals => signals.toList();

  void onSearchChanged(String value) {
    searchQuery.value = value;
    _searchDebounce?.cancel();
    _searchDebounce = Timer(const Duration(milliseconds: 400), () {
      loadHistory(refresh: true);
    });
  }

  void selectFilter(String filter) {
    isFilterPanelOpen.value = false;
    if (selectedFilter.value == filter) return;
    selectedFilter.value = filter;
    loadHistory(refresh: true);
  }

  void toggleFilterPanel() =>
      isFilterPanelOpen.value = !isFilterPanelOpen.value;
  void closeFilterPanel() => isFilterPanelOpen.value = false;

  // ─── Lifecycle ────────────────────────────────────────────────────────────
  @override
  void onInit() {
    super.onInit();
    loadHistory();
  }

  // ─── Data loading ─────────────────────────────────────────────────────────
  Future<void> loadHistory({bool refresh = false}) async {
    if (refresh) signals.clear();
    isLoading.value = true;
    error.value = '';
    try {
      final result = await _service.getSignalHistory(
        result: selectedFilter.value,
        searchTerm: searchQuery.value.trim().isEmpty
            ? null
            : searchQuery.value.trim(),
      );
      signals.value = result.signals;
      totalClosed.value = result.totalClosedSignals;
      accessLevel.value = result.access;

      // Apply performance overview from backend
      final overview = result.performanceOverview;
      if (overview != null) {
        wins.value = (overview['wins'] as num?)?.toInt() ?? 0;
        losses.value = (overview['losses'] as num?)?.toInt() ?? 0;
        breakeven.value = (overview['breakeven'] as num?)?.toInt() ?? 0;
      } else {
        // Compute locally as fallback
        wins.value = signals.where((s) => s.isWin).length;
        losses.value = signals.where((s) => s.isLoss).length;
        breakeven.value = signals.where((s) => s.isBreakeven).length;
      }
    } on AppException catch (e) {
      error.value = e.message;
      _showError(e.message);
    } catch (e, s) {
      debugPrint('loadHistory failed: $e\n$s');
      error.value = 'Failed to load history. Please try again.';
      _showError(error.value);
    } finally {
      isLoading.value = false;
    }
  }

  // ─── Snackbar helper ──────────────────────────────────────────────────────
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

  // ─── Dispose ─────────────────────────────────────────────────────────────
  @override
  void onClose() {
    _searchDebounce?.cancel();
    searchController.dispose();
    super.onClose();
  }
}
