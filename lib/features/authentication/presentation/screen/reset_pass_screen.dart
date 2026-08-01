import 'package:elite_trading/features/authentication/presentation/controller/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../core/utils/customeTextField/custom_text_field.dart';
import '../widget/Elevatedbutton.dart';
import 'package:google_fonts/google_fonts.dart';

class ResetPassScreen extends GetView<AuthController> {
  const ResetPassScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final resetPassFormKey = GlobalKey<FormState>();
    return Scaffold(
      backgroundColor: const Color(0xFF0F0B1E),
      resizeToAvoidBottomInset: true,
      body: Stack(
        children: [
          const Positioned.fill(
            child: RepaintBoundary(
              child: Image(
                image: AssetImage("asset/image/onboarding/background.png"),
                fit: BoxFit.cover,
              ),
            ),
          ),

          Positioned(
            top: -190.h,
            left: 0,
            right: 0,
            child: RepaintBoundary(
              child: Center(
                child: Transform.scale(
                  scaleX: 1.7,
                  scaleY: 1.0,
                  child: Container(
                    width: 300.w,
                    height: 350.h,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          const Color(0xFF6E00DD).withValues(alpha: 0.55),
                          const Color(0xFF6E00DD).withValues(alpha: 0.22),
                          const Color(0xFF6E00DD).withValues(alpha: 0.10),
                          const Color(0xFF6E00DD).withValues(alpha: 0.03),
                          const Color(0xFF6E00DD).withValues(alpha: 0.0),
                        ],
                        stops: const [0.0, 0.3, 0.55, 0.8, 1.0],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),

          // Content
          SafeArea(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Form(
                key: resetPassFormKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 60.h),

                    // Logo
                    Center(
                      child: Image.asset(
                        'asset/image/onboarding/logo.png',
                        height: 150.h,
                        fit: BoxFit.contain,
                      ),
                    ),

                    SizedBox(height: 20.h),

                    // Title
                    Center(
                      child: Text(
                        'Reset Password',
                        style: GoogleFonts.poppins(
                          fontSize: 24.sp,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    SizedBox(height: 36.h),
                    CustomTextField(
                      labelText: "New Password *",
                      levelTextSize: 13,
                      levelTextColor: Colors.white,
                      controller: controller.resetPass,
                      hintText: 'Enter your password',
                      isPassword: true,
                      filColor: const Color(0xFF1C1830),
                      hinTextColor: Colors.white,
                      borderColor: Colors.transparent,
                      borderRadius: 14,
                      contentPaddingVertical: 16,
                      iconColor: Colors.white54,
                      prefixIcon: const Icon(Icons.lock_outline),
                    ),
                    SizedBox(height: 10.h),
                    CustomTextField(
                      labelText: "Confirm Password *",
                      levelTextSize: 13,
                      levelTextColor: Colors.white,
                      controller: controller.resetConformPass,
                      hintText: 'Enter your password again',
                      isPassword: true,
                      filColor: const Color(0xFF1C1830),
                      hinTextColor: Colors.white,
                      borderColor: Colors.transparent,
                      borderRadius: 14,
                      contentPaddingVertical: 16,
                      iconColor: Colors.white54,
                      prefixIcon: const Icon(Icons.lock_outline),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please enter your confirm password";
                        }

                        if (value != controller.resetPass.text) {
                          return "Password and confirm password do not match";
                        }

                        return null;
                      },
                    ),

                    SizedBox(height: 100.h),

                    CustomElevatedButton(
                      text: 'Reset Password',
                      onTap: () {
                        controller.resetPassword(resetPassFormKey);
                      },
                    ),

                    SizedBox(height: 40.h),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}