enum SignalType { buy, sell }

class TakeProfitModel {
  final String label;
  final double price;
  final bool isHit;

  const TakeProfitModel({
    required this.label,
    required this.price,
    this.isHit = false,
  });
}

class SignalModel {
  final String id;
  final String pair;
  final String categoryLabel; // Forex, Crypto, Gold
  final String subtitleLabel; // Cryptocurrency, Forex, Metals
  final SignalType type;
  final bool isLive;
  final double entryPrice;
  final double stopLoss;
  final double stopLossPercent;
  final List<TakeProfitModel> takeProfits;
  final String riskReward;
  final String timeAgo;

  final String tradeType;
  final String publishedDate;
  final double? previousClose;
  final double? openingPrice;
  final double? change24hPercent;

  const SignalModel({
    required this.id,
    required this.pair,
    required this.categoryLabel,
    required this.subtitleLabel,
    required this.type,
    required this.isLive,
    required this.entryPrice,
    required this.stopLoss,
    required this.stopLossPercent,
    required this.takeProfits,
    required this.riskReward,
    required this.timeAgo,
    this.tradeType = 'Day Trade',
    this.publishedDate = '',
    this.previousClose,
    this.openingPrice,
    this.change24hPercent,
  });
}