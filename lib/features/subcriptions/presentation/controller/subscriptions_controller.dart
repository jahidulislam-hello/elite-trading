import 'package:elite_trading/core/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/exceptions/app_exceptions.dart';
import '../../../../core/services/storage_service.dart';
import '../../../authentication/auth_service.dart';
import '../../../authentication/presentation/controller/auth_controller.dart';
import '../../../bottom_nab_bar/presentation/controller/bottom_nav_controller.dart';
import '../../../profile/controller/profile_controller.dart';
import '../../data/model/plan_model.dart';
import '../../data/model/subscription_models.dart';
import '../../subscription_service.dart';
import '../screen/stripe_webview_screen.dart';

class SubscriptionsController extends GetxController {
  // ─── Service ──────────────────────────────────────────────────────────────
  final SubscriptionService _service = SubscriptionService();
  final AuthService _authService = AuthService();

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
  final Rx<TrialConfigModel?> trialConfig = Rx<TrialConfigModel?>(null);
  final RxBool isTrialEligible = false.obs;
  final RxString trialStatusError = ''.obs;

  // ─── Comparison table (derived from the subscription API) ────────────────

  /// Every row is built from the plan documents returned by
  /// GET /api/v1/subscription, so the ticks always match the backend.
  List<PlanComparisonRow> get comparisonRows {
    final list = plans.toList();
    if (list.isEmpty) return const [];

    final rows = <PlanComparisonRow>[];

    PlanComparisonRow flagRow(
      String label,
      bool Function(SubscriptionPlan plan) hasFlag,
    ) =>
        PlanComparisonRow(
          label,
          list.map((p) => PlanComparisonCell(included: hasFlag(p))).toList(),
        );

    void addFlagRow(
      String label,
      bool Function(SubscriptionPlan plan) hasFlag,
    ) {
      if (list.any(hasFlag)) rows.add(flagRow(label, hasFlag));
    }

    // Signal categories, in the order the API lists them.
    for (final category in _distinctValues((p) => p.allowedCategories)) {
      addFlagRow(
        '$category signals',
        (plan) => plan.allowedCategories
            .any((c) => c.toLowerCase() == category.toLowerCase()),
      );
    }

    // Signal types (Scalp / Swing / Long-term).
    for (final type in _distinctValues((p) => p.signalTypes)) {
      addFlagRow(
        '$type signals',
        (plan) =>
            plan.signalTypes.any((t) => t.toLowerCase() == type.toLowerCase()),
      );
    }

    addFlagRow('Gold & metals', (plan) => plan.includesGoldSignals);
    addFlagRow('Technical analysis', (plan) => plan.includesTechnicalAnalysis);
    addFlagRow('Market sentiment', (plan) => plan.includesMarketSentiment);
    addFlagRow('Economic calendar', (plan) => plan.includesEconomicCalendar);

    rows.add(PlanComparisonRow(
      'Signals per day',
      list
          .map((p) => PlanComparisonCell(
                included: p.maxSignalsPerDay > 0,
                text: '${p.maxSignalsPerDay}',
              ))
          .toList(),
    ));

    rows.add(PlanComparisonRow(
      'Support',
      list
          .map((p) => PlanComparisonCell(
                included: p.support.isNotEmpty,
                text: _capitalize(p.support),
              ))
          .toList(),
    ));

    return rows;
  }

  /// Unique, order-preserving values collected across every plan.
  List<String> _distinctValues(
    List<String> Function(SubscriptionPlan plan) selector,
  ) {
    final seen = <String, String>{};
    for (final plan in plans) {
      for (final raw in selector(plan)) {
        final value = raw.trim();
        if (value.isEmpty) continue;
        seen.putIfAbsent(value.toLowerCase(), () => _capitalize(value));
      }
    }
    return seen.values.toList();
  }

  String _capitalize(String value) =>
      value.isEmpty ? value : '${value[0].toUpperCase()}${value.substring(1)}';

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
      final fetchedPlans = await _service.getPlans();
      plans.value = fetchedPlans;

      // Auto-select the first plan (or VIP if present)
      if (fetchedPlans.isNotEmpty) {
        final vip =
            fetchedPlans.firstWhereOrNull((p) => p.name.toLowerCase() == 'vip');
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

    await refreshTrialStatus();
  }

  void onContinuePressed() {
    if (_selectedPlan.value == null) {
      _showError('Please select a plan to continue.');
      return;
    }
    _openCheckout();
  }

  void _openCheckout() {
    clearCoupon();
    currentStep.value = 3;
    // Trial eligibility decides which buttons the payment step shows, so make
    // sure it reflects the server before the screen is built.
    refreshTrialStatus();
    Get.toNamed(AppRoutes.addPrementScreen);
  }

  // ─── Trial eligibility ────────────────────────────────────────────────────

  final RxBool isTrialStatusLoading = false.obs;

  /// Reason the trial button is unavailable, straight from the backend
  /// eligibility check (already used trial, active paid plan, trial disabled).
  String get trialUnavailableReason => trialStatusError.value.isNotEmpty
      ? trialStatusError.value
      : trialStatus.value?.reason ??
          'Free trial is not available for this account.';

  Future<void> refreshTrialStatus() async {
    isTrialStatusLoading.value = true;
    trialStatusError.value = '';
    isTrialEligible.value = false;
    try {
      final status = await _service.getTrialStatus();
      trialStatus.value = status;
      isTrialEligible.value = status.canStartFreeTrial;
      final config = await _loadTrialConfigOrNull();
      if (config != null) trialConfig.value = config;
    } on AppException catch (e, s) {
      debugPrint('refreshTrialStatus failed: $e\n$s');
      trialStatusError.value = e.message;
    } catch (e, s) {
      debugPrint('refreshTrialStatus failed: $e\n$s');
      trialStatusError.value = 'Unable to verify free-trial eligibility.';
    } finally {
      isTrialStatusLoading.value = false;
    }
  }

  Future<TrialConfigModel?> _loadTrialConfigOrNull() async {
    try {
      return await _service.getTrialConfig();
    } catch (e, s) {
      debugPrint('getTrialConfig failed: $e\n$s');
      return null;
    }
  }

  // ─── Welcome offer (promo vs standard trial) ──────────────────────────────
  //
  // Backend rule (backend/src/utils/welcomeTrial.ts): a verified user whose
  // verificationOrder is within promoLimit gets promoDuration; everyone after
  // the promo window gets trialDuration. Both durations and the limit are
  // admin-editable through trial-config, so every label below comes from the
  // API — never from a value baked into the app.

  /// True when this account falls inside the promo window.
  bool get isPromoTrial {
    final status = trialStatus.value;
    if (status != null && status.accessType != null) {
      return status.isPromoEligible;
    }
    // Older backends don't return the offer fields, so fall back to whether
    // promo seats are still open.
    return trialConfig.value?.isPromoStillOpen ?? false;
  }

  /// How many verified members the promo window covers, or 0 when unknown.
  int get promoLimit {
    final status = trialStatus.value;
    if (status != null && status.promoLimit > 0) return status.promoLimit;
    return trialConfig.value?.promoLimit ?? 0;
  }

  /// Free days this account gets, or 0 while the config is unknown.
  int get trialDays {
    final status = trialStatus.value;
    if (status != null && status.trialDays > 0) return status.trialDays;

    final config = trialConfig.value;
    if (config == null) return 0;
    if (isPromoTrial) return config.promoDays;
    return config.trialOn ? config.trialDays : 0;
  }

  /// The admin-authored label for the offer exactly as configured, e.g.
  /// '1 Month (30 Days)' or '3 Days'. Empty while it is still unknown.
  String get trialDurationLabel {
    final serverLabel = trialStatus.value?.trialDurationLabel?.trim();
    if (serverLabel != null && serverLabel.isNotEmpty) return serverLabel;

    final config = trialConfig.value;
    if (config == null) return '';
    if (isPromoTrial) return config.promoDuration;
    return config.trialOn ? config.trialDuration : '';
  }

  /// Same label without any parenthetical, so headlines stay short:
  /// '1 Month (30 Days)' → '1 Month'.
  String get trialDurationShortLabel {
    final label = trialDurationLabel;
    final trimmed = label.replaceAll(RegExp(r'\s*\([^)]*\)'), '').trim();
    return trimmed.isEmpty ? label : trimmed;
  }

  /// Compact headline form, e.g. '1 Month Free' or '3 Days Free'.
  String get trialHeadlineLabel {
    final label = trialDurationShortLabel;
    return label.isEmpty ? 'Free Trial' : '$label Free';
  }

  /// Short form used in tight summary rows, e.g. '3 Days free'.
  String get trialShortLabel {
    if (!isTrialEligible.value) return 'Not available';
    final label = trialDurationShortLabel;
    return label.isEmpty ? 'Available' : '$label free';
  }

  /// Explains which offer applies and why.
  String get trialOfferHeadline {
    if (!isTrialEligible.value) return 'Free trial unavailable';
    final label = trialDurationShortLabel;
    if (label.isEmpty) return 'Free Trial Available';
    return isPromoTrial
        ? 'Launch Offer — $label Free'
        : '$label Free Trial Available';
  }

  String get trialOfferDetail {
    if (!isTrialEligible.value) return trialUnavailableReason;

    final label = trialDurationShortLabel;
    final buffer = StringBuffer(
      label.isEmpty
          ? 'No payment is taken today — billing starts when your free trial ends.'
          : 'You get $label free. No payment is taken today — billing starts '
              'when the trial ends.',
    );

    final config = trialConfig.value;
    if (config != null && config.promoLimit > 0) {
      if (isPromoTrial) {
        final seatsLeft = config.promoSeatsLeft;
        buffer.write(
          seatsLeft > 0
              ? ' You are one of the first ${config.promoLimit} verified members'
                  ' ($seatsLeft ${seatsLeft == 1 ? 'spot' : 'spots'} left).'
              : ' You are one of the first ${config.promoLimit} verified members.',
        );
      } else if (config.promoOn && config.promoDuration.isNotEmpty) {
        buffer.write(
          ' The ${config.promoDuration} launch offer for the first'
          ' ${config.promoLimit} members is now closed.',
        );
      }
    }

    return buffer.toString();
  }

  // ─── Payment / Coupon ─────────────────────────────────────────────────────

  final TextEditingController couponController = TextEditingController();
  final Rx<CouponModel?> appliedCoupon = Rx<CouponModel?>(null);
  final RxBool isCouponLoading = false.obs;
  final RxString couponError = ''.obs;

  double get couponDiscount {
    final coupon = appliedCoupon.value;
    final price = _selectedPlan.value?.price ?? 0.0;
    return coupon == null ? 0.0 : coupon.discountAmount(price);
  }

  void clearCoupon() {
    couponController.clear();
    appliedCoupon.value = null;
    couponError.value = '';
  }

  /// Validates the code through POST /api/v1/coupon/validate and mirrors the
  /// backend's plan-applicability rule so the discount shown here matches what
  /// initiateSubscriptionPurchase will charge.
  Future<void> applyCoupon() async {
    final code = couponController.text.trim().toUpperCase();
    final plan = _selectedPlan.value;
    if (code.isEmpty) {
      couponError.value = 'Please enter a coupon code.';
      return;
    }
    if (plan == null) {
      couponError.value = 'Please select a plan first.';
      return;
    }

    isCouponLoading.value = true;
    couponError.value = '';
    try {
      final coupon = await _service.validateCoupon(code);

      if (!coupon.appliesToPlan(plan.name)) {
        appliedCoupon.value = null;
        couponError.value =
            'This coupon is not applicable to the ${plan.name} plan.';
        return;
      }

      appliedCoupon.value = coupon;
      _showSuccess(
        'Coupon applied — ${coupon.discountLabel} '
        '(-\$${coupon.discountAmount(plan.price).toStringAsFixed(2)})',
      );
    } on AppException catch (e) {
      appliedCoupon.value = null;
      couponError.value = e.message;
    } catch (e, s) {
      debugPrint('applyCoupon failed: $e\n$s');
      appliedCoupon.value = null;
      couponError.value = 'Invalid coupon code.';
    } finally {
      isCouponLoading.value = false;
    }
  }

  double get planPrice => _selectedPlan.value?.price ?? 0.0;

  double get dueToday {
    final coupon = appliedCoupon.value;
    return coupon == null ? planPrice : coupon.discountedPrice(planPrice);
  }

  // ─── Confirm Trial / Purchase ─────────────────────────────────────────────

  final RxBool isPurchaseLoading = false.obs;

  /// First charge date, projected from the configured trial length. Empty when
  /// the trial length isn't known yet, so screens can omit the date rather than
  /// show a guessed one.
  String get firstChargeDate {
    final ts = trialStatus.value;
    if (ts != null && ts.trialEndDate != null) {
      return _formatDate(ts.trialEndDate!);
    }
    final days = trialDays;
    if (days <= 0) return '';
    return _formatDate(DateTime.now().add(Duration(days: days)));
  }

  String _formatDate(DateTime d) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];
    return '${months[d.month - 1]} ${d.day}, ${d.year}';
  }

  /// Starts the free trial through POST /subscription/purchase/initiate with
  /// isFreeTrial: true — the backend activates it without any payment.
  Future<void> onStartFreeTrialPressed() async {
    if (_selectedPlan.value == null) {
      _showError('No plan selected.');
      return;
    }
    if (!isTrialEligible.value) {
      _showError(trialUnavailableReason);
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
        couponCode: isFreeTrial ? null : appliedCoupon.value?.code,
      );

      if (result.paymentRequired) {
        if (result.checkoutUrl == null ||
            result.checkoutUrl!.isEmpty ||
            result.purchase.id.isEmpty) {
          throw ServerException(
            'The payment service returned an incomplete checkout response.',
            null,
          );
        }
        // ── Paid plan → open Stripe checkout in-app ──────────────────────
        isPurchaseLoading.value = false;
        Get.to(
          () => StripeWebViewScreen(
            checkoutUrl: result.checkoutUrl!,
            onSuccess: (sessionId) => _handlePaidCheckoutSuccess(
              result,
              checkoutSessionId: sessionId,
            ),
            // The checkout screen pops itself; step back to the plan list so
            // another plan can be picked.
            onCancel: _returnToPlanList,
          ),
          transition: Transition.upToDown,
        );
      } else {
        if (!result.purchase.isActive ||
            result.purchase.paymentStatus != 'completed') {
          throw ServerException(
            'The server did not confirm subscription activation.',
            null,
          );
        }
        // ── Free trial or 100% coupon → already activated ────────────────
        // The backend echoes the granted length; fall back to the configured
        // offer, and to a length-free message when neither is known.
        final grantedDays = result.trialDays ?? trialDays;
        _goHomeAfterPurchase(
          !isFreeTrial
              ? 'Subscription activated successfully!'
              : grantedDays > 0
                  ? 'Free trial activated! Enjoy $grantedDays '
                      '${grantedDays == 1 ? 'day' : 'days'} free.'
                  : 'Free trial activated!',
        );
      }
    } on AppException catch (e) {
      _showError(e.message);
    } catch (_) {
      _showError('Purchase failed. Please try again.');
    } finally {
      isPurchaseLoading.value = false;
    }
  }

  Future<void> _handlePaidCheckoutSuccess(
    PurchaseResult result, {
    String? checkoutSessionId,
  }) async {
    isPurchaseLoading.value = true;
    final purchaseId = result.purchase.id;
    var isActivated = false;

    // Resolve userId:
    String userId = result.purchase.userId;
    if (userId.isEmpty) {
      try {
        final storage = Get.find<StorageService>();
        userId = storage.getString(StorageKeys.userId) ?? '';
      } catch (_) {}
    }
    if (userId.isEmpty && Get.isRegistered<AuthController>()) {
      userId = Get.find<AuthController>().currentUser.value?.id ?? '';
    }
    if (userId.isEmpty) {
      try {
        final profile = await _authService.myProfile();
        userId = profile.id;
      } catch (_) {}
    }

    final planName = result.purchase.subscriptionName.isNotEmpty
        ? result.purchase.subscriptionName
        : (_selectedPlan.value?.name ?? 'VIP');

    // Immediately trigger backend webhook sync so database updates without waiting
    if (purchaseId.isNotEmpty) {
      await _service.confirmStripePayment(
        purchaseId: purchaseId,
        subscriptionId: result.purchase.subscriptionId,
        subscriptionName: planName,
        userId: userId,
        sessionId: checkoutSessionId ?? result.sessionId,
        amount: result.finalAmount > 0
            ? result.finalAmount
            : (_selectedPlan.value?.price ?? 0.0),
        couponCode: appliedCoupon.value?.code,
      );
    }

    // Poll to verify active subscription status
    for (var attempt = 0; attempt < 8; attempt++) {
      try {
        final current = await _service.getCurrentSubscription();
        if (current != null && current.isActive && current.paymentStatus == 'completed') {
          isActivated = true;
          break;
        }
        final profile = await _authService.myProfile();
        if (profile.isSubscriptionActive) {
          isActivated = true;
          if (Get.isRegistered<AuthController>()) {
            Get.find<AuthController>().currentUser.value = profile;
          }
          if (Get.isRegistered<ProfileController>()) {
            Get.find<ProfileController>().loadProfile(silent: true);
          }
          break;
        }
      } catch (e, s) {
        debugPrint('Subscription activation check failed: $e\n$s');
      }

      if (attempt < 7) {
        await Future.delayed(const Duration(milliseconds: 1000));
      }
    }

    // Optimistically update frontend state so UI immediately reflects the purchase
    if (Get.isRegistered<AuthController>()) {
      final user = Get.find<AuthController>().currentUser.value;
      if (user != null && !user.isSubscriptionActive) {
        final updatedUser = user.copyWith(
          subscriptionStatus: 'active',
          subscriptionType: planName,
          subscriptionEndDate: DateTime.now().add(const Duration(days: 30)),
        );
        Get.find<AuthController>().currentUser.value = updatedUser;
      }
    }

    isPurchaseLoading.value = false;

    _goHomeAfterPurchase(
      isActivated
          ? 'Payment successful! Subscription activated.'
          : 'Payment received! Welcome to $planName.',
    );
  }

  /// Sends the user back to the plan list after an abandoned checkout.
  ///
  /// The predicate also stops at the first route, so this can never empty the
  /// stack if the plan screen isn't below us.
  void _returnToPlanList() {
    currentStep.value = 2;
    Get.until((route) =>
        route.settings.name == AppRoutes.choosePlanScreen || route.isFirst);
    _showError('Payment cancelled. You can try again anytime.');
  }

  /// Returns to the home tabs after a completed purchase.
  ///
  /// Cleans the entire navigation stack and routes to the home screen
  /// (tab 0 in navbar) while fetching fresh signals, posts, notifications,
  /// history, and profile.
  void _goHomeAfterPurchase(String message) {
    if (Get.isSnackbarOpen) Get.closeAllSnackbars();

    // Cleanly reset navigation stack to BottomNavScreen
    Get.offAllNamed(AppRoutes.bottomNavScreen);

    // Refresh all controllers and tabs after navigation mounts
    Future.delayed(const Duration(milliseconds: 250), () async {
      try {
        if (Get.isRegistered<AuthController>()) {
          await Get.find<AuthController>().refreshCurrentUser();
        }
      } catch (_) {}

      try {
        if (Get.isRegistered<ProfileController>()) {
          await Get.find<ProfileController>().loadProfile(silent: true);
        }
      } catch (_) {}

      try {
        if (Get.isRegistered<BottomNavController>()) {
          final nav = Get.find<BottomNavController>();
          nav.selectedIndex.value = 0; // Home screen (SignalScreen)
          nav.refreshAllTabs();
        }
      } catch (_) {}

      _showSuccess(message);
    });
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
    super.onClose();
  }
}
