import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../authentication/presentation/widget/Elevatedbutton.dart';
import '../controller/subscriptions_controller.dart';
import '../../data/model/subscription_models.dart';
import '../../data/model/plan_model.dart';
import '../widget/progress_step_header.dart';

class ChoosePlanScreen extends GetView<SubscriptionsController> {
  const ChoosePlanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
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
                  ProgressStepHeader(currentStep: 2, totalSteps: 4),
                  SizedBox(height: 28.h),

                  Text(
                    'Choose Your Plan',
                    style: GoogleFonts.poppins(
                      fontSize: 24.sp,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Obx(() => Text(
                    controller.isTrialEligible.value
                        ? 'Start with a free trial. Cancel anytime.'
                        : 'Choose the plan that fits you best.',
                    style: GoogleFonts.poppins(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w400,
                      color: Colors.white54,
                    ),
                  )),

                  SizedBox(height: 24.h),

                  // ── Plan cards with loader / error / data states ──────────
                  Obx(() {
                    if (controller.isPlansLoading.value) {
                      return _PlansLoader();
                    }
                    if (controller.plansError.value.isNotEmpty) {
                      return _PlansError(
                        message: controller.plansError.value,
                        onRetry: controller.loadPlans,
                      );
                    }
                    if (controller.plans.isEmpty) {
                      return _PlansError(
                        message: 'No plans available right now.',
                        onRetry: controller.loadPlans,
                      );
                    }
                    return Column(
                      children: controller.plans
                          .map(
                            (plan) => Padding(
                              padding: EdgeInsets.only(bottom: 14.h),
                              child: _PlanCard(
                                plan: plan,
                                isSelected:
                                    controller.selectedPlanId.value == plan.id,
                                onTap: () => controller.selectPlan(plan.id),
                              ),
                            ),
                          )
                          .toList(),
                    );
                  }),

                  SizedBox(height: 8.h),

                  // Comparison table (static)
                  _ComparisonTable(controller: controller),

                  SizedBox(height: 28.h),

                  Obx(
                    () => CustomElevatedButton(
                      text: controller.selectedPlan != null
                          ? (controller.isTrialEligible.value
                              ? 'Start Free Trial with ${controller.selectedPlan!.name}  →'
                              : 'Continue with ${controller.selectedPlan!.name}  →')
                          : 'Continue  →',
                      onTap: controller.onContinuePressed,
                      isLoading: controller.isPlansLoading.value,
                      backgroundColor: const Color(0xFF7B1FE0),
                      height: 54.h,
                      borderRadius: 13.r,
                    ),
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

// ── Loader skeleton ────────────────────────────────────────────────────────

class _PlansLoader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(
        3,
        (i) => Padding(
          padding: EdgeInsets.only(bottom: 14.h),
          child: Container(
            height: 120.h,
            decoration: BoxDecoration(
              color: const Color(0xFF1B1830),
              borderRadius: BorderRadius.circular(16.r),
            ),
            child: const Center(
              child: CircularProgressIndicator(
                color: Color(0xFF7B1FE0),
                strokeWidth: 2,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ── Error state ────────────────────────────────────────────────────────────

class _PlansError extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _PlansError({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: const Color(0xFF1B1830),
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        children: [
          Icon(Icons.error_outline, color: Colors.redAccent, size: 32.sp),
          SizedBox(height: 10.h),
          Text(
            message,
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(fontSize: 13.sp, color: Colors.white54),
          ),
          SizedBox(height: 14.h),
          TextButton(
            onPressed: onRetry,
            child: Text(
              'Retry',
              style: GoogleFonts.poppins(
                  fontSize: 13.sp, color: const Color(0xFF7B1FE0)),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Plan card ──────────────────────────────────────────────────────────────

class _PlanCard extends StatelessWidget {
  final SubscriptionPlan plan;
  final bool isSelected;
  final VoidCallback onTap;

  const _PlanCard({
    required this.plan,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: const Color(0xFF1B1830),
              borderRadius: BorderRadius.circular(16.r),
              border: Border.all(
                color: isSelected
                    ? const Color(0xFF7B1FE0)
                    : Colors.white.withValues(alpha: 0.06),
                width: isSelected ? 1.5 : 1,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Image.asset(plan.localEmojiAsset, width: 32.w),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            plan.name,
                            style: GoogleFonts.poppins(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: 2.h),
                          Text(
                            plan.description,
                            style: GoogleFonts.poppins(
                              fontSize: 12.sp,
                              color: Colors.white54,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '\$',
                              style: GoogleFonts.poppins(
                                fontSize: 13.sp,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              plan.price.toStringAsFixed(0),
                              style: GoogleFonts.poppins(
                                fontSize: 20.sp,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                          ],
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

                if (plan.features.isNotEmpty) ...[
                  SizedBox(height: 14.h),
                  ...plan.features.take(4).map(
                        (f) => Padding(
                          padding: EdgeInsets.only(bottom: 6.h),
                          child: Row(
                            children: [
                              Icon(
                                Icons.check_circle,
                                size: 14.sp,
                                color: isSelected
                                    ? const Color(0xFF7B1FE0)
                                    : Colors.white24,
                              ),
                              SizedBox(width: 8.w),
                              Expanded(
                                child: Text(
                                  f,
                                  style: GoogleFonts.poppins(
                                    fontSize: 12.sp,
                                    color: Colors.white70,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                ],
              ],
            ),
          ),

          // "Most Popular" badge
          if (plan.isPopular)
            Positioned(
              top: -12.h,
              left: 0,
              right: 0,
              child: Center(
                child: Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 14.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: const Color(0xFF7B1FE0),
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: Text(
                    'Most Popular',
                    style: GoogleFonts.poppins(
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),

          // Selected checkmark
          if (isSelected)
            Positioned(
              top: 2.h,
              right: 10.w,
              child: Container(
                padding: EdgeInsets.all(3.w),
                decoration: const BoxDecoration(
                  color: Color(0xFF8000FF),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.check, size: 12.sp, color: Colors.white),
              ),
            ),
        ],
      ),
    );
  }
}

// ── Comparison table ───────────────────────────────────────────────────────

class _ComparisonTable extends StatelessWidget {
  final SubscriptionsController controller;
  const _ComparisonTable({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: const Color(0xFF1B1830),
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: Colors.white.withValues(alpha: 0.06)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                flex: 2,
                child: Text('FEATURES',
                    style: GoogleFonts.poppins(
                        fontSize: 10.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.white38,
                        letterSpacing: 0.5)),
              ),
              ...['Crypto', 'Forex', 'VIP'].asMap().entries.map(
                    (e) => Expanded(
                      child: Center(
                        child: Text(
                          e.value,
                          style: GoogleFonts.poppins(
                            fontSize: 10.sp,
                            fontWeight: FontWeight.w600,
                            color: e.key == 2
                                ? const Color(0xFFE0A11F)
                                : Colors.white38,
                          ),
                        ),
                      ),
                    ),
                  ),
            ],
          ),
          SizedBox(height: 12.h),
          ...controller.comparisonRows.map(
            (row) => Padding(
              padding: EdgeInsets.only(bottom: 12.h),
              child: Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Text(row.label,
                        style: GoogleFonts.poppins(
                            fontSize: 12.sp, color: Colors.white70)),
                  ),
                  ...row.checks.asMap().entries.map(
                        (e) => Expanded(
                          child: Center(
                            child: e.value
                                ? Icon(Icons.check_circle_outline,
                                    size: 15.sp,
                                    color: e.key == 2
                                        ? const Color(0xFFE0A11F)
                                        : const Color(0xFF2ECC71))
                                : Icon(Icons.close,
                                    size: 15.sp, color: Colors.white24),
                          ),
                        ),
                      ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
