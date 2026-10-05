/// Signal models matching the backend formatter output from:
///   backend/src/modules/basic_modules/signal/signal.formatter.ts
///   backend/src/modules/basic_modules/signal/signal.interface.ts

// ─── Market Hours ─────────────────────────────────────────────────────────

class MarketHourModel {
  final String id;
  final String name;
  final String timezone;
  final bool isOpen;

  /// Current wall-clock time in the market's timezone, e.g. `18:15:55`.
  final String? localTime;

  /// Trading session expressed in UTC, e.g. `22:00-07:00 UTC`.
  final String? sessionUtc;
  final String flag;

  const MarketHourModel({
    this.id = '',
    required this.name,
    this.timezone = '',
    required this.isOpen,
    this.localTime,
    this.sessionUtc,
    required this.flag,
  });

  /// Session range without the `UTC` suffix, e.g. `22:00 – 07:00`.
  String get sessionRangeLabel {
    final raw = sessionUtc?.replaceAll('UTC', '').trim();
    if (raw == null || raw.isEmpty) return '—';
    final parts = raw.split('-');
    if (parts.length != 2) return raw;
    return '${parts[0].trim()} – ${parts[1].trim()}';
  }

  /// Local time trimmed to `HH:mm`, prefixed for display.
  String get localTimeLabel {
    final raw = localTime?.trim();
    if (raw == null || raw.isEmpty) return '';
    final parts = raw.split(':');
    final hhmm = parts.length >= 2 ? '${parts[0]}:${parts[1]}' : raw;
    return 'Local $hhmm';
  }

  factory MarketHourModel.fromJson(Map<String, dynamic> json) {
    // Backend returns:
    // { id, name, timezone, status, isOpen, localTime, sessionUtc }
    final name = json['name'] as String? ?? '';
    return MarketHourModel(
      id: json['id'] as String? ?? '',
      name: name,
      timezone: json['timezone'] as String? ?? '',
      isOpen: json['isOpen'] as bool? ??
          (json['status'] as String?)?.toUpperCase() == 'OPEN',
      localTime: json['localTime'] as String?,
      sessionUtc: json['sessionUtc'] as String?,
      flag: _flagForMarket(json['id'] as String? ?? name),
    );
  }

  static String _flagForMarket(String key) {
    switch (key.toLowerCase().replaceAll('_', ' ')) {
      case 'sydney':
        return '🇦🇺';
      case 'tokyo':
        return '🇯🇵';
      case 'london':
        return '🇬🇧';
      case 'new york':
        return '🇺🇸';
      default:
        return '🌐';
    }
  }
}

// ─── Take Profit ─────────────────────────────────────────────────────────

class TakeProfitModel {
  final String key; // tp1, tp2, tp3
  final int level;
  final String label;
  final double? price;
  final String priceLabel;
  final String status; // PENDING | HIT | FILLED | CANCELLED
  final double? percentFromEntry;
  final String? percentLabel;
  final String? hitAt;

  const TakeProfitModel({
    required this.key,
    required this.level,
    required this.label,
    this.price,
    required this.priceLabel,
    required this.status,
    this.percentFromEntry,
    this.percentLabel,
    this.hitAt,
  });

  bool get isHit => status == 'HIT' || status == 'FILLED';

  factory TakeProfitModel.fromJson(Map<String, dynamic> json) {
    return TakeProfitModel(
      key: json['key'] as String? ?? 'tp1',
      level: json['level'] as int? ?? 1,
      label: json['label'] as String? ?? 'TP1',
      price: (json['price'] as num?)?.toDouble(),
      priceLabel: json['priceLabel'] as String? ?? '',
      status: json['status'] as String? ?? 'PENDING',
      percentFromEntry: (json['percentFromEntry'] as num?)?.toDouble(),
      percentLabel: json['percentLabel'] as String?,
      hitAt: json['hitAt'] as String?,
    );
  }
}

// ─── Level (Entry / Stop Loss) ────────────────────────────────────────────

class LevelModel {
  final double? price;
  final String priceLabel;
  final String label;
  final String status;
  final double? percentFromEntry;
  final String? percentLabel;

  const LevelModel({
    this.price,
    required this.priceLabel,
    required this.label,
    required this.status,
    this.percentFromEntry,
    this.percentLabel,
  });

  factory LevelModel.fromJson(Map<String, dynamic> json) {
    return LevelModel(
      price: (json['price'] as num?)?.toDouble(),
      priceLabel: json['priceLabel'] as String? ?? '',
      label: json['label'] as String? ?? '',
      status: json['status'] as String? ?? 'PENDING',
      percentFromEntry: (json['percentFromEntry'] as num?)?.toDouble(),
      percentLabel: json['percentLabel'] as String?,
    );
  }
}

// ─── Signal (list item — formatSignalForApp) ─────────────────────────────

class SignalModel {
  final String id;
  final String asset; // pair e.g. BTC/USDT
  final String category; // Forex | Crypto | Commodity | Index
  final String categoryLabel;
  final String type; // Scalp | Swing | Intraday | Long-term
  final String direction; // BUY | SELL
  final String entry;
  final String sl;
  final String? slPercent;
  final String tp1;
  final String? tp2;
  final String? tp3;
  final String? tp1Percent;
  final String? riskReward;
  final String status; // Active | Draft | Scheduled | Closed | Archived
  final DateTime? publishedAt;
  final String publishedLabel;
  final String timeAgo;
  final String notes;
  final bool isGoldSignal;

  const SignalModel({
    required this.id,
    required this.asset,
    required this.category,
    required this.categoryLabel,
    required this.type,
    required this.direction,
    required this.entry,
    required this.sl,
    this.slPercent,
    required this.tp1,
    this.tp2,
    this.tp3,
    this.tp1Percent,
    this.riskReward,
    required this.status,
    this.publishedAt,
    required this.publishedLabel,
    required this.timeAgo,
    required this.notes,
    required this.isGoldSignal,
  });

  bool get isBuy => direction == 'BUY';
  bool get isActive => status == 'Active';

  factory SignalModel.fromJson(Map<String, dynamic> json) {
    final pubRaw = json['publishedAt'] ?? json['pub'];
    DateTime? publishedAt;
    if (pubRaw is String) {
      publishedAt = DateTime.tryParse(pubRaw);
    } else if (pubRaw is int) {
      publishedAt = DateTime.fromMillisecondsSinceEpoch(pubRaw);
    }

    return SignalModel(
      id: json['id']?.toString() ?? json['_id']?.toString() ?? '',
      asset: json['asset']?.toString() ?? '',
      category: json['category']?.toString() ??
          json['cat']?.toString() ??
          '',
      categoryLabel: json['categoryLabel']?.toString() ??
          json['category']?.toString() ??
          json['cat']?.toString() ??
          '',
      type: json['type']?.toString() ?? '',
      direction: json['direction']?.toString() ??
          json['dir']?.toString() ??
          'BUY',
      entry: json['entry']?.toString() ?? '',
      sl: json['sl']?.toString() ?? '',
      slPercent: json['slPercent']?.toString(),
      tp1: json['tp1']?.toString() ?? '',
      tp2: json['tp2']?.toString(),
      tp3: json['tp3']?.toString(),
      tp1Percent: json['tp1Percent']?.toString(),
      riskReward: json['riskReward']?.toString(),
      status: json['status']?.toString() ?? 'Active',
      publishedAt: publishedAt,
      publishedLabel: json['publishedLabel']?.toString() ??
          json['pub']?.toString() ??
          '',
      timeAgo: json['timeAgo']?.toString() ?? '',
      notes: json['notes']?.toString() ?? '',
      isGoldSignal: json['isGoldSignal'] == true,
    );
  }
}

// ─── Signal Detail (getSignalAppDetail → formatSignalDetailForApp) ────────

class SignalDetailModel {
  final SignalDetailHeader header;
  final SignalLiveData live;
  final SignalSummary summary;
  final SignalDetails details;
  final SignalUserActions userActions;
  final SignalChart chart;

  const SignalDetailModel({
    required this.header,
    required this.live,
    required this.summary,
    required this.details,
    required this.userActions,
    required this.chart,
  });

  factory SignalDetailModel.fromJson(Map<String, dynamic> json) {
    return SignalDetailModel(
      header: SignalDetailHeader.fromJson(
          json['header'] as Map<String, dynamic>? ?? {}),
      live: SignalLiveData.fromJson(
          json['live'] as Map<String, dynamic>? ?? {}),
      summary: SignalSummary.fromJson(
          json['summary'] as Map<String, dynamic>? ?? {}),
      details: SignalDetails.fromJson(
          json['details'] as Map<String, dynamic>? ?? {}),
      userActions: SignalUserActions.fromJson(
          json['userActions'] as Map<String, dynamic>? ?? {}),
      chart: SignalChart.fromJson(
          json['chart'] as Map<String, dynamic>? ?? {}),
    );
  }
}

class SignalDetailHeader {
  final String id;
  final String asset;
  final String baseAsset;
  final String quoteAsset;
  final String direction;
  final String directionLabel;
  final String status;
  final bool isGoldSignal;
  final bool isFavorite;

  const SignalDetailHeader({
    required this.id,
    required this.asset,
    required this.baseAsset,
    required this.quoteAsset,
    required this.direction,
    required this.directionLabel,
    required this.status,
    required this.isGoldSignal,
    required this.isFavorite,
  });

  bool get isBuy => direction == 'BUY';

  factory SignalDetailHeader.fromJson(Map<String, dynamic> json) {
    return SignalDetailHeader(
      id: json['id']?.toString() ?? '',
      asset: json['asset'] as String? ?? '',
      baseAsset: json['baseAsset'] as String? ?? '',
      quoteAsset: json['quoteAsset'] as String? ?? '',
      direction: json['direction'] as String? ?? 'BUY',
      directionLabel: json['directionLabel'] as String? ?? '',
      status: json['status'] as String? ?? '',
      isGoldSignal: json['isGoldSignal'] as bool? ?? false,
      isFavorite: json['isFavorite'] as bool? ?? false,
    );
  }
}

class SignalLiveData {
  final double? currentPrice;
  final String currency;
  final double? change24h;
  final String? change24hLabel;
  final String trend;
  final String lastUpdatedAt;

  const SignalLiveData({
    this.currentPrice,
    required this.currency,
    this.change24h,
    this.change24hLabel,
    required this.trend,
    required this.lastUpdatedAt,
  });

  factory SignalLiveData.fromJson(Map<String, dynamic> json) {
    return SignalLiveData(
      currentPrice: (json['currentPrice'] as num?)?.toDouble(),
      currency: json['currency'] as String? ?? 'USD',
      change24h: (json['change24h'] as num?)?.toDouble(),
      change24hLabel: json['change24hLabel'] as String?,
      trend: json['trend'] as String? ?? 'up',
      lastUpdatedAt: json['lastUpdatedAt'] as String? ?? '',
    );
  }
}

class SignalSummary {
  final SignalStatistics statistics;
  final SignalProTip proTip;

  const SignalSummary({required this.statistics, required this.proTip});

  factory SignalSummary.fromJson(Map<String, dynamic> json) {
    return SignalSummary(
      statistics: SignalStatistics.fromJson(
          json['statistics'] as Map<String, dynamic>? ?? {}),
      proTip: SignalProTip.fromJson(
          json['proTip'] as Map<String, dynamic>? ?? {}),
    );
  }
}

class SignalStatistics {
  final double? previousClose;
  final double? openingPrice;
  final double? returns24h;
  final String? returns24hLabel;

  const SignalStatistics({
    this.previousClose,
    this.openingPrice,
    this.returns24h,
    this.returns24hLabel,
  });

  factory SignalStatistics.fromJson(Map<String, dynamic> json) {
    return SignalStatistics(
      previousClose: (json['previousClose'] as num?)?.toDouble(),
      openingPrice: (json['openingPrice'] as num?)?.toDouble(),
      returns24h: (json['returns24h'] as num?)?.toDouble(),
      returns24hLabel: json['returns24hLabel'] as String?,
    );
  }
}

class SignalProTip {
  final String title;
  final String message;

  const SignalProTip({required this.title, required this.message});

  factory SignalProTip.fromJson(Map<String, dynamic> json) {
    return SignalProTip(
      title: json['title'] as String? ?? 'Pro Tip',
      message: json['message'] as String? ?? '',
    );
  }
}

class SignalDetails {
  final SignalOverview overview;
  final SignalLevels levels;
  final String notes;
  final String? closeResult;
  final String? closePnl;

  const SignalDetails({
    required this.overview,
    required this.levels,
    required this.notes,
    this.closeResult,
    this.closePnl,
  });

  factory SignalDetails.fromJson(Map<String, dynamic> json) {
    return SignalDetails(
      overview: SignalOverview.fromJson(
          json['overview'] as Map<String, dynamic>? ?? {}),
      levels: SignalLevels.fromJson(
          json['levels'] as Map<String, dynamic>? ?? {}),
      notes: json['notes'] as String? ?? '',
      closeResult: json['closeResult'] as String?,
      closePnl: json['closePnl'] as String?,
    );
  }
}

class SignalOverview {
  final String asset;
  final String marketCategory;
  final String category;
  final String tradeType;
  final String type;
  final String direction;
  final String? riskRewardRatio;
  final String publishedLabel;
  final String timeAgo;

  const SignalOverview({
    required this.asset,
    required this.marketCategory,
    required this.category,
    required this.tradeType,
    required this.type,
    required this.direction,
    this.riskRewardRatio,
    required this.publishedLabel,
    required this.timeAgo,
  });

  factory SignalOverview.fromJson(Map<String, dynamic> json) {
    return SignalOverview(
      asset: json['asset'] as String? ?? '',
      marketCategory: json['marketCategory'] as String? ?? '',
      category: json['category'] as String? ?? '',
      tradeType: json['tradeType'] as String? ?? '',
      type: json['type'] as String? ?? '',
      direction: json['direction'] as String? ?? '',
      riskRewardRatio: json['riskRewardRatio'] as String?,
      publishedLabel: json['publishedLabel'] as String? ?? '',
      timeAgo: json['timeAgo'] as String? ?? '',
    );
  }
}

class SignalLevels {
  final LevelModel entry;
  final LevelModel stopLoss;
  final List<TakeProfitModel> takeProfits;

  const SignalLevels({
    required this.entry,
    required this.stopLoss,
    required this.takeProfits,
  });

  factory SignalLevels.fromJson(Map<String, dynamic> json) {
    final tpList = json['takeProfits'] as List? ?? [];
    return SignalLevels(
      entry: LevelModel.fromJson(
          json['entry'] as Map<String, dynamic>? ?? {}),
      stopLoss: LevelModel.fromJson(
          json['stopLoss'] as Map<String, dynamic>? ?? {}),
      takeProfits: tpList
          .map((e) => TakeProfitModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

class SignalUserActions {
  final bool alertsEnabled;
  final bool canEnableAlerts;
  final bool canFavorite;

  const SignalUserActions({
    required this.alertsEnabled,
    required this.canEnableAlerts,
    required this.canFavorite,
  });

  factory SignalUserActions.fromJson(Map<String, dynamic> json) {
    return SignalUserActions(
      alertsEnabled: json['alertsEnabled'] as bool? ?? false,
      canEnableAlerts: json['canEnableAlerts'] as bool? ?? true,
      canFavorite: json['canFavorite'] as bool? ?? true,
    );
  }
}

class SignalChart {
  final String defaultTimeframe;
  final List<String> availableTimeframes;

  const SignalChart({
    required this.defaultTimeframe,
    required this.availableTimeframes,
  });

  factory SignalChart.fromJson(Map<String, dynamic> json) {
    return SignalChart(
      defaultTimeframe: json['defaultTimeframe'] as String? ?? '1W',
      availableTimeframes:
          List<String>.from(json['availableTimeframes'] as List? ?? []),
    );
  }
}

// ─── Chart Candle ─────────────────────────────────────────────────────────

class CandleModel {
  final int time;
  final double open;
  final double high;
  final double low;
  final double close;

  const CandleModel({
    required this.time,
    required this.open,
    required this.high,
    required this.low,
    required this.close,
  });

  factory CandleModel.fromJson(Map<String, dynamic> json) {
    return CandleModel(
      time: (json['time'] as num?)?.toInt() ?? 0,
      open: (json['open'] as num?)?.toDouble() ?? 0,
      high: (json['high'] as num?)?.toDouble() ?? 0,
      low: (json['low'] as num?)?.toDouble() ?? 0,
      close: (json['close'] as num?)?.toDouble() ?? 0,
    );
  }
}

class ChartOverlays {
  final double? entry;
  final double? stopLoss;
  final List<double> takeProfits;

  const ChartOverlays({
    this.entry,
    this.stopLoss,
    this.takeProfits = const [],
  });

  factory ChartOverlays.fromJson(Map<String, dynamic>? json) {
    if (json == null) return const ChartOverlays();
    final tps = json['takeProfits'] as List? ?? [];
    return ChartOverlays(
      entry: (json['entry'] as num?)?.toDouble(),
      stopLoss: (json['stopLoss'] as num?)?.toDouble(),
      takeProfits: tps
          .map((e) => (e as num?)?.toDouble())
          .whereType<double>()
          .toList(),
    );
  }
}

class SignalChartData {
  final String timeframe;
  final String symbol;
  final List<CandleModel> candles;
  final ChartOverlays overlays;
  final String? source;

  const SignalChartData({
    required this.timeframe,
    required this.symbol,
    required this.candles,
    this.overlays = const ChartOverlays(),
    this.source,
  });

  factory SignalChartData.fromJson(Map<String, dynamic> json) {
    final rawCandles = json['candles'] as List? ?? [];
    return SignalChartData(
      timeframe: json['timeframe'] as String? ?? '1W',
      symbol: json['symbol'] as String? ?? '',
      candles: rawCandles
          .map((e) => CandleModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      overlays: ChartOverlays.fromJson(
          json['overlays'] as Map<String, dynamic>?),
      source: json['source'] as String?,
    );
  }
}

// ─── Signal History ───────────────────────────────────────────────────────

class SignalHistoryModel {
  final String id;
  final String asset;
  final String category;
  final String categoryLabel;
  final String direction;
  final String type;
  final String timeframeLabel;
  final String actionLabel;
  final String? riskRewardRatio;
  final double? entryPrice;
  final String entryPriceLabel;
  final double? exitPrice;
  final String exitPriceLabel;
  final String priceMovementLabel;
  final double? pnlPercent;
  final String? pnlLabel;
  final String? closeResult; // Win | Loss | Breakeven
  final String? outcomeLabel;
  final bool isWin;
  final bool isLoss;
  final bool isBreakeven;
  final String? duration;
  final String closedLabel;
  final String notes;

  const SignalHistoryModel({
    required this.id,
    required this.asset,
    required this.category,
    required this.categoryLabel,
    required this.direction,
    required this.type,
    required this.timeframeLabel,
    required this.actionLabel,
    this.riskRewardRatio,
    this.entryPrice,
    required this.entryPriceLabel,
    this.exitPrice,
    required this.exitPriceLabel,
    required this.priceMovementLabel,
    this.pnlPercent,
    this.pnlLabel,
    this.closeResult,
    this.outcomeLabel,
    required this.isWin,
    required this.isLoss,
    required this.isBreakeven,
    this.duration,
    required this.closedLabel,
    required this.notes,
  });

  factory SignalHistoryModel.fromJson(Map<String, dynamic> json) {
    return SignalHistoryModel(
      id: json['id']?.toString() ?? '',
      asset: json['asset'] as String? ?? '',
      category: json['category'] as String? ?? '',
      categoryLabel: json['categoryLabel'] as String? ?? '',
      direction: json['direction'] as String? ?? '',
      type: json['type'] as String? ?? '',
      timeframeLabel: json['timeframeLabel'] as String? ?? '',
      actionLabel: json['actionLabel'] as String? ?? '',
      riskRewardRatio: json['riskRewardRatio'] as String?,
      entryPrice: (json['entryPrice'] as num?)?.toDouble(),
      entryPriceLabel: json['entryPriceLabel'] as String? ?? '',
      exitPrice: (json['exitPrice'] as num?)?.toDouble(),
      exitPriceLabel: json['exitPriceLabel'] as String? ?? '',
      priceMovementLabel: json['priceMovementLabel'] as String? ?? '',
      pnlPercent: (json['pnlPercent'] as num?)?.toDouble(),
      pnlLabel: json['pnlLabel'] as String?,
      closeResult: json['closeResult'] as String?,
      outcomeLabel: json['outcomeLabel'] as String?,
      isWin: json['isWin'] as bool? ?? false,
      isLoss: json['isLoss'] as bool? ?? false,
      isBreakeven: json['isBreakeven'] as bool? ?? false,
      duration: json['duration'] as String?,
      closedLabel: json['closedLabel'] as String? ?? '',
      notes: json['notes'] as String? ?? '',
    );
  }
}

// ─── Result wrappers ──────────────────────────────────────────────────────

class SignalListResult {
  final String access;
  final List<SignalModel> signals;
  final Map<String, dynamic>? pagination;

  const SignalListResult({
    required this.access,
    required this.signals,
    this.pagination,
  });
}

class SignalHistoryResult {
  final String access;
  final Map<String, dynamic>? performanceOverview;
  final List<SignalHistoryModel> signals;
  final int totalClosedSignals;
  final Map<String, dynamic>? pagination;

  const SignalHistoryResult({
    required this.access,
    this.performanceOverview,
    required this.signals,
    required this.totalClosedSignals,
    this.pagination,
  });
}
