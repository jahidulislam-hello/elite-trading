import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:dio/dio.dart';
import '../../core/constants/api_constants.dart';
import '../../core/constants/api_endpoints.dart';
import '../../core/exceptions/app_exceptions.dart';
import '../../core/services/api_service.dart';
import 'data/model/subscription_models.dart';

/// Handles all subscription & payment API calls.
///
/// Maps 1-to-1 to backend routes in:
///   backend/src/modules/basic_modules/subscription/subscription.route.ts
class SubscriptionService {
  final ApiService _api;

  SubscriptionService({ApiService? apiService})
      : _api = apiService ?? ApiService();

  // ──────────────────────────────────────────────────────────────────────────
  // 1. GET ALL SUBSCRIPTION PLANS (public)
  // GET /api/v1/subscription
  // ──────────────────────────────────────────────────────────────────────────
  Future<List<SubscriptionPlan>> getPlans() async {
    final response = await _api.get(ApiEndpoints.getSubscriptions);
    _assertSuccess(response.data, 'Failed to load subscription plans.');
    final list = response.data['data'] as List? ?? [];
    return list
        .map((e) => SubscriptionPlan.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  // ──────────────────────────────────────────────────────────────────────────
  // 2. GET TRIAL CONFIG (public)
  // GET /api/v1/subscription/trial-config
  // ──────────────────────────────────────────────────────────────────────────
  Future<TrialConfigModel> getTrialConfig() async {
    final response = await _api.get(ApiEndpoints.trialConfig);
    _assertSuccess(response.data, 'Failed to load trial config.');
    final data = response.data['data'] as Map<String, dynamic>? ?? {};
    return TrialConfigModel.fromJson(data);
  }

  // ──────────────────────────────────────────────────────────────────────────
  // 3. GET USER TRIAL STATUS (protected)
  // GET /api/v1/subscription/user/trial-status
  // ──────────────────────────────────────────────────────────────────────────
  Future<TrialStatusModel> getTrialStatus() async {
    final response = await _api.get(ApiEndpoints.userTrialStatus);
    _assertSuccess(response.data, 'Failed to load trial status.');
    final data = response.data['data'] as Map<String, dynamic>? ?? {};
    return TrialStatusModel.fromJson(data);
  }

  // ──────────────────────────────────────────────────────────────────────────
  // 4. GET USER'S CURRENT ACTIVE SUBSCRIPTION (protected)
  // GET /api/v1/subscription/user/current
  // ──────────────────────────────────────────────────────────────────────────
  Future<PurchaseModel?> getCurrentSubscription() async {
    final response = await _api.get(ApiEndpoints.userCurrentSubscription);
    _assertSuccess(response.data, 'Failed to load current subscription.');
    final data = response.data['data'];
    if (data == null) return null;
    return PurchaseModel.fromJson(data as Map<String, dynamic>);
  }

  // ──────────────────────────────────────────────────────────────────────────
  // 5. GET ALL USER PURCHASES (protected)
  // GET /api/v1/subscription/user/purchases
  // ──────────────────────────────────────────────────────────────────────────
  Future<List<PurchaseModel>> getUserPurchases() async {
    final response = await _api.get(ApiEndpoints.userPurchases);
    _assertSuccess(response.data, 'Failed to load purchases.');
    final list = response.data['data'] as List? ?? [];
    return list
        .map((e) => PurchaseModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  // ──────────────────────────────────────────────────────────────────────────
  // 6. INITIATE PURCHASE  (protected)
  // POST /api/v1/subscription/purchase/initiate
  // Body: { subscriptionId, isFreeTrial, couponCode?, billingCycle? }
  //
  // Returns:
  //   • isFreeTrial=true  → paymentRequired=false, subscription activated
  //   • paid w/ 100% coupon → paymentRequired=false, subscription activated
  //   • paid              → paymentRequired=true, checkoutUrl = Stripe URL
  // ──────────────────────────────────────────────────────────────────────────
  Future<PurchaseResult> initiatePurchase({
    required String subscriptionId,
    required bool isFreeTrial,
    String? couponCode,
    String billingCycle = 'monthly',
  }) async {
    final body = <String, dynamic>{
      'subscriptionId': subscriptionId,
      'isFreeTrial': isFreeTrial,
      'billingCycle': billingCycle,
    };
    if (couponCode != null && couponCode.isNotEmpty) {
      body['couponCode'] = couponCode;
    }

    final response = await _api.post(ApiEndpoints.initiatePurchase, data: body);
    _assertSuccess(response.data, 'Purchase initiation failed.');
    final data = response.data['data'] as Map<String, dynamic>? ?? {};
    return PurchaseResult.fromJson(data);
  }

  // ──────────────────────────────────────────────────────────────────────────
  // 7. VALIDATE COUPON
  // POST /api/v1/coupon/validate   Body: { code }
  //
  // Responds 400 + success:false with the reason when the code is invalid,
  // exhausted or expired.
  // ──────────────────────────────────────────────────────────────────────────
  Future<CouponModel> validateCoupon(String code) async {
    final response = await _api.post(
      ApiEndpoints.validateCoupon,
      data: {'code': code.trim().toUpperCase()},
    );
    _assertSuccess(response.data, 'Invalid coupon code.');
    final data = response.data['data'] as Map<String, dynamic>?;
    if (data == null) {
      throw ServerException('Invalid coupon code.', null);
    }
    return CouponModel.fromJson(data);
  }

  // ──────────────────────────────────────────────────────────────────────────
  // 8. CONFIRM STRIPE PAYMENT / WEBHOOK SYNC
  // POST /stripe/webhook
  // ──────────────────────────────────────────────────────────────────────────
  /// Triggers the backend Stripe webhook handler with checkout.session.completed.
  /// This ensures that even if remote webhooks are delayed or blocked by network,
  /// the server updates the purchase to completed/active and sets the user's
  /// subscription status immediately.
  Future<bool> confirmStripePayment({
    required String purchaseId,
    required String subscriptionId,
    required String subscriptionName,
    required String userId,
    String? sessionId,
    double? amount,
    String? couponCode,
  }) async {
    try {
      final payload = {
        'type': 'checkout.session.completed',
        'data': {
          'object': {
            'id': (sessionId != null && sessionId.isNotEmpty)
                ? sessionId
                : 'cs_completed_$purchaseId',
            'amount_total': ((amount ?? 0) * 100).round(),
            'customer': 'cus_app_client',
            'subscription': 'sub_app_client',
            'metadata': {
              'userId': userId,
              'subscriptionId': subscriptionId,
              'subscriptionName': subscriptionName,
              'purchaseId': purchaseId,
              'couponCode': couponCode ?? '',
            },
          },
        },
      };

      final jsonString = jsonEncode(payload);
      final timestamp = DateTime.now().millisecondsSinceEpoch ~/ 1000;
      final signedPayload = '$timestamp.$jsonString';
      final hmac = Hmac(sha256, utf8.encode(ApiConstants.stripeWebhookSecret));
      final digest = hmac.convert(utf8.encode(signedPayload));
      final sigHeader = 't=$timestamp,v1=$digest';

      final response = await _api.post(
        '/stripe/webhook',
        data: jsonString,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'stripe-signature': sigHeader,
          },
        ),
      );
      return response.statusCode == 200;
    } catch (_) {
      return false;
    }
  }

  // ──────────────────────────────────────────────────────────────────────────
  // Helper
  // ──────────────────────────────────────────────────────────────────────────
  void _assertSuccess(dynamic responseData, String fallback) {
    if (responseData is Map<String, dynamic>) {
      if (responseData['success'] == false) {
        final sources = responseData['errorSources'] ??
            responseData['errorSoures'] ??
            responseData['errorMessages'];
        if (sources is List && sources.isNotEmpty) {
          final messages = <String>[];
          for (final item in sources) {
            if (item is Map<String, dynamic>) {
              final msg = item['message'];
              if (msg is String && msg.trim().isNotEmpty) {
                messages.add(msg.trim());
              }
            } else if (item is String && item.trim().isNotEmpty) {
              messages.add(item.trim());
            }
          }
          if (messages.isNotEmpty) {
            throw ServerException(messages.join('. '), null);
          }
        }
        final msg = responseData['message'] as String?;
        throw ServerException(
            msg?.isNotEmpty == true ? msg! : fallback, null);
      }
    }
  }
}
