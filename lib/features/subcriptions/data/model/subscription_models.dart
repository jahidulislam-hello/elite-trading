/// Dart models matching backend subscription interfaces.
///
/// Backend source:
///   backend/src/modules/basic_modules/subscription/subscription.interface.ts
///   backend/src/modules/basic_modules/subscription/subscription.model.ts

// ─── Subscription Plan ────────────────────────────────────────────────────

class SubscriptionPlan {
  final String id;
  final String name;
  final String description;
  final double price;
  final String? monthly;
  final String? yearly;
  final bool yearlyEnabled;
  final List<String> features;
  final int maxSignalsPerDay;
  final bool includesGoldSignals;
  final bool includesTechnicalAnalysis;
  final bool includesMarketSentiment;
  final bool includesEconomicCalendar;
  final String support;
  final List<String> signalTypes;
  final List<String> allowedCategories;
  final bool isActive;
  final String? emoji;
  final String? color;

  const SubscriptionPlan({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    this.monthly,
    this.yearly,
    required this.yearlyEnabled,
    required this.features,
    required this.maxSignalsPerDay,
    required this.includesGoldSignals,
    required this.includesTechnicalAnalysis,
    required this.includesMarketSentiment,
    required this.includesEconomicCalendar,
    required this.support,
    required this.signalTypes,
    required this.allowedCategories,
    required this.isActive,
    this.emoji,
    this.color,
  });

  factory SubscriptionPlan.fromJson(Map<String, dynamic> json) {
    return SubscriptionPlan(
      id: json['_id']?.toString() ?? '',
      name: json['name'] as String? ?? '',
      description: json['description'] as String? ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      monthly: json['monthly'] as String?,
      yearly: json['yearly'] as String?,
      yearlyEnabled: json['yearlyEnabled'] as bool? ?? true,
      features: List<String>.from(json['features'] as List? ?? []),
      maxSignalsPerDay: json['maxSignalsPerDay'] as int? ?? 10,
      includesGoldSignals: json['includesGoldSignals'] as bool? ?? false,
      includesTechnicalAnalysis:
          json['includesTechnicalAnalysis'] as bool? ?? false,
      includesMarketSentiment:
          json['includesMarketSentiment'] as bool? ?? false,
      includesEconomicCalendar:
          json['includesEconomicCalendar'] as bool? ?? false,
      support: json['support'] as String? ?? 'basic',
      signalTypes: List<String>.from(json['signalTypes'] as List? ?? []),
      allowedCategories:
          List<String>.from(json['allowedCategories'] as List? ?? []),
      isActive: json['isActive'] as bool? ?? true,
      emoji: json['emoji'] as String?,
      color: json['color'] as String?,
    );
  }

  /// Local emoji asset path based on plan name
  String get localEmojiAsset {
    switch (name.toLowerCase()) {
      case 'vip':
        return 'asset/icon/subscription/vip.png';
      case 'forex':
        return 'asset/icon/subscription/forex.png';
      case 'crypto':
        return 'asset/icon/subscription/crypto.png';
      default:
        return 'asset/icon/subscription/vip.png';
    }
  }

  bool get isPopular => name.toLowerCase() == 'vip';
}

// ─── Purchase ─────────────────────────────────────────────────────────────

class PurchaseModel {
  final String id;
  final String userId;
  final String subscriptionId;
  final String subscriptionName;
  final DateTime startDate;
  final DateTime endDate;
  final bool isFreeTrial;
  final DateTime? freeTrialEndDate;
  final String paymentStatus;
  final double amount;
  final String billingCycle;
  final bool isActive;

  const PurchaseModel({
    required this.id,
    required this.userId,
    required this.subscriptionId,
    required this.subscriptionName,
    required this.startDate,
    required this.endDate,
    required this.isFreeTrial,
    this.freeTrialEndDate,
    required this.paymentStatus,
    required this.amount,
    required this.billingCycle,
    required this.isActive,
  });

  factory PurchaseModel.fromJson(Map<String, dynamic> json) {
    return PurchaseModel(
      id: json['_id']?.toString() ?? '',
      userId: json['userId']?.toString() ?? '',
      subscriptionId: json['subscriptionId']?.toString() ?? '',
      subscriptionName: json['subscriptionName'] as String? ?? '',
      startDate: DateTime.tryParse(json['startDate']?.toString() ?? '') ??
          DateTime.now(),
      endDate: DateTime.tryParse(json['endDate']?.toString() ?? '') ??
          DateTime.now(),
      isFreeTrial: json['isFreeTrial'] as bool? ?? false,
      freeTrialEndDate:
          DateTime.tryParse(json['freeTrialEndDate']?.toString() ?? ''),
      paymentStatus: json['paymentStatus'] as String? ?? 'pending',
      amount: (json['amount'] as num?)?.toDouble() ?? 0.0,
      billingCycle: json['billingCycle'] as String? ?? 'monthly',
      isActive: json['isActive'] as bool? ?? false,
    );
  }
}

// ─── Purchase Initiation Result ───────────────────────────────────────────

class PurchaseResult {
  final PurchaseModel purchase;
  final String? checkoutUrl;
  final String? sessionId;
  final double finalAmount;
  final String? couponApplied;
  final bool paymentRequired;
  final String? accessType;
  final int? trialDays;
  final String? nextStep;

  const PurchaseResult({
    required this.purchase,
    this.checkoutUrl,
    this.sessionId,
    required this.finalAmount,
    this.couponApplied,
    required this.paymentRequired,
    this.accessType,
    this.trialDays,
    this.nextStep,
  });

  factory PurchaseResult.fromJson(Map<String, dynamic> json) {
    final purchaseJson = json['purchase'] as Map<String, dynamic>?;
    return PurchaseResult(
      purchase: purchaseJson != null
          ? PurchaseModel.fromJson(purchaseJson)
          : PurchaseModel(
              id: '',
              userId: '',
              subscriptionId: '',
              subscriptionName: '',
              startDate: DateTime.now(),
              endDate: DateTime.now(),
              isFreeTrial: false,
              paymentStatus: 'pending',
              amount: 0,
              billingCycle: 'monthly',
              isActive: false,
            ),
      checkoutUrl: json['checkoutUrl'] as String?,
      sessionId: json['sessionId'] as String?,
      finalAmount: (json['finalAmount'] as num?)?.toDouble() ?? 0.0,
      couponApplied: json['couponApplied'] as String?,
      paymentRequired: json['paymentRequired'] as bool? ?? false,
      accessType: json['accessType'] as String?,
      trialDays: json['trialDays'] as int?,
      nextStep: json['nextStep'] as String?,
    );
  }
}

// ─── Trial Status ─────────────────────────────────────────────────────────

class TrialStatusModel {
  final bool hasUsedFreeTrial;
  final bool? isTrialActive;
  final DateTime? trialEndDate;
  final bool canStartFreeTrial;
  final String? reason;

  const TrialStatusModel({
    required this.hasUsedFreeTrial,
    this.isTrialActive,
    this.trialEndDate,
    required this.canStartFreeTrial,
    this.reason,
  });

  factory TrialStatusModel.fromJson(Map<String, dynamic> json) {
    return TrialStatusModel(
      hasUsedFreeTrial: json['hasUsedFreeTrial'] as bool? ?? false,
      isTrialActive: json['isTrialActive'] as bool?,
      trialEndDate:
          DateTime.tryParse(json['trialEndDate']?.toString() ?? ''),
      canStartFreeTrial: json['canStartFreeTrial'] as bool? ?? true,
      reason: json['reason'] as String?,
    );
  }
}

// ─── Coupon validation result (from initiate API) ─────────────────────────

class CouponResult {
  final bool applied;
  final String code;
  final double discountAmount;
  final String discountDisplay;

  const CouponResult({
    required this.applied,
    required this.code,
    required this.discountAmount,
    required this.discountDisplay,
  });
}
