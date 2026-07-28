import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controller/bottom_nav_controller.dart';

class BottomNavScreen extends GetView<BottomNavController> {
  const BottomNavScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F0B1E),
      extendBody: true,
      body: Obx(
            () => IndexedStack(
          index: controller.selectedIndex.value,
          children: controller.screens,
        ),
      ),
      bottomNavigationBar: const _CustomBottomNavBar(),
    );
  }
}

class _CustomBottomNavBar extends GetView<BottomNavController> {
  const _CustomBottomNavBar();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 20.h),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(30.r),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
          child: Container(
            height: 72.h,
            padding: EdgeInsets.symmetric(horizontal: 10.w),
            decoration: BoxDecoration(
              color: const Color(0xFF1B1830).withValues(alpha: 0.75),
              borderRadius: BorderRadius.circular(30.r),
              border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.3),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Obx(
                  () => Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(
                  controller.navItems.length,
                      (index) => _NavItem(
                    data: controller.navItems[index],
                    isSelected: controller.selectedIndex.value == index,
                    onTap: () => controller.changeTab(index),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final NavItemData data;
  final bool isSelected;
  final VoidCallback onTap;

  const _NavItem({
    required this.data,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
        padding: EdgeInsets.symmetric(
          horizontal: isSelected ? 14.w : 12.w,
          vertical: 8.h,
        ),
        decoration: BoxDecoration(
          gradient: isSelected
              ?  LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [
              Color(0xFF9E86FF).withValues(alpha: 0.4),
              Color(0x009E86FF).withValues(alpha: 0.1),
            ],
          )
              : null,
          color: isSelected ? null : Colors.transparent,
          borderRadius: BorderRadius.circular(100.r),
          border: isSelected
              ? Border.all(color: const Color(0xFF9E86FF).withValues(alpha: 0.5))
              : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              data.icon,
              size: 24.sp,
              color: isSelected ? Color(0xFFCEA2FF) : Colors.white38,
            ),
            AnimatedSize(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeOut,
              child: isSelected
                  ? Padding(
                padding: EdgeInsets.only(left: 6.w),
                child: Text(
                  data.label,
                  style: GoogleFonts.poppins(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w600,
                    color:Color(0xFFCEA2FF),
                  ),
                ),
              )
                  : const SizedBox.shrink(),
            ),
          ],
        ),
      ),
    );
  }
}