import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../authentication/presentation/widget/Elevatedbutton.dart';
import '../../data/model/plan_model.dart';
import '../controller/subscriptions_controller.dart';

class AddPrementScreen extends GetView<SubscriptionsController> {
  const AddPrementScreen({super.key});

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
                  _ProgressHeader(controller: controller),

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
                  Text(
                    "You won't be charged until your free trial ends.",
                    style: GoogleFonts.poppins(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w400,
                      color: Colors.white54,
                    ),
                  ),

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
                    children: [
                      Expanded(
                        child: Container(
                          height: 46.h,
                          padding: EdgeInsets.symmetric(horizontal: 14.w),
                          decoration: BoxDecoration(
                            color: const Color(0xFF1B1830),
                            borderRadius: BorderRadius.circular(12.r),
                            border: Border.all(
                                color: Colors.white.withValues(alpha: 0.06)),
                          ),
                          child: TextField(
                            controller: controller.couponController,
                            style: GoogleFonts.poppins(
                              fontSize: 13.sp,
                              color: Colors.white,
                            ),
                            decoration: InputDecoration(
                              hintText: 'Enter coupon code',
                              hintStyle: GoogleFonts.poppins(
                                fontSize: 13.sp,
                                color: Colors.white38,
                              ),
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 10.w),
                      GestureDetector(
                        onTap: controller.applyCoupon,
                        child: Container(
                          height: 46.h,
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

                  // Card preview — NOTE: no Obx wrapper here, _CardPreview
                  // has its own internal Obx for the coupon badge.
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
                  _InputField(
                    controller: controller.cardNumberController,
                    hint: '1234 5678 9012 3456',
                    icon: Icons.credit_card,
                    keyboardType: TextInputType.number,
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
                  _InputField(
                    controller: controller.cardHolderController,
                    hint: 'Alex Kim',
                    icon: Icons.person_outline,
                  ),

                  SizedBox(height: 16.h),

                  Row(
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
                            _InputField(
                              controller: controller.expiryController,
                              hint: 'MM/YY',
                              keyboardType: TextInputType.datetime,
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
                            _InputField(
                              controller: controller.cvcController,
                              hint: '•••',
                              keyboardType: TextInputType.number,
                              obscureText: true,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

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
                            value:
                            '${controller.selectedPlan.title} — \$${controller.selectedPlan.price}/mo',
                            valueColor: Colors.white,
                          ),
                          SizedBox(height: 10.h),
                          if (controller.isCouponApplied.value) ...[
                            _SummaryRow(
                              label: 'Coupon Discount',
                              value:
                              '-\$${controller.couponDiscount.value.toStringAsFixed(2)}',
                              valueColor: const Color(0xFF2ECC71),
                            ),
                            SizedBox(height: 10.h),
                          ],
                          _SummaryRow(
                            label: 'Trial Period',
                            value: '1 Month Free',
                            valueColor: const Color(0xFF7B1FE0),
                          ),
                          SizedBox(height: 10.h),
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

                  CustomElevatedButton(
                    text: 'Continue  →',
                    onTap: controller.onAddPaymentContinuePressed,
                    isLoading: false,
                    backgroundColor: const Color(0xFF7B1FE0),
                    height: 54.h,
                    borderRadius: 13.r,
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

class _ProgressHeader extends StatelessWidget {
  final SubscriptionsController controller;
  const _ProgressHeader({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        GestureDetector(
          onTap: () => Get.back(),
          child: Container(
            padding: EdgeInsets.all(8.w),
            decoration: const BoxDecoration(
              color: Color(0xFF73737380),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.chevron_left, color: Colors.white, size: 20.sp),
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

class _InputField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final IconData? icon;
  final TextInputType? keyboardType;
  final bool obscureText;

  const _InputField({
    required this.controller,
    required this.hint,
    this.icon,
    this.keyboardType,
    this.obscureText = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50.h,
      padding: EdgeInsets.symmetric(horizontal: 14.w),
      decoration: BoxDecoration(
        color: const Color(0xFF1B1830),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: Colors.white.withValues(alpha: 0.06)),
      ),
      child: Row(
        children: [
          if (icon != null) ...[
            Icon(icon, size: 16.sp, color: Colors.white38),
            SizedBox(width: 10.w),
          ],
          Expanded(
            child: TextField(
              controller: controller,
              keyboardType: keyboardType,
              obscureText: obscureText,
              style: GoogleFonts.poppins(fontSize: 13.sp, color: Colors.white),
              decoration: InputDecoration(
                hintText: hint,
                hintStyle: GoogleFonts.poppins(
                  fontSize: 13.sp,
                  color: Colors.white38,
                ),
                border: InputBorder.none,
              ),
            ),
          ),
        ],
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