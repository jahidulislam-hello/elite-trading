import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controller/profile_controller.dart';

class ProfilePage extends GetView<ProfileController> {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F0B1E),
      body: Stack(
        children: [
          // -------- Top background image (darkened) --------
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: SizedBox(
              width: double.infinity,
              height: 300.h,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.asset(
                    'asset/image/profile/profileBackground.png',
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      color: const Color(0xFF241B3D),
                    ),
                  ),
                  Container(
                    color: const Color(0xFF0F0B1E).withValues(alpha: 0.75),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          const Color(0xFF0F0B1E).withValues(alpha: 0.95),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          SafeArea(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 8.h),

                  // -------- Header --------
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                      Text(
                        'Profile',
                        style: GoogleFonts.poppins(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                      Obx(
                            () => controller.isPremiumMember.value
                            ? Container(
                          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.08),
                            borderRadius: BorderRadius.circular(20.r),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.bolt, size: 12.sp, color: const Color(0xFFE0A11F)),
                              SizedBox(width: 4.w),
                              Text(
                                'PREMIUM MEMBER',
                                style: GoogleFonts.poppins(
                                  fontSize: 9.sp,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ],
                          ),
                        )
                            : const SizedBox.shrink(),
                      ),
                    ],
                  ),

                  SizedBox(height: 20.h),

                  // -------- Avatar --------
                  Center(
                    child: Stack(
                      children: [
                        Container(
                          padding: EdgeInsets.all(3.w),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white.withValues(alpha: 0.2), width: 2),
                          ),
                          child: ClipOval(
                            child: Image.asset(
                              controller.userAvatar,
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
                          bottom: 0,
                          right: 0,
                          child: GestureDetector(
                            onTap: controller.onEditAvatarPressed,
                            child: Container(
                              padding: EdgeInsets.all(6.w),
                              decoration: BoxDecoration(
                                color: const Color(0xFF2ECC71),
                                shape: BoxShape.circle,
                                border: Border.all(color: const Color(0xFF0F0B1E), width: 2),
                              ),
                              child: Icon(Icons.edit, size: 12.sp, color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 14.h),

                  Center(
                    child: Text(
                      controller.userName,
                      style: GoogleFonts.poppins(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Center(
                    child: Text(
                      controller.userEmail,
                      style: GoogleFonts.poppins(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w400,
                        color: Colors.white54,
                      ),
                    ),
                  ),

                  SizedBox(height: 22.h),

                  // -------- Premium plan card --------
                  Container(
                    padding: EdgeInsets.all(16.w),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.4),
                      borderRadius: BorderRadius.circular(18.r),
                      border: Border.all(color: const Color(0xFFE0A11F).withValues(alpha: 0.4)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              controller.planLabel,
                              style: GoogleFonts.poppins(
                                fontSize: 10.sp,
                                fontWeight: FontWeight.w700,
                                color: const Color(0xFFE0A11F),
                                letterSpacing: 1,
                              ),
                            ),
                            SizedBox(height: 6.h),
                            Text(
                              controller.planStatus,
                              style: GoogleFonts.poppins(
                                fontSize: 13.sp,
                                fontWeight: FontWeight.w500,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                        Icon(Icons.military_tech, color: const Color(0xFFE0A11F), size: 28.sp),
                      ],
                    ),
                  ),

                  SizedBox(height: 22.h),

                  // -------- Menu list --------
                  _MenuTile(
                    icon: Icons.person_outline,
                    title: 'Personal Info',
                    subtitle: 'Update your personal info',
                    onTap: controller.onPersonalInfoPressed,
                  ),
                  _MenuTile(
                    icon: Icons.notifications_none,
                    title: 'Notification Settings',
                    subtitle: 'Reminders & alerts',
                    onTap: controller.onNotificationSettingsPressed,
                  ),
                  _MenuTile(
                    icon: Icons.lock_outline,
                    title: 'Change Password',
                    subtitle: 'Update & secure your account password',
                    onTap: controller.onChangePasswordPressed,
                  ),
                  _MenuTile(
                    icon: Icons.help_outline,
                    title: 'Help & Support',
                    subtitle: 'Contact us anytime',
                    onTap: controller.onHelpSupportPressed,
                  ),
                  _MenuTile(
                    icon: Icons.star_border,
                    title: 'Terms & Conditions',
                    subtitle: 'Legal & subscription terms',
                    onTap: controller.onTermsConditionsPressed,
                  ),
                  _MenuTile(
                    icon: Icons.show_chart,
                    title: 'About Elite Trading',
                    subtitle: 'Version 1.0.0',
                    onTap: controller.onAboutPressed,
                  ),

                  SizedBox(height: 24.h),

                  // -------- Sign out --------
                  GestureDetector(
                    onTap: controller.onSignOutPressed,
                    child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(vertical: 16.h),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: const Color(0xFFE0405C).withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(16.r),
                        border: Border.all(color: const Color(0xFFE0405C).withValues(alpha: 0.4)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.logout, size: 16.sp, color: const Color(0xFFE0405C)),
                          SizedBox(width: 8.w),
                          Text(
                            'Sign Out',
                            style: GoogleFonts.poppins(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFFE0405C),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  SizedBox(height: 30.h),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MenuTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _MenuTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: 12.h),
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
        decoration: BoxDecoration(
          color: const Color(0xFF1B1830),
          borderRadius: BorderRadius.circular(14.r),
          border: Border.all(color: Colors.white.withValues(alpha: 0.06)),
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(10.w),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.06),
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Icon(icon, size: 16.sp, color: Colors.white70),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.poppins(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    subtitle,
                    style: GoogleFonts.poppins(
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w400,
                      color: Colors.white38,
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.chevron_right, size: 18.sp, color: Colors.white38),
          ],
        ),
      ),
    );
  }
}