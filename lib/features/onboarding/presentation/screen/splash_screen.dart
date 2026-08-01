import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:elite_trading/core/routes/app_routes.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToNext();
  }

  Future<void> _navigateToNext() async {
    await Future.delayed(const Duration(seconds: 2));
    if (mounted) {
      Get.offNamed(AppRoutes.onbordingOne);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            height: double.infinity,
            width: double.infinity,
            child: Image.asset(
              "asset/image/onboarding/splashBack.png",
              fit: BoxFit.cover,
            ),
          ),
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset("asset/image/onboarding/logo.png"),
                SizedBox(height: 16.h),
                Text(
                  "Premium Trading Signals",
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: Color(0xFF8E8A9E),
                    fontWeight: FontWeight.w400,
                  ),
                ),
                SizedBox(height: 8.h),
                Text(
                  "-PRECISION  •  PERFORMANCE  •  PROFIT-",
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: Color(0xFFBFA06D),
                    letterSpacing: 2.w,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 60.h,
            left: 0,
            right: 0,
            child: Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(50.r),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                  child: Container(
                    height: 60.h,
                    width: 60.w,
                    padding: EdgeInsets.all(12.w),
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                    ),
                    child: CircularProgressIndicator(
                      color: Colors.white.withValues(alpha: 0.4),
                      strokeCap: StrokeCap.round,
                      strokeWidth: 6,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}