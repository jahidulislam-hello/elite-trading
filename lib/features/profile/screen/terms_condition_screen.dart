import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controller/profile_controller.dart';
import '../management_service.dart';
import '../widget/policy_content.dart';

class TermsConditionScreen extends GetView<ProfileController> {
  const TermsConditionScreen({super.key});

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
                          child: Icon(Icons.arrow_back,
                              color: Colors.white, size: 18.sp),
                        ),
                      ),
                      SizedBox(width: 10.w),
                      Text(
                        'Terms & Conditions',
                        style: GoogleFonts.poppins(
                          fontSize: 22.sp,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFFFFFFFF),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 22.h),

                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(vertical: 30.h),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        colors: [
                          const Color(0xFF9E86FF).withValues(alpha: 0.45),
                          const Color(0xFF9E86FF).withValues(alpha: 0.15),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(24.r),
                      border: Border.all(
                          color: Colors.white.withValues(alpha: 0.08)),
                    ),
                    child: Center(
                      child: Image.asset(
                        "asset/image/profile/terms_condition.png",
                        height: 150.h,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),

                  SizedBox(height: 26.h),

                  Text(
                    'Terms & Conditions',
                    style: GoogleFonts.poppins(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),

                  SizedBox(height: 12.h),

                  const PolicyContent(type: ManagementType.terms),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
