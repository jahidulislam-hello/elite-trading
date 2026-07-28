import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/routes/app_routes.dart';
import '../controller/notification_controller.dart';
import '../widget/notification_list.dart';

class NotificationScreen extends GetView<NotificationController> {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Image.asset(
              "asset/image/onboarding/background.png",
              fit: BoxFit.cover,
            ),
          ),
          SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 16.h),

                  // -------- Header --------
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Notifications',
                              style: GoogleFonts.poppins(
                                fontSize: 24.sp,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(height: 4.h),
                            Text(
                              'Stay informed with every important update.',
                              style: GoogleFonts.poppins(
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w400,
                                color: Colors.white54,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 12.w),
                      GestureDetector(
                        onTap: () {
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

                  SizedBox(height: 8.h),

                  // -------- Body (list or empty state) --------
                  Expanded(
                    child: Obx(() {
                      if (controller.notifications.isEmpty) {
                        return const _EmptyNotificationsState();
                      }
                      return NotificationsList(controller: controller);
                    }),
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

class _EmptyNotificationsState extends StatelessWidget {
  const _EmptyNotificationsState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: 220.w,
                height: 180.h,
                decoration: BoxDecoration(
                  color: const Color(0xFF241B3D),
                  borderRadius: BorderRadius.circular(100.r),
                ),
              ),
              Image.asset(
                'asset/image/subcription/notification.png',
                width: 140.w,
                fit: BoxFit.contain,
                errorBuilder: (_, __, ___) => Icon(
                  Icons.notifications,
                  size: 90.sp,
                  color: const Color(0xFFE0C020),
                ),
              ),
              Positioned(
                top: 18.h,
                right: 70.w,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
                  decoration: BoxDecoration(
                    color: Colors.white70,
                    borderRadius: BorderRadius.circular(6.r),
                  ),
                  child: Text(
                    '0',
                    style: GoogleFonts.poppins(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w700,
                      color: Colors.black87,
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 36.h),
          Text(
            'There are no available\nnotifications',
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              fontSize: 18.sp,
              fontWeight: FontWeight.w700,
              color: Colors.white,
              height: 1.3,
            ),
          ),
          SizedBox(height: 12.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: Text(
              'No notifications available at the moment; when they become available, they will be displayed here.',
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: 12.sp,
                fontWeight: FontWeight.w400,
                color: Colors.white54,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}