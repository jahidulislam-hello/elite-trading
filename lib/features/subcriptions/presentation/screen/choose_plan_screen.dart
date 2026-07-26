import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../authentication/presentation/widget/Elevatedbutton.dart';
import '../controller/subscriptions_controller.dart';
import '../../data/model/plan_model.dart';

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

                  // Back button + progress bar
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () => Get.back(),
                        child: Container(
                          padding: EdgeInsets.all(8.w),
                          decoration: BoxDecoration(
                            color: const Color(0xFF73737380),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.chevron_left,
                            color: Colors.white,
                            size: 20.sp,
                          ),
                        ),
                      ),
                      SizedBox(width: 14.w),
                      Expanded(
                        child: Obx(
                              () => Row(
                            children: List.generate(
                              controller.totalSteps,
                                  (index) => Expanded(
                                child: Container(
                                  margin: EdgeInsets.symmetric(horizontal: 3.w),
                                  height: 5.h,
                                  decoration: BoxDecoration(
                                    color: index < controller.currentStep.value
                                        ? const Color(0xFF7B1FE0)
                                        : const Color(0xFFFFFFFF),
                                    borderRadius: BorderRadius.circular(10.r),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 14.w),
                      Obx(
                            () => Text(
                          '${controller.currentStep.value}/${controller.totalSteps}',
                          style: GoogleFonts.poppins(
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w500,
                            color: Colors.white70,
                          ),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 28.h),

                  // Title
                  Text(
                    'Choose Your Plan',
                    style: GoogleFonts.poppins(
                      fontSize: 24.sp,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    'Start with a free trial. Cancel anytime.',
                    style: GoogleFonts.poppins(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w400,
                      color: Colors.white54,
                    ),
                  ),

                  SizedBox(height: 24.h),

                  // Plan cards
                  Obx(
                        () => Column(
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
                    ),
                  ),

                  SizedBox(height: 8.h),

                  // Comparison table
                  _ComparisonTable(controller: controller),

                  SizedBox(height: 28.h),

                  // Continue button
                  Obx(
                        () => CustomElevatedButton(
                      text: 'Continue with ${controller.selectedPlan.title}  →',
                      onTap: controller.onContinuePressed,
                      isLoading: false,
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

class _PlanCard extends StatelessWidget {
  final PlanModel plan;
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
                    Container(
                      child:Image.asset(plan.emoji),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            plan.title,
                            style: GoogleFonts.poppins(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: 2.h),
                          Text(
                            plan.subtitle,
                            style: GoogleFonts.poppins(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w400,
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
                              '${plan.price}',
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
                            fontWeight: FontWeight.w400,
                            color: Colors.white38,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 14.h),
                ...List.generate(
                  plan.features.length,
                      (i) => plan.features[i]
                      ? Padding(
                    padding: EdgeInsets.only(bottom: 6.h),
                    child: Row(
                      children: [
                        Icon(
                          Icons.check_circle,
                          size: 14.sp,
                          color: isSelected
                              ? const Color(0xFF7B1FE0)
                              : const Color(0xFFFFFFFFFF).withValues(alpha: 0.2),
                        ),
                        SizedBox(width: 8.w),
                        Text(
                          _featureLabel(i),
                          style: GoogleFonts.poppins(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w400,
                            color: Colors.white70,
                          ),
                        ),
                      ],
                    ),
                  )
                      : const SizedBox.shrink(),
                ),
              ],
            ),
          ),
          if (plan.isPopular)
            Positioned(
              top: -12.h,
              left: 0,
              right: 0,
              child: Center(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 4.h),
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

  String _featureLabel(int index) {
    // Map plan.features[index] to real labels per plan type.
    const labels = [
      'All Forex & Currency Signals',
      'All Crypto & Altcoin Signals',
      'Gold, Silver & Commodities',
      'Stock Index Signals',
    ];
    return labels[index];
  }
}

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
                child: Text(
                  'FEATURES',
                  style: GoogleFonts.poppins(
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.white38,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
              Expanded(
                child: Center(
                  child: Text(
                    'Crypto',
                    style: GoogleFonts.poppins(
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.white38,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Center(
                  child: Text(
                    'Forex',
                    style: GoogleFonts.poppins(
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.white38,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Center(
                  child: Text(
                    'VIP',
                    style: GoogleFonts.poppins(
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFFE0A11F),
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
                    child: Text(
                      row.label,
                      style: GoogleFonts.poppins(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w400,
                        color: Colors.white70,
                      ),
                    ),
                  ),
                  ...row.checks.asMap().entries.map(
                        (entry) => Expanded(
                      child: Center(
                        child: entry.value
                            ? Icon(
                          Icons.check_circle,
                          size: 15.sp,
                          color: entry.key == 2
                              ? const Color(0xFFE0A11F)
                              : const Color(0xFF2ECC71),
                        )
                            : Icon(
                          Icons.close,
                          size: 15.sp,
                          color: Colors.white24,
                        ),
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