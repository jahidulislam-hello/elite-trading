import 'package:elite_trading/core/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../data/model/market_hour_model.dart';
import '../controller/signal_controller.dart';
import '../widget/signal_card.dart';

class SignalScreen extends GetView<SignalController> {
  const SignalScreen({super.key});

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
              padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 100.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // -------- Greeting header --------
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Good morning',
                            style: GoogleFonts.poppins(
                              fontSize: 13.sp,
                              color: Colors.white54,
                            ),
                          ),
                          SizedBox(height: 4.h),
                          Text(
                            controller.userName,
                            style: GoogleFonts.poppins(
                              fontSize: 22.sp,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          // Obx(
                          //       () => Stack(
                          //     clipBehavior: Clip.none,
                          //     children: [
                          //       Container(
                          //         padding: EdgeInsets.all(10.w),
                          //         decoration: const BoxDecoration(
                          //           color: Color(0xFF1B1830),
                          //           shape: BoxShape.circle,
                          //         ),
                          //         child: Icon(
                          //           Icons.notifications_outlined,
                          //           size: 18.sp,
                          //           color: Colors.white,
                          //         ),
                          //       ),
                          //       if (controller.hasNotification.value)
                          //         Positioned(
                          //           top: 0.h,
                          //           right: 0.w,
                          //           child: Container(
                          //             width: 9.w,
                          //             height: 9.w,
                          //             decoration: const BoxDecoration(
                          //               color: Colors.redAccent,
                          //               shape: BoxShape.circle,
                          //             ),
                          //           ),
                          //         ),
                          //     ],
                          //   ),
                          // ),
                          SizedBox(width: 12.w),
                          GestureDetector(
                            onTap: (){
                              Get.toNamed(AppRoutes.profilePage);
                            },
                            child: ClipOval(
                              child: Image.network(
                                "https://media.sproutsocial.com/uploads/2022/06/profile-picture.jpeg",
                                width: 38.w,
                                height: 38.w,
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) => Container(
                                  width: 38.w,
                                  height: 38.w,
                                  color: const Color(0xFF7B1FE0),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),

                  SizedBox(height: 26.h),

                  // -------- Global market hours --------
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.public, size: 16.sp, color: Colors.white70),
                          SizedBox(width: 8.w),
                          Text(
                            'Global Market Hours',
                            style: GoogleFonts.poppins(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                      Text(
                        'FOREX · UTC',
                        style: GoogleFonts.poppins(
                          fontSize: 10.sp,
                          fontWeight: FontWeight.w500,
                          color: Colors.white54,
                          letterSpacing: 1,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 12.h),
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: controller.marketHours.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 12.w,
                      mainAxisSpacing: 12.h,
                      childAspectRatio: 1.5,
                    ),
                    itemBuilder: (context, index) =>
                        _MarketHourCard(market: controller.marketHours[index]),
                  ),

                  SizedBox(height: 26.h),

                  // -------- Active signals header --------
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Text(
                            'Active Signals',
                            style: GoogleFonts.poppins(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(width: 8.w),
                          Obx(
                                () => Container(
                              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
                              decoration: BoxDecoration(
                                color: const Color(0xFF8000FF).withValues(alpha: 0.4),
                                borderRadius: BorderRadius.circular(20.r),
                              ),
                              child: Text(
                                '${controller.totalSignals}',
                                style: GoogleFonts.poppins(
                                  fontSize: 11.sp,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      GestureDetector(
                        onTap: controller.onSeeAllSignalsPressed,
                        child: Row(
                          children: [
                            Text(
                              'See All',
                              style: GoogleFonts.poppins(
                                fontSize: 15.sp,
                                fontWeight: FontWeight.w700,
                                color: const Color(0xFF8000FF),
                              ),
                            ),
                            Icon(Icons.chevron_right,
                                size: 19.sp,fontWeight: FontWeight.w700, color: const Color(0xFF7B1FE0)),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 14.h),

                  Obx(
                        () => Column(
                      children: controller.signals
                          .map((signal) => SignalCard(signal: signal))
                          .toList(),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MarketHourCard extends StatelessWidget {
  final MarketHourModel market;
  const _MarketHourCard({required this.market});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: const Color(0xFF1B1830),
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text(market.flag, style: TextStyle(fontSize: 14.sp)),
                  SizedBox(width: 6.w),
                  Text(
                    market.name,
                    style: GoogleFonts.poppins(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Container(
                    width: 6.w,
                    height: 6.w,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: market.isOpen
                          ? const Color(0xFF2ECC71)
                          : Colors.white38,
                    ),
                  ),
                  SizedBox(width: 4.w),
                  Text(
                    market.isOpen ? 'OPEN' : 'CLOSED',
                    style: GoogleFonts.poppins(
                      fontSize: 8.sp,
                      fontWeight: FontWeight.w600,
                      color: market.isOpen
                          ? const Color(0xFF2ECC71)
                          : Colors.white38,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 10.h),
          Text(
            market.time,
            style: GoogleFonts.poppins(
              fontSize: 17.sp,
              fontWeight: FontWeight.w700,
              color: market.isOpen ? Colors.white : Colors.white38,
            ),
          ),
          SizedBox(height: 2.h),
          Text(
            market.utcRange,
            style: GoogleFonts.poppins(
              fontSize: 9.sp,
              color: Colors.white38,
            ),
          ),
        ],
      ),
    );
  }
}
