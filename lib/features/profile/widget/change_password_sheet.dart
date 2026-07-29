import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/utils/customeTextField/custom_text_field.dart';
import '../../authentication/presentation/widget/Elevatedbutton.dart';
import '../controller/profile_controller.dart';

class ChangePasswordSheet extends GetView<ProfileController> {
  const ChangePasswordSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: ClipRRect(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28.r)),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
          child: Container(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.85,
            ),
            padding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 24.h),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  const Color(0xFF1E1A32).withValues(alpha: 0.92),
                  const Color(0xFF15111F).withValues(alpha: 0.96),
                ],
              ),
              borderRadius: BorderRadius.vertical(top: Radius.circular(28.r)),
              border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.4),
                  blurRadius: 30,
                  offset: const Offset(0, -8),
                ),
              ],
            ),
            child: SingleChildScrollView(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              child: Form(
                key: controller.formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Drag handle
                    Center(
                      child: Container(
                        width: 40.w,
                        height: 4.h,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.24),
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                      ),
                    ),
                    SizedBox(height: 18.h),
                    Center(
                      child: Text(
                        'Password Change',
                        style: GoogleFonts.poppins(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    SizedBox(height: 22.h),

                    CustomTextField(
                      controller: controller.currentPasswordController,
                      hintText: 'Current password',
                      isPassword: true,
                      filColor: Colors.white.withValues(alpha: 0.06),
                      hinTextColor: Colors.white70,
                      borderColor: Colors.white.withValues(alpha: 0.1),
                      borderRadius: 16,
                      contentPaddingVertical: 16,
                      iconColor: const Color(0xFF8E8A9E),
                      prefixIcon: const Icon(Icons.vpn_key_outlined),
                    ),

                    Align(
                      alignment: Alignment.centerRight,
                      child: GestureDetector(
                        onTap: controller.onForgotPasswordPressed,
                        child: Padding(
                          padding: EdgeInsets.only(bottom: 16.h),
                          child: Text(
                            'Forgot Password?',
                            style: GoogleFonts.poppins(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w500,
                              color: const Color(0xFF9B6BFF),
                            ),
                          ),
                        ),
                      ),
                    ),

                    CustomTextField(
                      controller: controller.newPasswordController,
                      hintText: 'Enter New password',
                      isPassword: true,
                      filColor: Colors.white.withValues(alpha: 0.06),
                      hinTextColor: Colors.white70,
                      borderColor: Colors.white.withValues(alpha: 0.1),
                      borderRadius: 16,
                      contentPaddingVertical: 16,
                      iconColor: const Color(0xFF8E8A9E),
                      prefixIcon: const Icon(Icons.vpn_key_outlined),
                    ),

                    CustomTextField(
                      controller: controller.confirmPasswordController,
                      hintText: 'Confirm New password',
                      isPassword: true,
                      filColor: Colors.white.withValues(alpha: 0.06),
                      hinTextColor: Colors.white70,
                      borderColor: Colors.white.withValues(alpha: 0.1),
                      borderRadius: 16,
                      contentPaddingVertical: 16,
                      iconColor: const Color(0xFF8E8A9E),
                      prefixIcon: const Icon(Icons.vpn_key_outlined),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please enter your confirm password";
                        }

                        if (value != controller.newPasswordController.text) {
                          return "Password and confirm password do not match";
                        }

                        return null;
                      },
                    ),

                    SizedBox(height: 8.h),

                    Obx(
                          () => CustomElevatedButton(
                        text: 'Save Change',
                        onTap: controller.onSaveChangePressed,
                        isLoading: controller.isSavingPassword.value,
                        backgroundColor: const Color(0xFF8A2BE2),
                        height: 54.h,
                        borderRadius: 16.r,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}