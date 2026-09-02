class PlanModel {
  final String id;
  final String title;
  final String subtitle;
  final String emoji;
  final int price;
  final bool isPopular;
  final List<bool> features;

  PlanModel({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.emoji,
    required this.price,
    required this.features,
    this.isPopular = false,
  });
}

/// One cell of the plan comparison table.
///
/// [text] is used for values that aren't a yes/no (signals per day, support
/// tier); otherwise the cell renders a tick or a cross based on [included].
class PlanComparisonCell {
  final bool included;
  final String? text;

  const PlanComparisonCell({required this.included, this.text});
}

class PlanComparisonRow {
  final String label;
  final List<PlanComparisonCell> cells;

  const PlanComparisonRow(this.label, this.cells);
}

class TrialFeature {
  final String label;
  const TrialFeature(this.label);
}

const List<TrialFeature> trialIncludedFeatures = [
  TrialFeature('All Forex & Currency Signals'),
  TrialFeature('All Crypto & Altcoin Signals'),
  TrialFeature('Gold, Silver & Commodities'),
  TrialFeature('Stock Index Signals'),
  TrialFeature('Priority Push Alerts (< 60s)'),
  TrialFeature('VIP Analyst Community'),
  TrialFeature('Dedicated Q&A Sessions'),
  TrialFeature('Weekly Performance Reports'),
];