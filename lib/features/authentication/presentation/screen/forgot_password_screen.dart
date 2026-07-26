
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/utils/customeTextField/custom_text_field.dart';
import '../controller/auth_controller.dart';
import '../widget/Elevatedbutton.dart';

class ForgotPasswordScreen extends GetView<AuthController> {
  const ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Stack(
        children: [
          // Base gradient background
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFF0D0B14),
                  Color(0xFF0E0530),
                ],
              ),
            ),
          ),

          // Glow ellipse (smooth radial fade, blends into background)
          // Glow ellipse (wide oval, not perfectly circular)
          Positioned(
            top: -190.h,
            left: 0,
            right: 0,
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
                        const Color(0xFF6E00DD).withValues(alpha:0.22),
                        const Color(0xFF6E00DD).withValues(alpha:0.10),
                        const Color(0xFF6E00DD).withValues(alpha:0.03),
                        const Color(0xFF6E00DD).withValues(alpha:0.0),
                      ],
                      stops: const [0.0, 0.3, 0.55, 0.8, 1.0],
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
                key: controller.formKey,
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
                        'Forgot Password',
                        style: GoogleFonts.poppins(
                          fontSize: 24.sp,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    SizedBox(height: 8.h),

                    // Subtitle
                    Center(
                      child: Text(
                        'Enter email address to reset your\npassword.',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w400,
                          color: Colors.white70,
                        ),
                      ),
                    ),

                    SizedBox(height: 36.h),

                    CustomTextField(
                      labelText: "Email address",
                      levelTextSize: 13,
                      levelTextColor: Colors.white,
                      controller: controller.emailController,
                      hintText: 'you@example.com',
                      isEmail: true,
                      keyboardType: TextInputType.emailAddress,
                      filColor: const Color(0xFF1C1830),
                      hinTextColor: Colors.white54,
                      borderColor: Colors.transparent,
                      borderRadius: 14,
                      contentPaddingVertical: 16,
                      iconColor: Colors.white54,
                      prefixIcon: const Icon(Icons.mail_outline),
                    ),

                    SizedBox(height: 100.h),

                    // Continue button
                    Obx(
                          () => CustomElevatedButton(
                        text: 'Continue',
                        onTap: controller.onContinuePressed,
                        isLoading: controller.isLoading.value,
                      ),
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