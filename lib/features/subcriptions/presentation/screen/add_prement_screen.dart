import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/utils/customeTextField/custom_text_field.dart';
import '../../../authentication/presentation/widget/Elevatedbutton.dart';
import '../../data/model/plan_model.dart';
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
                  ProgressStepHeader(
                    currentStep: 3,
                    totalSteps: 4,
                  ),

                  SizedBox(height: 28.h),

                  Text(
                    'Add Payment Method',
                    style: GoogleFonts.poppins(
                      fontSize: 24.sp,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Obx(() => Text(
                    controller.isTrialEligible.value
                        ? "You won't be charged until your free trial ends."
                        : "Complete your payment to activate your subscription.",
                    style: GoogleFonts.poppins(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w400,
                      color: Colors.white54,
                    ),
                  )),

                  SizedBox(height: 22.h),

                  // Payment method tabs
                  Obx(
                        () => Row(
                      children: [
                        Expanded(
                          child: _PaymentTab(
                            icon: Icons.credit_card,
                            emoji: null,
                            label: 'Card',
                            isSelected: controller.selectedPaymentMethod.value ==
                                PaymentMethod.card,
                            onTap: () => controller
                                .selectPaymentMethod(PaymentMethod.card),
                          ),
                        ),
                        SizedBox(width: 10.w),
                        Expanded(
                          child: _PaymentTab(
                            emoji: '🍎',
                            label: 'Apple Pay',
                            isSelected: controller.selectedPaymentMethod.value ==
                                PaymentMethod.applePay,
                            onTap: () => controller
                                .selectPaymentMethod(PaymentMethod.applePay),
                          ),
                        ),
                        SizedBox(width: 10.w),
                        Expanded(
                          child: _PaymentTab(
                            emoji: '🇬',
                            label: 'Google Pay',
                            isSelected: controller.selectedPaymentMethod.value ==
                                PaymentMethod.googlePay,
                            onTap: () => controller
                                .selectPaymentMethod(PaymentMethod.googlePay),
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 22.h),

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
                    crossAxisAlignment: CrossAxisAlignment.start,
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
                      Padding(
                        padding: EdgeInsets.only(top: 0),
                        child: GestureDetector(
                          onTap: controller.applyCoupon,
                          child: Container(
                            height: 50.h,
                            padding: EdgeInsets.symmetric(horizontal: 22.w),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: const Color(0xFF7B1FE0),
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                            child: Text(
                              'Apply',
                              style: GoogleFonts.poppins(
                                fontSize: 13.sp,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  Obx(
                        () => controller.isCouponApplied.value
                        ? Padding(
                      padding: EdgeInsets.only(top: 10.h),
                      child: Row(
                        children: [
                          Icon(Icons.check_circle,
                              size: 14.sp, color: const Color(0xFF2ECC71)),
                          SizedBox(width: 6.w),
                          Text(
                            'Coupon Applied — ${controller.couponCode.value}',
                            style: GoogleFonts.poppins(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w500,
                              color: const Color(0xFF2ECC71),
                            ),
                          ),
                          SizedBox(width: 4.w),
                          Text(
                            '(20% off)',
                            style: GoogleFonts.poppins(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w400,
                              color: Colors.white54,
                            ),
                          ),
                        ],
                      ),
                    )
                        : const SizedBox.shrink(),
                  ),

                  SizedBox(height: 22.h),

                  // Card fields — hidden when free trial eligible
                  Obx(() {
                    if (controller.isTrialEligible.value) {
                      // Free trial: show a friendly info box instead
                      return Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(18.w),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              const Color(0xFFBFA06D).withValues(alpha: 0.13),
                              const Color(0xFF7B1FE0).withValues(alpha: 0.15),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(16.r),
                          border: Border.all(
                            color: const Color(0xFF7B1FE0).withValues(alpha: 0.4),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(Icons.verified_outlined,
                                    size: 18.sp, color: const Color(0xFF7B1FE0)),
                                SizedBox(width: 8.w),
                                Text(
                                  'Free Trial Available',
                                  style: GoogleFonts.poppins(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 8.h),
                            Text(
                              'You qualify for a 1-month free trial. No payment is required today. Your subscription begins only after the trial ends.',
                              style: GoogleFonts.poppins(
                                fontSize: 12.sp,
                                color: Colors.white70,
                                height: 1.5,
                              ),
                            ),
                            SizedBox(height: 12.h),
                            Row(
                              children: [
                                Icon(Icons.lock_outline,
                                    size: 12.sp, color: Colors.white38),
                                SizedBox(width: 6.w),
                                Text(
                                  'No credit card required to start',
                                  style: GoogleFonts.poppins(
                                    fontSize: 11.sp,
                                    color: Colors.white38,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    }

                    // Paid plan: show card fields
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _CardPreview(controller: controller),
                        SizedBox(height: 22.h),
                        Text(
                          'Card Number',
                          style: GoogleFonts.poppins(
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w500,
                            color: Colors.white70,
                          ),
                        ),
                        SizedBox(height: 8.h),
                        CustomTextField(
                          controller: controller.cardNumberController,
                          hintText: '1234 5678 9012 3456',
                          keyboardType: TextInputType.number,
                          prefixIcon: Icon(Icons.credit_card, size: 16.sp),
                          iconColor: Colors.white38,
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
                        SizedBox(height: 16.h),
                        Text(
                          'Cardholder Name',
                          style: GoogleFonts.poppins(
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w500,
                            color: Colors.white70,
                          ),
                        ),
                        SizedBox(height: 8.h),
                        CustomTextField(
                          controller: controller.cardHolderController,
                          hintText: 'Alex Kim',
                          prefixIcon: Icon(Icons.person_outline, size: 16.sp),
                          iconColor: Colors.white38,
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
                        SizedBox(height: 16.h),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Expiry',
                                    style: GoogleFonts.poppins(
                                      fontSize: 13.sp,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.white70,
                                    ),
                                  ),
                                  SizedBox(height: 8.h),
                                  CustomTextField(
                                    controller: controller.expiryController,
                                    hintText: 'MM/YY',
                                    keyboardType: TextInputType.datetime,
                                    filColor: const Color(0xFF1B1830),
                                    hinTextColor: Colors.white,
                                    borderColor:
                                        Colors.white.withValues(alpha: 0.06),
                                    borderRadius: 12,
                                    borderHeight: 1,
                                    contentPaddingHorizontal: 14,
                                    contentPaddingVertical: 14,
                                    hinTextSize: 13,
                                    isvalidation: false,
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(width: 14.w),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'CVC',
                                    style: GoogleFonts.poppins(
                                      fontSize: 13.sp,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.white70,
                                    ),
                                  ),
                                  SizedBox(height: 8.h),
                                  CustomTextField(
                                    controller: controller.cvcController,
                                    hintText: '•••',
                                    keyboardType: TextInputType.number,
                                    isPassword: true,
                                    iconColor: Colors.white38,
                                    filColor: const Color(0xFF1B1830),
                                    hinTextColor: Colors.white,
                                    borderColor:
                                        Colors.white.withValues(alpha: 0.06),
                                    borderRadius: 12,
                                    borderHeight: 1,
                                    contentPaddingHorizontal: 14,
                                    contentPaddingVertical: 14,
                                    hinTextSize: 13,
                                    isvalidation: false,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    );
                  }),

                  SizedBox(height: 22.h),

                  // Summary
                  Container(
                    padding: EdgeInsets.all(16.w),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1B1830),
                      borderRadius: BorderRadius.circular(14.r),
                      border: Border.all(color: Colors.white.withValues(alpha: 0.06)),
                    ),
                    child: Obx(
                          () => Column(
                        children: [
                          _SummaryRow(
                            label: 'Plan',
                            value: controller.selectedPlan != null
                                ? '${controller.selectedPlan!.name} — \$${controller.selectedPlan!.price.toStringAsFixed(0)}/mo'
                                : '—',
                            valueColor: Colors.white,
                          ),
                          SizedBox(height: 5.h),
                          Divider(color: Colors.white.withValues(alpha: 0.3),thickness: 0.5,),
                          SizedBox(height: 5.h),
                          if (controller.isCouponApplied.value) ...[
                            _SummaryRow(
                              label: 'Coupon Discount',
                              value:
                              '-\$${controller.couponDiscount.value.toStringAsFixed(2)}',
                              valueColor: const Color(0xFF2ECC71),
                              isBold: true,
                            ),
                            SizedBox(height: 5.h),
                            Divider(color: Colors.white.withValues(alpha: 0.3),thickness: 0.5,),
                            SizedBox(height: 5.h),
                          ],
                          _SummaryRow(
                            label: 'Trial Period',
                            value: controller.isTrialEligible.value
                                ? '1 Month Free'
                                : 'No trial available',
                            valueColor: const Color(0xFF7B1FE0),
                          ),
                          SizedBox(height: 5.h),
                          Divider(color: Colors.white.withValues(alpha: 0.3),thickness: 0.5,),
                          SizedBox(height: 5.h),
                          _SummaryRow(
                            label: 'Due Today',
                            value: '\$${controller.dueToday.toStringAsFixed(2)}',
                            valueColor: const Color(0xFF2ECC71),
                            isBold: true,
                          ),
                        ],
                      ),
                    ),
                  ),

                  SizedBox(height: 28.h),

                  Obx(
                    () => CustomElevatedButton(
                      text: controller.isTrialEligible.value
                          ? 'Continue  →'
                          : 'Purchase Plan  →',
                      onTap: controller.onAddPaymentContinuePressed,
                      isLoading: controller.isPurchaseLoading.value,
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

class _PaymentTab extends StatelessWidget {
  final IconData? icon;
  final String? emoji;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _PaymentTab({
    this.icon,
    this.emoji,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 46.h,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF7B1FE0) : const Color(0xFF1B1830),
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: isSelected
                ? const Color(0xFF7B1FE0)
                : Colors.white.withValues(alpha: 0.06),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (emoji != null)
              Text(emoji!, style: TextStyle(fontSize: 14.sp))
            else
              Icon(icon, size: 16.sp, color: Colors.white),
            SizedBox(width: 6.w),
            Text(
              label,
              style: GoogleFonts.poppins(
                fontSize: 12.sp,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// _CardPreview — StatelessWidget, so plain (non-Rx) text values are read
// once at build time (only refreshes on manual setState/hot-reload unless
// wired to Rx). The Obx below covers only the coupon badge, which IS Rx.
class _CardPreview extends StatelessWidget {
  final SubscriptionsController controller;
  const _CardPreview({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(20.w),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF2A1B4D), Color(0xFF1B1830)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(color: Colors.white.withValues(alpha: 0.06)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: 34.w,
                    height: 24.h,
                    decoration: BoxDecoration(
                      color: const Color(0xFFE0A11F),
                      borderRadius: BorderRadius.circular(4.r),
                    ),
                  ),
                  Text(
                    'ELITE TRADING',
                    style: GoogleFonts.poppins(
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.white70,
                      letterSpacing: 1,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 22.h),
              Text(
                controller.cardNumberController.text.isEmpty
                    ? '••••  ••••  ••••  ••••'
                    : controller.cardNumberController.text,
                style: GoogleFonts.poppins(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                  letterSpacing: 2,
                ),
              ),
              SizedBox(height: 18.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'CARD HOLDER',
                        style: GoogleFonts.poppins(
                          fontSize: 8.sp,
                          color: Colors.white38,
                        ),
                      ),
                      Text(
                        controller.cardHolderController.text.isEmpty
                            ? 'YOUR NAME'
                            : controller.cardHolderController.text.toUpperCase(),
                        style: GoogleFonts.poppins(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        'EXPIRES',
                        style: GoogleFonts.poppins(
                          fontSize: 8.sp,
                          color: Colors.white38,
                        ),
                      ),
                      Text(
                        controller.expiryController.text.isEmpty
                            ? 'MM/YY'
                            : controller.expiryController.text,
                        style: GoogleFonts.poppins(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
        Obx(
              () => controller.isCouponApplied.value
              ? Positioned(
            top: -10.h,
            right: 14.w,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 5.h),
              decoration: BoxDecoration(
                color: const Color(0xFFE0A11F),
                borderRadius: BorderRadius.circular(20.r),
              ),
              child: Text(
                'BEST VALUE - 20% OFF',
                style: GoogleFonts.poppins(
                  fontSize: 9.sp,
                  fontWeight: FontWeight.w700,
                  color: Colors.black87,
                ),
              ),
            ),
          )
              : const SizedBox.shrink(),
        ),
      ],
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
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 13.sp,
            fontWeight: FontWeight.w400,
            color: Colors.white54,
          ),
        ),
        Text(
          value,
          style: GoogleFonts.poppins(
            fontSize: 13.sp,
            fontWeight: isBold ? FontWeight.w700 : FontWeight.w600,
            color: valueColor,
          ),
        ),
      ],
    );
  }
}