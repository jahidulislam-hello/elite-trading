import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class ProgressStepHeader extends StatelessWidget {
  final int currentStep;
  final int totalSteps;
  final VoidCallback? onBackTap;
  final Color activeColor;
  final Color inactiveColor;
  final Color textColor;

  const ProgressStepHeader({
    super.key,
    required this.currentStep,
    required this.totalSteps,
    this.onBackTap,
    this.activeColor = const Color(0xFF7B1FE0),
    this.inactiveColor = const Color(0xFFFFFFFF),
    this.textColor = Colors.white70,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        GestureDetector(
          onTap: onBackTap ?? () => Get.back(),
          child: Container(
            padding: EdgeInsets.all(8.w),
            decoration: const BoxDecoration(
              color: Color(0xFF73737380),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.chevron_left, color: Colors.white, size: 20.sp),
          ),
        ),
        SizedBox(width: 14.w),
        Expanded(
          child: Row(
            children: List.generate(
              totalSteps,
                  (index) => Expanded(
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 3.w),
                  height: 5.h,
                  decoration: BoxDecoration(
                    color: index < currentStep ? activeColor : inactiveColor,
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                ),
              ),
            ),
          ),
        ),
        SizedBox(width: 14.w),
        Text(
          '$currentStep/$totalSteps',
          style: GoogleFonts.poppins(
            fontSize: 13.sp,
            fontWeight: FontWeight.w600,
            color: textColor,
          ),
        ),
      ],
    );
  }
}