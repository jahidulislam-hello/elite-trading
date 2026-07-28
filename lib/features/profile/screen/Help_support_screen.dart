import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controller/profile_controller.dart';

class HelpSupportScreen extends GetView<ProfileController> {
  const HelpSupportScreen({super.key});

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
            child: Padding(
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
                        'Help & Support',
                        style: GoogleFonts.poppins(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),

                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          SizedBox(height:130.h),

                          // -------- Illustration --------
                          Image.asset(
                            "asset/image/profile/help.png",
                            fit: BoxFit.contain,
                          ),

                          SizedBox(height: 34.h),

                          Text(
                            'If you face any kind of problem with\nour service feel free to contact us.',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.poppins(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                              height: 1.5,
                            ),
                          ),

                          SizedBox(height: 26.h),

                          // -------- Contact email pill --------
                          GestureDetector(
                            onTap: controller.onContactSupportPressed,
                            child: Container(
                              width: double.infinity,
                              padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
                              decoration: BoxDecoration(
                                color: const Color(0xFF26203A),
                                borderRadius: BorderRadius.circular(30.r),
                                border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    padding: EdgeInsets.all(8.w),
                                    decoration: const BoxDecoration(
                                      color: Color(0xFF8A2BE2),
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(Icons.mail_outline, size: 14.sp, color: Colors.white),
                                  ),
                                  SizedBox(width: 12.w),
                                  Text(
                                    controller.supportEmail,
                                    style: GoogleFonts.poppins(
                                      fontSize: 13.sp,
                                      fontWeight: FontWeight.w500,
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
