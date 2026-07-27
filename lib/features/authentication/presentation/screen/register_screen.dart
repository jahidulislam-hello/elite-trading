import 'package:elite_trading/core/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/utils/customeTextField/custom_text_field.dart';
import '../controller/auth_controller.dart';
import '../widget/Elevatedbutton.dart';

class RegisterScreen extends GetView<AuthController> {
  const RegisterScreen({super.key});

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
          // Content
          SafeArea(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Form(
                key: controller.registerFormKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 16.h),

                    // Back button
                    GestureDetector(
                      onTap: () => Get.back(),
                      child: Icon(
                        Icons.arrow_back,
                        color: Colors.white,
                        size: 22.sp,
                      ),
                    ),

                    SizedBox(height: 28.h),

                    // Heading
                    Text(
                      'Register',
                      style: GoogleFonts.poppins(
                        fontSize: 28.sp,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 10.h),

                    // Subtitle
                    Row(
                      children: [
                        Text(
                          "Already have an account? ",
                          style: GoogleFonts.poppins(
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w400,
                            color: Colors.white54,
                          ),
                        ),
                        GestureDetector(
                          onTap: (){
                            Get.back();
                          },
                          child: Text(
                            'Log In',
                            style: GoogleFonts.poppins(
                              fontSize: 13.sp,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFF7B8CFF),
                            ),
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 32.h),

                    // First Name + Last Name
                    Row(
                      children: [
                        Expanded(
                          child: CustomTextField(
                            labelText: "First Name",
                            levelTextSize: 13,
                            levelTextColor: Colors.white,
                            controller: controller.firstNameController,
                            hintText: 'Lois',
                            filColor: const Color(0xFF26203A),
                            hinTextColor: Colors.white54,
                            borderColor: Colors.transparent,
                            borderRadius: 14,
                            contentPaddingVertical: 16,
                          ),
                        ),
                        SizedBox(width: 12.w),
                        Expanded(
                          child: CustomTextField(
                            labelText: "Last Name",
                            levelTextSize: 13,
                            levelTextColor: Colors.white,
                            controller: controller.lastNameController,
                            hintText: 'Becket',
                            filColor: const Color(0xFF26203A),
                            hinTextColor: Colors.white54,
                            borderColor: Colors.transparent,
                            borderRadius: 14,
                            contentPaddingVertical: 16,
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 6.h),

                    // Email
                    CustomTextField(
                      labelText: "Email address",
                      levelTextSize: 13,
                      levelTextColor: Colors.white,
                      controller: controller.registerEmailController,
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
                      controller: controller.registerPasswordController,
                      hintText: 'Enter your password',
                      isPassword: true,
                      filColor: const Color(0xFF26203A),
                      hinTextColor: Colors.white54,
                      borderColor: Colors.transparent,
                      borderRadius: 14,
                      contentPaddingVertical: 16,
                      iconColor: Colors.white54,
                      prefixIcon: const Icon(Icons.lock_outline),
                    ),

                    SizedBox(height: 6.h),

                    // Confirm Password
                    CustomTextField(
                      labelText: "Confirm Password",
                      levelTextSize: 13,
                      levelTextColor: Colors.white,
                      controller: controller.confirmPasswordController,
                      hintText: 'Enter your password',
                      isPassword: true,
                      filColor: const Color(0xFF26203A),
                      hinTextColor: Colors.white54,
                      borderColor: Colors.transparent,
                      borderRadius: 14,
                      contentPaddingVertical: 16,
                      iconColor: Colors.white54,
                      prefixIcon: const Icon(Icons.lock_outline),
                    ),

                    SizedBox(height: 28.h),

                    // Create Account button
                    Obx(
                          () => CustomElevatedButton(
                        text: 'Create Account',
                        onTap: controller.onRegisterPressed,
                        isLoading: controller.isRegisterLoading.value,
                        backgroundColor: const Color(0xFF7B1FE0),
                        height: 54.h,
                        borderRadius: 13.r,
                      ),
                    ),

                    SizedBox(height: 24.h),
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