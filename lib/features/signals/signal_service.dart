import '../../core/constants/api_endpoints.dart';
import '../../core/exceptions/app_exceptions.dart';
import '../../core/services/api_service.dart';
import '../../core/utils/access_parser.dart';
import 'data/model/signal_model.dart';

/// Handles all signal-related API calls for the mobile app.
///
/// Maps 1-to-1 with backend routes at:
///   backend/src/modules/basic_modules/signal/signal.route.ts  (app section)
class SignalService {
  final ApiService _api;

  SignalService({ApiService? apiService}) : _api = apiService ?? ApiService();

  // ──────────────────────────────────────────────────────────────────────────
  // 1. GET MARKET HOURS
  // GET /api/v1/signal/app/market-hours
  // ──────────────────────────────────────────────────────────────────────────
  Future<List<MarketHourModel>> getMarketHours() async {
    final response = await _api.get(ApiEndpoints.signalMarketHours);
    _assertSuccess(response.data, 'Failed to load market hours.');
    final list = response.data['data'] as List? ?? [];
    return list
        .map((e) => MarketHourModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  // ──────────────────────────────────────────────────────────────────────────
  // 2. GET APP SIGNALS (active feed)
  // GET /api/v1/signal/app?page=&limit=&category=&searchTerm=
  // ──────────────────────────────────────────────────────────────────────────
  Future<SignalListResult> getSignals({
    int page = 1,
    int limit = 20,
    String? category,
    String? searchTerm,
  }) async {
    final normalizedCategory = (category == null || category.isEmpty)
        ? 'all'
        : category.toLowerCase() == 'all'
            ? 'all'
            : category;
    final query = <String, dynamic>{
      'page': page,
      'limit': limit,
      'category': normalizedCategory,
      if (searchTerm != null && searchTerm.trim().isNotEmpty)
        'searchTerm': searchTerm.trim(),
    };
    final response =
        await _api.get(ApiEndpoints.signalsApp, queryParameters: query);
    _assertSuccess(response.data, 'Failed to load signals.');
    final data = response.data['data'] as Map<String, dynamic>? ?? {};
    final rawSignals = data['signals'] as List? ?? [];
    return SignalListResult(
      access: parseAccessLevel(data['access']),
      signals: rawSignals
          .map((e) => SignalModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      pagination: response.data['pagination'] as Map<String, dynamic>?,
    );
  }

  // ──────────────────────────────────────────────────────────────────────────
  // 3. GET SIGNAL HISTORY (closed signals)
  // GET /api/v1/signal/app/history?page=&limit=
  // ──────────────────────────────────────────────────────────────────────────
  Future<SignalHistoryResult> getSignalHistory({
    int page = 1,
    int limit = 20,
    String? result,
    String? searchTerm,
  }) async {
    final normalizedResult = (result ?? 'All').trim();
    final query = <String, dynamic>{
      'page': page,
      'limit': limit,
      if (normalizedResult.isNotEmpty &&
          normalizedResult.toLowerCase() != 'all')
        'result': normalizedResult,
      if (searchTerm != null && searchTerm.trim().isNotEmpty)
        'searchTerm': searchTerm.trim(),
    };
    final response =
        await _api.get(ApiEndpoints.signalsHistory, queryParameters: query);
    _assertSuccess(response.data, 'Failed to load signal history.');
    final data = response.data['data'] as Map<String, dynamic>? ?? {};
    final rawSignals = data['signals'] as List? ?? [];
    return SignalHistoryResult(
      access: parseAccessLevel(data['access']),
      performanceOverview:
          data['performanceOverview'] as Map<String, dynamic>?,
      signals: rawSignals
          .map((e) => SignalHistoryModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      totalClosedSignals: (data['totalClosedSignals'] as num?)?.toInt() ?? 0,
      pagination: response.data['pagination'] as Map<String, dynamic>?,
    );
  }

  // ──────────────────────────────────────────────────────────────────────────
  // 4. GET SIGNAL DETAIL
  // GET /api/v1/signal/app/:id
  // ──────────────────────────────────────────────────────────────────────────
  Future<SignalDetailModel> getSignalDetail(String id) async {
    final response = await _api.get(ApiEndpoints.signalDetail(id));
    _assertSuccess(response.data, 'Failed to load signal details.');
    final data = response.data['data'] as Map<String, dynamic>? ?? {};
    return SignalDetailModel.fromJson(data);
  }

  // ──────────────────────────────────────────────────────────────────────────
  // 5. GET SIGNAL CHART
  // GET /api/v1/signal/app/:id/chart?timeframe=1W
  // ──────────────────────────────────────────────────────────────────────────
  Future<SignalChartData> getSignalChart(
    String id, {
    String timeframe = '1W',
  }) async {
    final response = await _api.get(
      ApiEndpoints.signalChart(id),
      queryParameters: {'timeframe': timeframe},
    );
    _assertSuccess(response.data, 'Failed to load chart data.');
    final data = response.data['data'] as Map<String, dynamic>? ?? {};
    return SignalChartData.fromJson(data);
  }

  // ──────────────────────────────────────────────────────────────────────────
  // 6. GET SIGNAL MARKET DATA
  // GET /api/v1/signal/app/:id/market
  // ──────────────────────────────────────────────────────────────────────────
  Future<Map<String, dynamic>> getSignalMarket(String id) async {
    final response = await _api.get(ApiEndpoints.signalMarket(id));
    _assertSuccess(response.data, 'Failed to load market data.');
    return response.data['data'] as Map<String, dynamic>? ?? {};
  }

  // ──────────────────────────────────────────────────────────────────────────
  // 7. TOGGLE FAVORITE
  // POST /api/v1/signal/app/:id/favorite  body: { enabled }
  // ──────────────────────────────────────────────────────────────────────────
  Future<void> setFavorite(String id, {required bool enabled}) async {
    final response = await _api.post(
      ApiEndpoints.signalFavorite(id),
      data: {'enabled': enabled},
    );
    _assertSuccess(response.data, 'Failed to update favorite.');
  }

  // ──────────────────────────────────────────────────────────────────────────
  // 8. TOGGLE ALERTS
  // POST /api/v1/signal/app/:id/alerts  body: { enabled }
  // ──────────────────────────────────────────────────────────────────────────
  Future<void> setAlerts(String id, {required bool enabled}) async {
    final response = await _api.post(
      ApiEndpoints.signalAlerts(id),
      data: {'enabled': enabled},
    );
    _assertSuccess(response.data, 'Failed to update alerts.');
  }

  // ──────────────────────────────────────────────────────────────────────────
  // Helper
  // ──────────────────────────────────────────────────────────────────────────
  void _assertSuccess(dynamic responseData, String fallback) {
    if (responseData is Map<String, dynamic>) {
      if (responseData['success'] == false) {
        final msg = responseData['message'] as String?;
        throw ServerException(
            msg?.isNotEmpty == true ? msg! : fallback, null);
      }
    }
  }
}
