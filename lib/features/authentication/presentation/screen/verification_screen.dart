import 'package:elite_trading/features/authentication/presentation/controller/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pinput/pinput.dart';
import '../widget/Elevatedbutton.dart';
import 'package:google_fonts/google_fonts.dart';

class VerificationScreen extends GetView<AuthController> {
  const VerificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final defaultPinTheme = PinTheme(
      width: 38.w,
      height: 48.h,
      textStyle: GoogleFonts.poppins(
        fontSize: 18.sp,
        fontWeight: FontWeight.w600,
        color: Colors.white,
      ),
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: Colors.white38, width: 1.2),
      ),
    );

    final focusedPinTheme = defaultPinTheme.copyDecorationWith(
      border: Border.all(color: const Color(0xFF6E00DD), width: 1.5),
      color: const Color(0xFF6E00DD).withValues(alpha: 0.08),
    );

    final submittedPinTheme = defaultPinTheme.copyDecorationWith(
      border: Border.all(color: const Color(0xFF6E00DD), width: 1.2),
      color: const Color(0xFF1C1830),
    );

    final errorPinTheme = defaultPinTheme.copyDecorationWith(
      border: Border.all(color: Colors.redAccent, width: 1.2),
    );

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

          SafeArea(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Form(
                key: controller.verificationFormKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 60.h),

                    Center(
                      child: Image.asset(
                        'asset/image/onboarding/logo.png',
                        height: 150.h,
                        fit: BoxFit.contain,
                      ),
                    ),

                    SizedBox(height: 20.h),

                    Center(
                      child: Text(
                        'Enter verification code',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                          fontSize: 24.sp,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    SizedBox(height: 8.h),

                    Center(
                      child: Text(
                        "We've sent a verification code to example@gmail.com that will expire in 10 minutes. Please enter to continue",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w400,
                          color: Colors.white70,
                        ),
                      ),
                    ),

                    SizedBox(height: 36.h),

                    Center(
                      child: Pinput(
                        length: 6,
                        controller: controller.otpController,
                        defaultPinTheme: defaultPinTheme,
                        focusedPinTheme: focusedPinTheme,
                        submittedPinTheme: submittedPinTheme,
                        errorPinTheme: errorPinTheme,
                        separatorBuilder: (index) => SizedBox(width: 8.w),
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        onChanged: (value) {
                          if (controller.otpErrorText.value.isNotEmpty) {
                            controller.otpErrorText.value = '';
                          }
                        },
                        onCompleted: (pin) {
                          controller.verificationCode(pin);
                        },
                      ),
                    ),

                    SizedBox(height: 10.h),

                    Obx(
                          () => controller.otpErrorText.value.isEmpty
                          ? const SizedBox.shrink()
                          : Padding(
                        padding: EdgeInsets.only(top: 4.h),
                        child: Text(
                          controller.otpErrorText.value,
                          style: GoogleFonts.poppins(
                            fontSize: 12.sp,
                            color: Colors.redAccent,
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: 20.h),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Didn't receive the code? ",
                          style: GoogleFonts.poppins(
                            fontSize: 13.sp,
                            color: Colors.white54,
                          ),
                        ),
                        GestureDetector(
                          onTap: controller.resendCode,
                          child: Text(
                            'Resend Code',
                            style: GoogleFonts.poppins(
                              fontSize: 13.sp,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFFFF5C5C),
                              decoration: TextDecoration.underline,
                              decorationColor: const Color(0xFFFF5C5C),
                            ),
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 80.h),

                    Obx(
                          () => CustomElevatedButton(
                        text: 'Verify',
                        isLoading: controller.isVerifying.value,
                        onTap: () {
                          controller.verificationCode(controller.otpController.text);
                        },
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