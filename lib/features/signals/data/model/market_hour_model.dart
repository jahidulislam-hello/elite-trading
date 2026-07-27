class MarketHourModel {
  final String flag;
  final String name;
  final bool isOpen;
  final String time;
  final String utcRange;

  const MarketHourModel({
    required this.flag,
    required this.name,
    required this.isOpen,
    required this.time,
    required this.utcRange,
  });
}