import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/utils/customeTextField/custom_text_field.dart';
import '../../../authentication/presentation/widget/Elevatedbutton.dart';
import '../../data/model/subscription_models.dart';
import '../controller/subscriptions_controller.dart';
import '../widget/progress_step_header.dart';

class AddPrementScreen extends GetView<SubscriptionsController> {
  const AddPrementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: const Color(0xFF0F0B1E),
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              "asset/image/onboarding/background.png",
              fit: BoxFit.cover,
            ),
          ),
          SafeArea(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 16.h),
                  ProgressStepHeader(currentStep: 3, totalSteps: 4),

                  SizedBox(height: 28.h),

                  Text(
                    'Confirm Your Plan',
                    style: GoogleFonts.poppins(
                      fontSize: 24.sp,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Obx(() => Text(
                        controller.isTrialEligible.value
                            ? "Start free today — you won't be charged until your trial ends."
                            : 'Review your plan, then continue to secure checkout.',
                        style: GoogleFonts.poppins(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w400,
                          color: Colors.white54,
                        ),
                      )),

                  SizedBox(height: 22.h),

                  // ── Selected plan: price + every feature from the API ─────
                  Obx(() {
                    final plan = controller.selectedPlan;
                    if (plan == null) {
                      return _InfoCard(
                        icon: Icons.error_outline,
                        iconColor: Colors.redAccent,
                        title: 'No plan selected',
                        message:
                            'Go back and choose a subscription plan to continue.',
                      );
                    }
                    return _PlanSummaryCard(plan: plan);
                  }),

                  SizedBox(height: 22.h),

                  // ── Coupon ────────────────────────────────────────────────
                  Text(
                    'Have a Coupon?',
                    style: GoogleFonts.poppins(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w500,
                      color: Colors.white70,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Row(
                    children: [
                      Expanded(
                        child: CustomTextField(
                          controller: controller.couponController,
                          hintText: 'Enter coupon code',
                          filColor: const Color(0xFF1B1830),
                          hinTextColor: Colors.white,
                          borderColor: Colors.white.withValues(alpha: 0.06),
                          borderRadius: 12,
                          borderHeight: 1,
                          contentPaddingHorizontal: 14,
                          contentPaddingVertical: 14,
                          hinTextSize: 13,
                          isvalidation: false,
                        ),
                      ),
                      SizedBox(width: 10.w),
                      Obx(() => GestureDetector(
                            onTap: controller.isCouponLoading.value
                                ? null
                                : controller.applyCoupon,
                            child: Container(
                              height: 50.h,
                              width: 88.w,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: const Color(0xFF7B1FE0),
                                borderRadius: BorderRadius.circular(12.r),
                              ),
                              child: controller.isCouponLoading.value
                                  ? SizedBox(
                                      width: 18.w,
                                      height: 18.w,
                                      child: const CircularProgressIndicator(
                                        color: Colors.white,
                                        strokeWidth: 2,
                                      ),
                                    )
                                  : Text(
                                      'Apply',
                                      style: GoogleFonts.poppins(
                                        fontSize: 13.sp,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white,
                                      ),
                                    ),
                            ),
                          )),
                    ],
                  ),

                  Obx(() {
                    final coupon = controller.appliedCoupon.value;
                    final error = controller.couponError.value;

                    if (error.isNotEmpty) {
                      return Padding(
                        padding: EdgeInsets.only(top: 10.h),
                        child: Row(
                          children: [
                            Icon(Icons.error_outline,
                                size: 14.sp, color: Colors.redAccent),
                            SizedBox(width: 6.w),
                            Expanded(
                              child: Text(
                                error,
                                style: GoogleFonts.poppins(
                                  fontSize: 12.sp,
                                  color: Colors.redAccent,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }

                    if (coupon == null) return const SizedBox.shrink();

                    return Padding(
                      padding: EdgeInsets.only(top: 10.h),
                      child: Row(
                        children: [
                          Icon(Icons.check_circle,
                              size: 14.sp, color: const Color(0xFF2ECC71)),
                          SizedBox(width: 6.w),
                          Expanded(
                            child: Text(
                              'Coupon ${coupon.code} applied — ${coupon.discountLabel}',
                              style: GoogleFonts.poppins(
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w500,
                                color: const Color(0xFF2ECC71),
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: controller.clearCoupon,
                            child: Text(
                              'Remove',
                              style: GoogleFonts.poppins(
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w500,
                                color: Colors.white54,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }),

                  SizedBox(height: 22.h),

                  // ── Trial availability ────────────────────────────────────
                  Obx(() {
                    if (controller.isTrialEligible.value) {
                      final isPromo = controller.isPromoTrial;
                      final chargeDate = controller.firstChargeDate;
                      return _InfoCard(
                        icon: isPromo
                            ? Icons.card_giftcard_outlined
                            : Icons.verified_outlined,
                        iconColor: isPromo
                            ? const Color(0xFFBFA06D)
                            : const Color(0xFF9B6BFF),
                        title: controller.trialOfferHeadline,
                        message: controller.trialOfferDetail,
                        footnote: chargeDate.isEmpty
                            ? 'No credit card required to start'
                            : 'No credit card required to start • First charge on $chargeDate',
                      );
                    }
                    return _InfoCard(
                      icon: Icons.lock_clock,
                      iconColor: const Color(0xFFE0A11F),
                      title: 'Free Trial Unavailable',
                      message: controller.trialUnavailableReason,
                    );
                  }),

                  SizedBox(height: 22.h),

                  // ── Order summary ─────────────────────────────────────────
                  Container(
                    padding: EdgeInsets.all(16.w),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1B1830),
                      borderRadius: BorderRadius.circular(14.r),
                      border: Border.all(
                          color: Colors.white.withValues(alpha: 0.06)),
                    ),
                    child: Obx(() {
                      final plan = controller.selectedPlan;
                      final coupon = controller.appliedCoupon.value;
                      return Column(
                        children: [
                          _SummaryRow(
                            label: 'Plan',
                            value: plan != null
                                ? '${plan.name} — \$${plan.price.toStringAsFixed(2)}/mo'
                                : '—',
                            valueColor: Colors.white,
                          ),
                          _SummaryDivider(),
                          if (coupon != null) ...[
                            _SummaryRow(
                              label: 'Coupon (${coupon.code})',
                              value:
                                  '-\$${controller.couponDiscount.toStringAsFixed(2)}',
                              valueColor: const Color(0xFF2ECC71),
                              isBold: true,
                            ),
                            _SummaryDivider(),
                          ],
                          _SummaryRow(
                            label: 'Free Trial',
                            value: controller.isTrialEligible.value
                                ? controller.trialShortLabel
                                : 'Not available',
                            valueColor: controller.isTrialEligible.value
                                ? (controller.isPromoTrial
                                    ? const Color(0xFFBFA06D)
                                    : const Color(0xFF9B6BFF))
                                : Colors.white38,
                          ),
                          _SummaryDivider(),
                          if (controller.isTrialEligible.value &&
                              controller.firstChargeDate.isNotEmpty) ...[
                            _SummaryRow(
                              label: 'Billing starts',
                              value: controller.firstChargeDate,
                              valueColor: Colors.white70,
                            ),
                            _SummaryDivider(),
                          ],
                          _SummaryRow(
                            label: 'Due on purchase',
                            value:
                                '\$${controller.dueToday.toStringAsFixed(2)}',
                            valueColor: const Color(0xFF2ECC71),
                            isBold: true,
                          ),
                        ],
                      );
                    }),
                  ),

                  SizedBox(height: 24.h),

                  // ── Trial button — only when the backend allows it ────────
                  Obx(() {
                    if (!controller.isTrialEligible.value) {
                      return const SizedBox.shrink();
                    }
                    return Padding(
                      padding: EdgeInsets.only(bottom: 14.h),
                      child: CustomElevatedButton(
                        text: controller.trialDurationShortLabel.isEmpty
                            ? 'Start Free Trial  →'
                            : 'Start ${controller.trialDurationShortLabel} Free Trial  →',
                        onTap: controller.onStartFreeTrialPressed,
                        isLoading: controller.isPurchaseLoading.value,
                        backgroundColor: const Color(0xFF7B1FE0),
                        height: 54.h,
                        borderRadius: 13.r,
                      ),
                    );
                  }),

                  // ── Paid purchase ─────────────────────────────────────────
                  Obx(() => CustomElevatedButton(
                        text: 'Continue to Purchase  →',
                        onTap: controller.onPaidPurchasePressed,
                        isLoading: controller.isPurchaseLoading.value,
                        backgroundColor: controller.isTrialEligible.value
                            ? const Color(0xFF1B1830)
                            : const Color(0xFF7B1FE0),
                        height: 54.h,
                        borderRadius: 13.r,
                      )),

                  SizedBox(height: 14.h),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.lock_outline, size: 12.sp, color: Colors.white38),
                      SizedBox(width: 6.w),
                      Text(
                        'Card details are collected on Stripe secure checkout',
                        style: GoogleFonts.poppins(
                          fontSize: 11.sp,
                          color: Colors.white38,
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 24.h),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Plan summary: price + all features returned by the API ─────────────────

class _PlanSummaryCard extends StatelessWidget {
  final SubscriptionPlan plan;
  const _PlanSummaryCard({required this.plan});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(18.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFF2A1B4D).withValues(alpha: 0.9),
            const Color(0xFF1B1830).withValues(alpha: 0.9),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(18.r),
        border: Border.all(color: const Color(0xFF7B1FE0).withValues(alpha: 0.4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.asset(
                plan.localEmojiAsset,
                width: 30.w,
                height: 30.w,
                errorBuilder: (_, __, ___) => Icon(Icons.workspace_premium,
                    size: 26.sp, color: const Color(0xFFE0A11F)),
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${plan.name} Plan',
                      style: GoogleFonts.poppins(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                    if (plan.description.isNotEmpty)
                      Text(
                        plan.description,
                        style: GoogleFonts.poppins(
                          fontSize: 11.sp,
                          color: Colors.white54,
                        ),
                      ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '\$${plan.price.toStringAsFixed(2)}',
                    style: GoogleFonts.poppins(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFFE0A11F),
                    ),
                  ),
                  Text(
                    'per month',
                    style: GoogleFonts.poppins(
                      fontSize: 10.sp,
                      color: Colors.white38,
                    ),
                  ),
                ],
              ),
            ],
          ),

          SizedBox(height: 14.h),
          Divider(color: Colors.white.withValues(alpha: 0.12), thickness: 0.5),
          SizedBox(height: 12.h),

          Text(
            "WHAT'S INCLUDED",
            style: GoogleFonts.poppins(
              fontSize: 10.sp,
              fontWeight: FontWeight.w600,
              color: Colors.white38,
              letterSpacing: 1.2,
            ),
          ),
          SizedBox(height: 10.h),

          ...plan.features.map(
            (feature) => Padding(
              padding: EdgeInsets.only(bottom: 8.h),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.check_circle,
                      size: 15.sp, color: const Color(0xFF2ECC71)),
                  SizedBox(width: 8.w),
                  Expanded(
                    child: Text(
                      feature,
                      style: GoogleFonts.poppins(
                        fontSize: 12.sp,
                        color: Colors.white70,
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          Wrap(
            spacing: 8.w,
            runSpacing: 8.h,
            children: [
              _PlanChip(label: '${plan.maxSignalsPerDay} signals / day'),
              _PlanChip(label: '${plan.support} support'),
              if (plan.includesGoldSignals) _PlanChip(label: 'Gold signals'),
              if (plan.includesTechnicalAnalysis)
                _PlanChip(label: 'Technical analysis'),
              if (plan.includesMarketSentiment)
                _PlanChip(label: 'Market sentiment'),
              if (plan.includesEconomicCalendar)
                _PlanChip(label: 'Economic calendar'),
            ],
          ),
        ],
      ),
    );
  }
}

class _PlanChip extends StatelessWidget {
  final String label;
  const _PlanChip({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
      ),
      child: Text(
        label,
        style: GoogleFonts.poppins(fontSize: 10.sp, color: Colors.white60),
      ),
    );
  }
}

// ── Info card (trial available / unavailable / no plan) ────────────────────

class _InfoCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String message;
  final String? footnote;

  const _InfoCard({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.message,
    this.footnote,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: const Color(0xFF1B1830),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: iconColor.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, size: 18.sp, color: iconColor),
              SizedBox(width: 8.w),
              Expanded(
                child: Text(
                  title,
                  style: GoogleFonts.poppins(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          Text(
            message,
            style: GoogleFonts.poppins(
              fontSize: 12.sp,
              color: Colors.white70,
              height: 1.5,
            ),
          ),
          if (footnote != null) ...[
            SizedBox(height: 10.h),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.lock_outline, size: 12.sp, color: Colors.white38),
                SizedBox(width: 6.w),
                Expanded(
                  child: Text(
                    footnote!,
                    style: GoogleFonts.poppins(
                      fontSize: 11.sp,
                      color: Colors.white38,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

// ── Summary rows ──────────────────────────────────────────────────────────

class _SummaryDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5.h),
      child: Divider(
        color: Colors.white.withValues(alpha: 0.3),
        thickness: 0.5,
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final String label;
  final String value;
  final Color valueColor;
  final bool isBold;

  const _SummaryRow({
    required this.label,
    required this.value,
    required this.valueColor,
    this.isBold = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: 13.sp,
              fontWeight: FontWeight.w400,
              color: Colors.white54,
            ),
          ),
        ),
        SizedBox(width: 10.w),
        Flexible(
          child: Text(
            value,
            textAlign: TextAlign.right,
            style: GoogleFonts.poppins(
              fontSize: 13.sp,
              fontWeight: isBold ? FontWeight.w700 : FontWeight.w600,
              color: valueColor,
            ),
          ),
        ),
      ],
    );
  }
}
