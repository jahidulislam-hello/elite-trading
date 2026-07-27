import 'package:elite_trading/core/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/utils/customeTextField/custom_text_field.dart';
import '../controller/auth_controller.dart';
import '../widget/Elevatedbutton.dart';

class SignInScreen extends GetView<AuthController> {
  const SignInScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Stack(
        children: [
          Container(
            height: MediaQuery.of(context).size.height,
            width:  MediaQuery.of(context).size.width,
            child:Image.asset(
      "asset/image/onboarding/background.png",
      fit: BoxFit.cover,
    ),
          ),

          SafeArea(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Form(
                key: controller.signInFormKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 24.h),

                    // Logo + brand name
                    Row(
                      children: [
                        Image.asset(
                          'asset/image/onboarding/logo.png',
                          height: 28.h,
                          fit: BoxFit.contain,
                        ),
                        SizedBox(width: 8.w),
                        Text(
                          'Elite Trading',
                          style: GoogleFonts.poppins(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 32.h),

                    // Heading
                    Text(
                      'Sign in to your\nAccount',
                      style: GoogleFonts.poppins(
                        fontSize: 28.sp,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                        height: 1.2,
                      ),
                    ),
                    SizedBox(height: 10.h),

                    // Subtitle
                    Row(
                      children: [
                        Text(
                          "Don't have an account? ",
                          style: GoogleFonts.poppins(
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w400,
                            color: Colors.white54,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                           Get.toNamed(AppRoutes.registerScreen);
                          },
                          child: Text(
                            'Sign Up',
                            style: GoogleFonts.poppins(
                              fontSize: 13.sp,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFF7B8CFF),
                            ),
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 36.h),

                    // Email
                    CustomTextField(
                      labelText: "Email address",
                      levelTextSize: 13,
                      levelTextColor: Colors.white,
                      controller: controller.signInEmailController,
                      hintText: 'you@example.com',
                      isEmail: true,
                      keyboardType: TextInputType.emailAddress,
                      filColor: const Color(0xFF26203A),
                      hinTextColor: Colors.white54,
                      borderColor: Colors.transparent,
                      borderRadius: 14,
                      contentPaddingVertical: 16,
                      iconColor: Colors.white54,
                      prefixIcon: const Icon(Icons.mail_outline),
                    ),

                    SizedBox(height: 6.h),

                    // Password
                    CustomTextField(
                      labelText: "Password",
                      levelTextSize: 13,
                      levelTextColor: Colors.white,
                      controller: controller.signInPasswordController,
                      hintText: 'Enter your password',
                      isPassword: true,
                      filColor:const Color(0xFF26203A),
                      hinTextColor: Colors.white54,
                      borderColor: Colors.transparent,
                      borderRadius: 14,
                      contentPaddingVertical: 16,
                      iconColor: Colors.white54,
                      prefixIcon: const Icon(Icons.lock_outline),
                    ),

                    SizedBox(height: 4.h),

                    // Remember me + Forgot password
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Obx(
                              () => Row(
                            children: [
                              SizedBox(
                                height: 20.h,
                                width: 20.h,
                                child: Checkbox(
                                  value: controller.rememberMe.value,
                                  onChanged: controller.toggleRememberMe,
                                  activeColor: const Color(0xFF6E00DD),
                                  checkColor: Colors.white,
                                  side: const BorderSide(color: Colors.white38),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(4.r),
                                  ),
                                ),
                              ),
                              SizedBox(width: 8.w),
                              Text(
                                'Remember me',
                                style: GoogleFonts.poppins(
                                  fontSize: 13.sp,
                                  color: Colors.white70,
                                ),
                              ),
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                           Get.toNamed(AppRoutes.forgotPasswordScreen);
                          },
                          child: Text(
                            'Forgot Password ?',
                            style: GoogleFonts.poppins(
                              fontSize: 13.sp,
                              fontWeight: FontWeight.w500,
                              color: const Color(0xFF7B8CFF),
                            ),
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 24.h),

                    // Log In button
                    Obx(
                          () => CustomElevatedButton(
                        text: 'Log In',
                        onTap: controller.onSignInPressed,
                        isLoading: controller.isSignInLoading.value,
                        backgroundColor: const Color(0xFF7B1FE0),
                        height: 54.h,
                        borderRadius: 13.r,
                      ),
                    ),

                    SizedBox(height: 24.h),

                    // Divider "Or login with"
                    Row(
                      children: [
                        const Expanded(
                          child: Divider(color: Colors.white24, thickness: 1),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 12.w),
                          child: Text(
                            'Or login with',
                            style: GoogleFonts.poppins(
                              fontSize: 12.sp,
                              color: Colors.white54,
                            ),
                          ),
                        ),
                        const Expanded(
                          child: Divider(color: Colors.white24, thickness: 1),
                        ),
                      ],
                    ),

                    SizedBox(height: 24.h),

                    // Google / Apple buttons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: (){},
                          child: Container(
                            width: MediaQuery.of(context).size.width*0.4,
                            padding: EdgeInsets.symmetric(horizontal: 25.w,vertical: 15.h),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                                color: Color(0xFF242628)

                            ),
                            child: Row(
                              children: [
                                Image.asset("asset/image/onboarding/google.png"),
                                SizedBox(width: 10.w,),
                                Text("Google",
                                  style: GoogleFonts.poppins(
                                    fontSize: 13.sp,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white,
                                  ),
                                )
                              ],
                            ),

                          ),
                        ),
                        GestureDetector(
                          onTap: (){},
                          child: Container(
                            width: MediaQuery.of(context).size.width*0.4,
                            padding: EdgeInsets.symmetric(horizontal: 25.w,vertical: 15.h),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                                color: Color(0xFF242628)

                            ),
                            child: Row(
                              children: [
                                Image.asset("asset/image/onboarding/apple.png"),
                                SizedBox(width: 10.w,),
                                Text("Apple",
                                  style: GoogleFonts.poppins(
                                    fontSize: 13.sp,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white,
                                  ),
                                )
                              ],
                            ),

                          ),
                        ),

                      ],
                    ),

                    SizedBox(height: 52.h),

                    // Terms text
                    Center(
                      child: RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          style: GoogleFonts.poppins(
                            fontSize: 11.sp,
                            fontWeight: FontWeight.w400,
                            color: Colors.white38,
                          ),
                          children: [
                            const TextSpan(
                              text: 'By signing up, you agree to the ',
                            ),
                            TextSpan(
                              text: 'Terms of Service',
                              style: GoogleFonts.poppins(
                                fontSize: 11.sp,
                                fontWeight: FontWeight.w700,
                                color: Colors.white70,
                              ),
                            ),
                            const TextSpan(text: ' and\n'),
                            TextSpan(
                              text: 'Data Processing Agreement',
                              style: GoogleFonts.poppins(
                                fontSize: 11.sp,
                                fontWeight: FontWeight.w700,
                                color: Colors.white70,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                   // SizedBox(height: 24.h),
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