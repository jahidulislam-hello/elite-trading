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
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        padding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 24.h),
        decoration: BoxDecoration(
          color: const Color(0xFF12101E),
          borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
        ),
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
                    color: Colors.white24,
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
                filColor: const Color(0xFF1E1B30),
                hinTextColor: Colors.white54,
                borderColor: Colors.transparent,
                borderRadius: 14,
                contentPaddingVertical: 16,
                iconColor: Colors.white38,
                prefixIcon: const Icon(Icons.vpn_key_outlined),
              ),

              Align(
                alignment: Alignment.centerRight,
                child: GestureDetector(
                  onTap: controller.onForgotPasswordPressed,
                  child: Padding(
                    padding: EdgeInsets.only(bottom: 6.h),
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

              SizedBox(height: 6.h),

              CustomTextField(
                controller: controller.newPasswordController,
                hintText: 'Enter New password',
                isPassword: true,
                filColor: const Color(0xFF1E1B30),
                hinTextColor: Colors.white54,
                borderColor: Colors.transparent,
                borderRadius: 14,
                contentPaddingVertical: 16,
                iconColor: Colors.white38,
                prefixIcon: const Icon(Icons.vpn_key_outlined),
              ),

              SizedBox(height: 6.h),

              CustomTextField(
                controller: controller.confirmPasswordController,
                hintText: 'Confirm New password',
                isPassword: true,
                filColor: const Color(0xFF1E1B30),
                hinTextColor: Colors.white54,
                borderColor: Colors.transparent,
                borderRadius: 14,
                contentPaddingVertical: 16,
                iconColor: Colors.white38,
                prefixIcon: const Icon(Icons.vpn_key_outlined),
              ),

              SizedBox(height: 18.h),

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
    );
  }
}