enum HistoryResult { win, loss, breakeven }
enum HistorySide { buy, sell }

class HistorySignalModel {
  final String id;
  final String pair;
  final String categoryLabel; // Index, Forex, Crypto, Gold
  final HistorySide side;
  final HistoryResult result;
  final double profitPercent;
  final double entryPrice;
  final double exitPrice;
  final String riskReward;
  final String duration; // "2 days", "18h", "5h"
  final String closedDate;

  const HistorySignalModel({
    required this.id,
    required this.pair,
    required this.categoryLabel,
    required this.side,
    required this.result,
    required this.profitPercent,
    required this.entryPrice,
    required this.exitPrice,
    required this.riskReward,
    required this.duration,
    required this.closedDate,
  });
}