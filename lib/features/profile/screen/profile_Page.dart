import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controller/profile_controller.dart';

class ProfilePage extends GetView<ProfileController> {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    // Refresh profile whenever this screen is opened
    Future.microtask(() => controller.loadProfile(silent: true));

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
                    color: const Color(0xFF0F0B1E).withValues(alpha: 0.6),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          const Color(0xFF0F0B1E).withValues(alpha: 0.75),
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
                      SizedBox(width: 10.w,),
                      Text(
                        'Profile',
                        style: GoogleFonts.poppins(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                      Spacer(),
                      Obx(
                        () => controller.isPremiumMember.value
                            ? Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 12.w, vertical: 8.h),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFBFA06D)
                                      .withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(20.r),
                                  border: Border.all(
                                    width: 0.5,
                                    color: const Color(0xFFBFA06D)
                                        .withValues(alpha: 0.3),
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Icon(Icons.auto_awesome,
                                        size: 12.sp,
                                        color: const Color(0xFFE0A11F)),
                                    SizedBox(width: 4.w),
                                    Text(
                                      controller.memberBadgeLabel.value,
                                      style: GoogleFonts.poppins(
                                        fontSize: 9.sp,
                                        fontWeight: FontWeight.w700,
                                        color: const Color(0xFFE0A11F),
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
                            border: Border.all(
                                color: Colors.white.withValues(alpha: 0.2),
                                width: 2),
                          ),
                          child: Obx(() {
                            final url = controller.networkAvatarUrl.value;
                            return ClipOval(
                              child: url.isNotEmpty
                                  ? Image.network(
                                      url,
                                      width: 90.w,
                                      height: 90.w,
                                      fit: BoxFit.cover,
                                      errorBuilder: (_, __, ___) =>
                                          _AvatarFallback(size: 90.w),
                                    )
                                  : _AvatarFallback(size: 90.w),
                            );
                          }),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 14.h),

                  Obx(() => Center(
                        child: Text(
                          controller.userName.value,
                          style: GoogleFonts.poppins(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      )),
                  SizedBox(height: 4.h),
                  Obx(() => Center(
                        child: Text(
                          controller.userEmail.value,
                          style: GoogleFonts.poppins(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w400,
                            color: Colors.white54,
                          ),
                        ),
                      )),

                  SizedBox(height: 22.h),

                  // -------- Premium plan card --------
                  Obx(() => GestureDetector(
                        onTap: controller.onPlanCardPressed,
                        behavior: HitTestBehavior.opaque,
                        child: Container(
                          padding: EdgeInsets.all(16.w),
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.4),
                            borderRadius: BorderRadius.circular(18.r),
                            border: Border.all(
                              color: controller.isPremiumMember.value
                                  ? const Color(0xFF64D77A)
                                      .withValues(alpha: 0.4)
                                  : Colors.white.withValues(alpha: 0.12),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    controller.planLabel.value,
                                    style: GoogleFonts.poppins(
                                      fontSize: 10.sp,
                                      fontWeight: FontWeight.w700,
                                      color: const Color(0xFFE0A11F),
                                      letterSpacing: 1,
                                    ),
                                  ),
                                  SizedBox(height: 6.h),
                                  Text(
                                    controller.planStatus.value,
                                    style: GoogleFonts.poppins(
                                      fontSize: 13.sp,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Icon(
                                    controller.isPremiumMember.value
                                        ? Icons.military_tech
                                        : Icons.lock_outline,
                                    color: const Color(0xFFE0A11F),
                                    size: 28.sp,
                                  ),
                                  SizedBox(width: 4.w),
                                  Icon(
                                    Icons.chevron_right,
                                    color: Colors.white38,
                                    size: 20.sp,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      )),

                  SizedBox(height: 22.h),

                  // -------- Menu list --------
                  Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFF1B1830),
                      borderRadius: BorderRadius.circular(14.r),
                      border: Border.all(color: Colors.white.withValues(alpha: 0.06)),
                    ),
                    child: Column(
                      children: [
                        _MenuTile(
                          icon: Icons.person_outline,
                          title: 'Personal Info',
                          subtitle: 'Update your personal info',
                          onTap: controller.onPersonalInfoPressed,
                        ),
                        Divider(color: Colors.white24, height: 0.5, thickness: 0.5),
                        _MenuTile(
                          icon: Icons.notifications_none,
                          title: 'Notification Settings',
                          subtitle: 'Reminders & alerts',
                          onTap: controller.onNotificationSettingsPressed,
                        ),
                        Divider(color: Colors.white24, height: 0.5, thickness: 0.5),
                        _MenuTile(
                          icon: Icons.lock_outline,
                          title: 'Change Password',
                          subtitle: 'Update & secure your account password',
                          onTap: controller.onChangePasswordPressed,
                        ),
                        Divider(color: Colors.white24, height: 0.5, thickness: 0.5),
                        _MenuTile(
                          icon: Icons.help_outline,
                          title: 'Help & Support',
                          subtitle: 'Contact us anytime',
                          onTap: controller.onHelpSupportPressed,
                        ),
                        Divider(color: Colors.white24, height: 0.5, thickness: 0.5),
                        _MenuTile(
                          icon: Icons.star_border,
                          title: 'Terms & Conditions',
                          subtitle: 'Legal & subscription terms',
                          onTap: controller.onTermsConditionsPressed,
                        ),
                        Divider(color: Colors.white24, height: 0.5, thickness: 0.5),
                        _MenuTile(
                          icon: Icons.star_border,
                          title: 'Privacy & Policy',
                          subtitle: 'Privacy policy ',
                          onTap: controller.onPrivacyPolicyPressed,
                        ),

                        Divider(color: Colors.white24, height: 0.5, thickness: 0.5),
                        _MenuTile(
                          icon: Icons.show_chart,
                          title: 'About Elite Trading',
                          subtitle: 'Version 1.0.0',
                          onTap: controller.onAboutPressed,
                        ),
                      ],
                    ),
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
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
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

class _AvatarFallback extends StatelessWidget {
  final double size;
  const _AvatarFallback({required this.size});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      color: const Color(0xFF7B1FE0),
      alignment: Alignment.center,
      child: Icon(Icons.person, color: Colors.white70, size: size * 0.45),
    );
  }
}