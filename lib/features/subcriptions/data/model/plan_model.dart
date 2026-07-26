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

class ComparisonRow {
  final String label;
  final List<bool> checks; // [Crypto, Forex, VIP]

  ComparisonRow(this.label, this.checks);
}

enum PaymentMethod { card, applePay, googlePay }

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