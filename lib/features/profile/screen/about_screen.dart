import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controller/profile_controller.dart';
import '../widget/policy_content.dart';

class AboutScreen extends GetView<ProfileController> {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 24.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // -------- Header --------
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () => Get.back(),
                        child: Container(
                          padding: EdgeInsets.all(10.w),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.08),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(Icons.arrow_back, color: Colors.white, size: 18.sp),
                        ),
                      ),
                      SizedBox(width: 10.w),
                      Text(
                        'About Elite Trading',
                        style: GoogleFonts.poppins(
                          fontSize: 22.sp,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFFFFFFF),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 34.h),

                  // -------- Logo --------
                  Center(
                    child: Image.asset(
                      "asset/image/onboarding/logo.png",
                      height: 160.h,
                      fit: BoxFit.contain,
                    ),
                  ),

                  SizedBox(height: 34.h),

                  Text(
                    'Privacy Policy',
                    style: GoogleFonts.poppins(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),

                  SizedBox(height: 12.h),

                  // -------- Policy text card --------
                  const PolicyContent(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}