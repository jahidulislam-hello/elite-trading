import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../authentication/presentation/widget/Elevatedbutton.dart';
import '../../data/model/plan_model.dart';
import '../controller/subscriptions_controller.dart';
import '../widget/progress_step_header.dart';

class ConformTrial extends GetView<SubscriptionsController> {
  const ConformTrial({super.key});

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
                  ProgressStepHeader(
                    currentStep: 4,
                    totalSteps: 4,
                  ),

                  SizedBox(height: 28.h),

                  Text(
                    'Confirm Your Trial',
                    style: GoogleFonts.poppins(
                      fontSize: 24.sp,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    'Review your plan before activating.',
                    style: GoogleFonts.poppins(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w400,
                      color: Colors.white54,
                    ),
                  ),

                  SizedBox(height: 22.h),

                  // Founding member badge

                  SizedBox(height: 14.h),

                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(18.w),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          const Color(0xFFBFA06D).withValues(alpha: 0.13),
                          const Color(0xFFD7C48D).withValues(alpha: 0.7),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(16.r),
                      border: Border.all(
                          color: const Color(0xFFE0A11F).withValues(alpha: 0.3)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 5.h),
                          decoration: BoxDecoration(
                            color: const Color(0xFF00000000).withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(20.r),
                            border: Border.all(color: Color(0xFFBFA06D))
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.emoji_events,
                                  size: 12.sp, color: const Color(0xFFE0A11F)),
                              SizedBox(width: 6.w),
                              Text(
                                'FOUNDING MEMBER · TOP 100',
                                style: GoogleFonts.poppins(
                                  fontSize: 9.sp,
                                  fontWeight: FontWeight.w600,
                                  color: const Color(0xFFE0A11F),
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Text(
                          '1 Month Free',
                          style: GoogleFonts.poppins(
                            fontSize: 26.sp,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFFE0A11F),
                          ),
                        ),
                        SizedBox(height: 6.h),
                        Text(
                          "You're one of our first 100 members.",
                          style: GoogleFonts.poppins(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w400,
                            color: Colors.white70,
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 20.h),

                  // Plan details card
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
                          _DetailRow(
                            label: 'Plan',
                            value:
                            '${controller.selectedPlan.title} — \$${controller.selectedPlan.price}/mo',
                            valueColor: Colors.white,
                            isBold: true,
                          ),
                          SizedBox(height: 5.h),
                          Divider(color: Colors.white.withValues(alpha: 0.3),thickness: 0.5,),
                          SizedBox(height: 5.h),
                          _DetailRow(
                            label: 'Trial Period',
                            value: '1 Month Free',
                            valueColor: const Color(0xFF7B1FE0),
                          ),
                          SizedBox(height: 5.h),
                          Divider(color: Colors.white.withValues(alpha: 0.3),thickness: 0.5,),
                          SizedBox(height: 5.h),
                          _DetailRow(
                            label: 'First Charge',
                            value: controller.firstChargeDate,
                            valueColor: Colors.white,
                          ),
                          SizedBox(height: 5.h),
                          Divider(color: Colors.white.withValues(alpha: 0.3),thickness: 0.5,),
                          SizedBox(height: 5.h),
                          _DetailRow(
                            label: 'Due Today',
                            value: '\$${controller.dueToday.toStringAsFixed(2)}',
                            valueColor: const Color(0xFF2ECC71),
                            isBold: true,
                          ),
                        ],
                      ),
                    ),
                  ),

                  SizedBox(height: 20.h),

                  // Included features
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(16.w),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1B1830),
                      borderRadius: BorderRadius.circular(14.r),
                      border: Border.all(color: Colors.white.withValues(alpha: 0.06)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'INCLUDED IN YOUR PLAN',
                          style: GoogleFonts.poppins(
                            fontSize: 10.sp,
                            fontWeight: FontWeight.w600,
                            color: Colors.white38,
                            letterSpacing: 0.5,
                          ),
                        ),
                        SizedBox(height: 12.h),
                        ...trialIncludedFeatures.map(
                              (feature) => Padding(
                            padding: EdgeInsets.only(bottom: 10.h),
                            child: Row(
                              children: [
                                Icon(Icons.check_circle_outline,
                                    size: 14.sp, color: const Color(0xFF7B1FE0)),
                                SizedBox(width: 8.w),
                                Text(
                                  feature.label,
                                  style: GoogleFonts.poppins(
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.white70,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 16.h),

                  // Warning/disclaimer
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(14.w),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFF5A6B0F).withValues(alpha: 0.06),
                      borderRadius: BorderRadius.circular(12.r),
                      border: Border.all(
                          color: const Color(0xFFFF5A6B26).withValues(alpha: 0.5)),
                    ),
                    child: Obx(
                          () => Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(Icons.error_outline,
                              size: 14.sp, color: const Color(0xFFFF5A6B)),
                          SizedBox(width: 8.w),
                          Expanded(
                            child: Text(
                              'Your subscription will automatically renew at \$${controller.selectedPlan.price}/month on ${controller.firstChargeDate} unless you cancel before that date. Cancel anytime in Settings.',
                              style: GoogleFonts.poppins(
                                fontSize: 11.sp,
                                fontWeight: FontWeight.w400,
                                color: Colors.white54,
                                height: 1.5,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  SizedBox(height: 24.h),

                  CustomElevatedButton(
                    text: 'Start Free Trial  →',
                    onTap: controller.onStartFreeTrialPressed,
                    isLoading: false,
                    backgroundColor: const Color(0xFFBFA06D),
                    textColor: Colors.black87,
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

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;
  final Color valueColor;
  final bool isBold;

  const _DetailRow({
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
            fontSize: 14.sp,
            fontWeight: isBold ? FontWeight.w700 : FontWeight.w600,
            color: valueColor,
          ),
        ),
      ],
    );
  }
}