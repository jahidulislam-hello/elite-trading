import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/utils/customeTextField/custom_text_field.dart';
import '../controller/profile_controller.dart';

class PersonalInfo extends GetView<ProfileController> {
  const PersonalInfo({super.key});

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
              child: Form(
                key: controller.personalInfoFormKey,
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
                          'Personal Info',
                          style: GoogleFonts.poppins(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 36.h),

                    // -------- Avatar with camera + add badge --------
                    Center(
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Container(
                            width: 84.w,
                            height: 84.w,
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [Color(0xFF3A2E63), Color(0xFF241B3D)],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white.withValues(alpha: 0.12)),
                            ),
                            child: ClipOval(
                              child: Image.network(
                                "https://media.sproutsocial.com/uploads/2022/06/profile-picture.jpeg",
                                width: 90.w,
                                height: 90.w,
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) => Container(
                                  width: 90.w,
                                  height: 90.w,
                                  color: const Color(0xFF7B1FE0),
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: -2.h,
                            right: -2.w,
                            child: GestureDetector(
                              onTap: controller.onEditAvatarPressed,
                              child: Container(
                                padding: EdgeInsets.all(6.w),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF2F6BFF),
                                  shape: BoxShape.circle,
                                  border: Border.all(color: const Color(0xFF0F0B1E), width: 2),
                                ),
                                child: Icon(Icons.add, size: 14.sp, color: Colors.black,fontWeight: FontWeight.bold,),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 32.h),

                    // -------- First / Last name --------
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: CustomTextField(
                            controller: controller.firstNameController,
                            labelText: 'First Name',
                            hintText: 'First Name',
                            filColor: const Color(0xFF26203A),
                            hinTextColor: Colors.white,
                            levelTextColor: Colors.white70,
                            levelTextSize: 12.sp,
                            hinTextSize: 13.sp,
                            borderColor: Colors.transparent,
                            borderRadius: 14,
                            contentPaddingVertical: 16,
                            contentPaddingHorizontal: 16,
                          ),
                        ),
                        SizedBox(width: 12.w),
                        Expanded(
                          child: CustomTextField(
                            controller: controller.lastNameController,
                            labelText: 'Last Name',
                            hintText: 'Last Name',
                            filColor: const Color(0xFF26203A),
                            hinTextColor: Colors.white,
                            levelTextColor: Colors.white70,
                            levelTextSize: 12.sp,
                            hinTextSize: 13.sp,
                            borderColor: Colors.transparent,
                            borderRadius: 14,
                            contentPaddingVertical: 16,
                            contentPaddingHorizontal: 16,
                          ),
                        ),
                      ],
                    ),

                    // -------- Email --------
                    CustomTextField(
                      controller: controller.emailAddressController,
                      labelText: 'Email address',
                      hintText: 'you@example.com',
                      isEmail: true,
                      filColor: const Color(0xFF6D687B),
                      readOnly: true,
                      hinTextColor: Colors.white54,
                      levelTextColor: Colors.white70,
                      levelTextSize: 12.sp,
                      hinTextSize: 13.sp,
                      borderColor: Colors.transparent,
                      borderRadius: 14,
                      contentPaddingVertical: 16,
                      contentPaddingHorizontal: 16,
                      iconColor: Colors.white38,
                      prefixIcon: const Icon(Icons.mail_outline),
                    ),

                    SizedBox(height: 260.h),

                    // -------- Save Changes --------
                    Obx(
                          () => GestureDetector(
                        onTap: controller.isSavingPersonalInfo.value
                            ? null
                            : controller.onSavePersonalInfoPressed,
                        child: Container(
                          width: double.infinity,
                          height: 54.h,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFF9B2BFF), Color(0xFF6A1BFF)],
                            ),
                            borderRadius: BorderRadius.circular(16.r),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFF8A2BE2).withValues(alpha: 0.35),
                                blurRadius: 16,
                                offset: const Offset(0, 8),
                              ),
                            ],
                          ),
                          child: controller.isSavingPersonalInfo.value
                              ? SizedBox(
                            width: 20.w,
                            height: 20.w,
                            child: const CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2.4,
                            ),
                          )
                              : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Save Changes',
                                style: GoogleFonts.poppins(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(width: 8.w),
                              Icon(Icons.arrow_forward, size: 16.sp, color: Colors.white),
                            ],
                          ),
                        ),
                      ),
                    ),
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