import 'package:elite_trading/core/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/exceptions/app_exceptions.dart';
import '../../data/model/plan_model.dart';
import '../../data/model/subscription_models.dart';
import '../../subscription_service.dart';
import '../screen/stripe_webview_screen.dart';

class SubscriptionsController extends GetxController {
  // ─── Service ──────────────────────────────────────────────────────────────
  final SubscriptionService _service = SubscriptionService();

  // ─── Step progress ────────────────────────────────────────────────────────
  final RxInt currentStep = 1.obs;
  final int totalSteps = 4;

  void onExplorePlansPressed() {
    currentStep.value = 2;
    Get.toNamed(AppRoutes.choosePlanScreen);
  }

  // ─── Plans (loaded from API) ──────────────────────────────────────────────
  final RxList<SubscriptionPlan> plans = <SubscriptionPlan>[].obs;
  final RxBool isPlansLoading = false.obs;
  final RxString plansError = ''.obs;

  /// Selected plan from the API list
  final Rx<SubscriptionPlan?> _selectedPlan = Rx<SubscriptionPlan?>(null);
  final RxString selectedPlanId = ''.obs;

  SubscriptionPlan? get selectedPlan => _selectedPlan.value;

  // ─── Trial status ────────────────────────────────────────────────────────
  final Rx<TrialStatusModel?> trialStatus = Rx<TrialStatusModel?>(null);
  final RxBool isTrialEligible = true.obs;

  // ─── Comparison rows (static, matching backend features) ─────────────────
  final List<ComparisonRow> comparisonRows = [
    ComparisonRow('Forex Signals',     [false, true, true]),
    ComparisonRow('Crypto Signals',    [true, false, true]),
    ComparisonRow('Gold & Metals',     [false, true, true]),
    ComparisonRow('Index Signals',     [false, false, true]),
    ComparisonRow('Priority Alerts',   [false, false, true]),
    ComparisonRow('VIP Community',     [false, false, true]),
  ];

  void selectPlan(String id) {
    selectedPlanId.value = id;
    _selectedPlan.value = plans.firstWhereOrNull((p) => p.id == id);
  }

  @override
  void onInit() {
    super.onInit();
    loadPlans();
  }

  /// Fetches plans from /api/v1/subscription and trial status from
  /// /api/v1/subscription/user/trial-status
  Future<void> loadPlans() async {
    isPlansLoading.value = true;
    plansError.value = '';
    try {
      final results = await Future.wait([
        _service.getPlans(),
        _service.getTrialStatus().catchError((_) => TrialStatusModel(
              hasUsedFreeTrial: false,
              canStartFreeTrial: true,
            )),
      ]);

      final fetchedPlans = results[0] as List<SubscriptionPlan>;
      final fetchedTrial = results[1] as TrialStatusModel;

      plans.value = fetchedPlans;
      trialStatus.value = fetchedTrial;
      isTrialEligible.value = fetchedTrial.canStartFreeTrial;

      // Auto-select the first plan (or VIP if present)
      if (fetchedPlans.isNotEmpty) {
        final vip = fetchedPlans.firstWhereOrNull(
            (p) => p.name.toLowerCase() == 'vip');
        final first = vip ?? fetchedPlans.first;
        selectedPlanId.value = first.id;
        _selectedPlan.value = first;
      }
    } on AppException catch (e) {
      plansError.value = e.message;
    } catch (_) {
      plansError.value = 'Failed to load plans. Please try again.';
    } finally {
      isPlansLoading.value = false;
    }
  }

  void onContinuePressed() {
    if (_selectedPlan.value == null) {
      _showError('Please select a plan to continue.');
      return;
    }
    currentStep.value = 3;
    Get.toNamed(AppRoutes.addPrementScreen);
  }

  // ─── Payment / Coupon ─────────────────────────────────────────────────────

  final Rx<PaymentMethod> selectedPaymentMethod = PaymentMethod.card.obs;

  final TextEditingController couponController = TextEditingController();
  final RxBool isCouponApplied = false.obs;
  final RxDouble couponDiscount = 0.0.obs;
  final RxString couponCode = ''.obs;
  final RxBool isCouponLoading = false.obs;

  final TextEditingController cardNumberController = TextEditingController();
  final TextEditingController cardHolderController = TextEditingController();
  final TextEditingController expiryController = TextEditingController();
  final TextEditingController cvcController = TextEditingController();

  void selectPaymentMethod(PaymentMethod method) =>
      selectedPaymentMethod.value = method;

  /// Validates coupon against the backend by doing a dry-run purchase.
  /// The backend will return the discounted amount in the purchase result.
  Future<void> applyCoupon() async {
    final code = couponController.text.trim().toUpperCase();
    if (code.isEmpty) {
      _showError('Please enter a coupon code.');
      return;
    }
    if (_selectedPlan.value == null) {
      _showError('Please select a plan first.');
      return;
    }

    isCouponLoading.value = true;
    try {
      // We validate by attempting a purchase preview — the backend
      // validates coupon applicability and returns finalAmount.
      final result = await _service.initiatePurchase(
        subscriptionId: _selectedPlan.value!.id,
        isFreeTrial: false,
        couponCode: code,
      );

      // Coupon was accepted — record discount
      final original = _selectedPlan.value!.price;
      final discounted = result.finalAmount;
      final discount = original - discounted;

      isCouponApplied.value = true;
      couponDiscount.value = discount;
      couponCode.value = code;

      _showSuccess('Coupon applied! -\$${discount.toStringAsFixed(2)} off');
    } on AppException catch (e) {
      isCouponApplied.value = false;
      couponDiscount.value = 0.0;
      _showError(e.message);
    } catch (_) {
      isCouponApplied.value = false;
      couponDiscount.value = 0.0;
      _showError('Invalid coupon code.');
    } finally {
      isCouponLoading.value = false;
    }
  }

  double get dueToday {
    if (isTrialEligible.value) return 0.0;
    final price = _selectedPlan.value?.price ?? 0.0;
    return isCouponApplied.value ? (price - couponDiscount.value) : price;
  }

  /// Called from AddPrementScreen "Continue" button.
  /// - Free trial eligible  → go to ConformTrial (step 4) to confirm
  /// - NOT trial eligible   → purchase directly via Stripe (skip confirm screen)
  void onAddPaymentContinuePressed() {
    if (_selectedPlan.value == null) {
      _showError('Please select a plan first.');
      return;
    }
    if (isTrialEligible.value) {
      // Free trial path → go to confirm screen
      currentStep.value = 4;
      Get.toNamed(AppRoutes.conformTrial);
    } else {
      // Paid plan path → purchase directly
      onPaidPurchasePressed();
    }
  }

  // ─── Confirm Trial / Purchase ─────────────────────────────────────────────

  final RxBool isPurchaseLoading = false.obs;

  /// First charge date string — computed from trial status / plan
  String get firstChargeDate {
    final ts = trialStatus.value;
    if (ts != null && ts.trialEndDate != null) {
      final d = ts.trialEndDate!;
      const months = [
        'Jan','Feb','Mar','Apr','May','Jun',
        'Jul','Aug','Sep','Oct','Nov','Dec'
      ];
      return '${months[d.month - 1]} ${d.day}, ${d.year}';
    }
    // Default: 30 days from now
    final d = DateTime.now().add(const Duration(days: 30));
    const months = [
      'Jan','Feb','Mar','Apr','May','Jun',
      'Jul','Aug','Sep','Oct','Nov','Dec'
    ];
    return '${months[d.month - 1]} ${d.day}, ${d.year}';
  }

  /// Called from ConformTrial "Start Free Trial" button.
  Future<void> onStartFreeTrialPressed() async {
    if (_selectedPlan.value == null) {
      _showError('No plan selected.');
      return;
    }
    await _purchase(isFreeTrial: true);
  }

  /// Called from AddPrementScreen "Continue" button for paid plans.
  Future<void> onPaidPurchasePressed() async {
    if (_selectedPlan.value == null) {
      _showError('No plan selected.');
      return;
    }
    await _purchase(isFreeTrial: false);
  }

  Future<void> _purchase({required bool isFreeTrial}) async {
    isPurchaseLoading.value = true;
    try {
      final result = await _service.initiatePurchase(
        subscriptionId: _selectedPlan.value!.id,
        isFreeTrial: isFreeTrial,
        couponCode: isCouponApplied.value ? couponCode.value : null,
      );

      if (result.paymentRequired && result.checkoutUrl != null) {
        // ── Paid plan → open Stripe checkout in-app ──────────────────────
        isPurchaseLoading.value = false;
        Get.to(
          () => StripeWebViewScreen(
            checkoutUrl: result.checkoutUrl!,
            onSuccess: () {
              _showSuccess('Payment successful! Subscription activated.');
              Get.offAllNamed(AppRoutes.bottomNavScreen);
            },
            onCancel: () {
              _showError('Payment cancelled. You can try again anytime.');
              Get.back();
            },
          ),
          transition: Transition.upToDown,
        );
      } else {
        // ── Free trial or 100% coupon → already activated ────────────────
        _showSuccess(
          isFreeTrial
              ? 'Free trial activated! Enjoy ${result.trialDays ?? 2} days free.'
              : 'Subscription activated successfully!',
        );
        Get.offAllNamed(AppRoutes.bottomNavScreen);
      }
    } on AppException catch (e) {
      _showError(e.message);
    } catch (_) {
      _showError('Purchase failed. Please try again.');
    } finally {
      isPurchaseLoading.value = false;
    }
  }

  // ─── Snackbar helpers ────────────────────────────────────────────────────

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

  void _showSuccess(String msg) {
    if (Get.isSnackbarOpen) Get.closeAllSnackbars();
    Get.snackbar(
      'Success',
      msg,
      backgroundColor: const Color(0xFF0F3A1A),
      colorText: Colors.white,
      snackPosition: SnackPosition.TOP,
      margin: const EdgeInsets.all(16),
      borderRadius: 12,
      duration: const Duration(seconds: 3),
      icon: const Icon(Icons.check_circle_outline, color: Colors.greenAccent),
    );
  }

  // ─── Dispose ─────────────────────────────────────────────────────────────

  @override
  void onClose() {
    couponController.dispose();
    cardNumberController.dispose();
    cardHolderController.dispose();
    expiryController.dispose();
    cvcController.dispose();
    super.onClose();
  }
}
