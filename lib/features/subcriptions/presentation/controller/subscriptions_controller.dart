import 'package:elite_trading/core/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../data/model/plan_model.dart';
import '../screen/add_prement_screen.dart';
import '../screen/conform_trial.dart';

class SubscriptionsController extends GetxController {
  //----------------------subscriptFirst------------------------
  final RxInt currentStep = 1.obs;
  final int totalSteps = 4;

  void onExplorePlansPressed() {
    currentStep.value = 2;
    Get.toNamed(AppRoutes.choosePlanScreen);
  }

  //--------------------------------choose_plan_screen--------------
  final RxString selectedPlanId = 'vip'.obs;

  final List<PlanModel> plans = [
    PlanModel(
      id: 'vip',
      title: 'VIP',
      subtitle: 'Full access to all markets',
      emoji: 'asset/icon/subscription/vip.png',
      price: 79,
      isPopular: true,
      features: const [true, true, true, true],
    ),
    PlanModel(
      id: 'forex',
      title: 'Forex',
      subtitle: 'Forex & metals specialist',
      emoji: 'asset/icon/subscription/forex.png',
      price: 49,
      features: const [true, true, false, false],
    ),
    PlanModel(
      id: 'crypto',
      title: 'Crypto',
      subtitle: 'Crypto & digital assets',
      emoji: 'asset/icon/subscription/crypto.png',
      price: 39,
      features: const [true, false, false, false],
    ),
  ];

  final List<ComparisonRow> comparisonRows = [
    ComparisonRow('Forex Signals', [false, true, true]),
    ComparisonRow('Crypto Signals', [true, false, true]),
    ComparisonRow('Gold & Metals', [false, true, true]),
    ComparisonRow('Index Signals', [false, false, true]),
    ComparisonRow('Priority Alerts', [false, false, true]),
    ComparisonRow('VIP Community', [false, false, true]),
  ];

  PlanModel get selectedPlan =>
      plans.firstWhere((p) => p.id == selectedPlanId.value);

  void selectPlan(String id) => selectedPlanId.value = id;

  void onContinuePressed() {
    currentStep.value = 3;
    Get.to(() => const AddPrementScreen());
  }

  //--------------------------------add_payment_screen--------------
  final Rx<PaymentMethod> selectedPaymentMethod = PaymentMethod.card.obs;

  final TextEditingController couponController = TextEditingController();
  final RxBool isCouponApplied = false.obs;
  final RxDouble couponDiscount = 0.0.obs;
  final RxString couponCode = ''.obs;

  final TextEditingController cardNumberController = TextEditingController();
  final TextEditingController cardHolderController = TextEditingController();
  final TextEditingController expiryController = TextEditingController();
  final TextEditingController cvcController = TextEditingController();

  void selectPaymentMethod(PaymentMethod method) {
    selectedPaymentMethod.value = method;
  }

  void applyCoupon() {
    final code = couponController.text.trim().toUpperCase();
    if (code == 'WELCOME20') {
      isCouponApplied.value = true;
      couponDiscount.value = 10.0;
      couponCode.value = code;
    } else {
      isCouponApplied.value = false;
      couponDiscount.value = 0.0;
      Get.snackbar('Invalid Coupon', 'This coupon code is not valid');
    }
  }

  double get dueToday => 0.0; // free trial, charged later

  void onAddPaymentContinuePressed() {
    currentStep.value = 4;
    Get.to(() => const ConformTrial());
  }

  //--------------------------------conform_trial_screen--------------
  final String firstChargeDate = 'Aug 21, 2026';

  void onStartFreeTrialPressed() {
    Get.toNamed(AppRoutes.bottomNavScreen);
  }

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