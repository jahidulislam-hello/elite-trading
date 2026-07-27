import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../authentication/presentation/widget/Elevatedbutton.dart';
import '../controller/subscriptions_controller.dart';
import '../widget/progress_step_header.dart';

class SubscripFirstPage extends GetView<SubscriptionsController> {
  const SubscripFirstPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Stack(
        children: [
          // Base background
          Positioned.fill(
            child: Image.asset(
              "asset/image/onboarding/background.png",
              fit: BoxFit.cover,
            ),
          ),

          // Content
          SafeArea(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 16.h),

                  // Back button + progress bar
                  ProgressStepHeader(
                    currentStep: 1,
                    totalSteps: 4,
                  ),

                  SizedBox(height: 32.h),

                  // Premium image
                  Center(
                    child: Image.asset(
                      "asset/image/subcription/prmium.png",
                      height: 180.h,
                      fit: BoxFit.contain,
                    ),
                  ),

                  SizedBox(height: 28.h),

                  // Title
                  Text(
                    'Elite Trading Premium',
                    style: GoogleFonts.poppins(
                      fontSize: 24.sp,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),

                  SizedBox(height: 10.h),

                  // Subtitle
                  Text(
                    'Institutional-grade trading signals delivered directly to your device. Join 1,200+ traders who trust Elite Trading.',
                    style: GoogleFonts.poppins(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w400,
                      color: Colors.white54,
                      height: 1.5,
                    ),
                  ),

                  SizedBox(height: 28.h),

                  // Feature cards
                  _FeatureItem(
                    image: "asset/icon/subscription/precision.png",
                    title: 'Precision Entry Signals',
                    subtitle: 'Exact entry, stop loss & take profit levels',
                  ),
                  SizedBox(height: 12.h),
                  _FeatureItem(
                    image: "asset/icon/subscription/rington.png",
                    title: 'Real-time Push Alerts',
                    subtitle: 'Receive signals within 60 seconds of publishing',
                  ),
                  SizedBox(height: 12.h),
                  _FeatureItem(
                    image: "asset/icon/subscription/chart.png",
                    title: 'Full Risk Management',
                    subtitle: 'R:R ratios, position sizing & exit strategies',
                  ),

                  SizedBox(height: 32.h),

                  // Explore Plans button
                  CustomElevatedButton(
                    text: 'Explore Plans  →',
                    onTap: controller.onExplorePlansPressed,
                    isLoading: false,
                    backgroundColor: const Color(0xFF7B1FE0),
                    height: 54.h,
                    borderRadius: 13.r,
                  ),

                  SizedBox(height: 14.h),

                  // Footer text
                  Center(
                    child: Text(
                      'No commitment · Cancel anytime · Free trial available',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w400,
                        color: Colors.white38,
                      ),
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

class _FeatureItem extends StatelessWidget {
  final String image;
  final String title;
  final String subtitle;

  const _FeatureItem({
    required this.image,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: const Color(0xFF1B1830),
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: Colors.white.withValues(alpha: 0.06)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            child: Image.asset(image),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.poppins(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 3.h),
                Text(
                  subtitle,
                  style: GoogleFonts.poppins(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w400,
                    color: Colors.white54,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}