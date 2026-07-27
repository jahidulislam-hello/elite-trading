import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../data/model/notification_item_model.dart';
import '../controller/notification_controller.dart';

class NotificationScreen extends GetView<NotificationController> {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            height: MediaQuery.of(context).size.height,
            width:  MediaQuery.of(context).size.width,
            child:Image.asset(
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
                      ClipOval(
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
                    ],
                  ),

                  SizedBox(height: 8.h),

                  // -------- Body (list or empty state) --------
                  Expanded(
                    child: Obx(() {
                      if (controller.notifications.isEmpty) {
                        return const _EmptyNotificationsState();
                      }
                      return _NotificationsList(controller: controller);
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

class _NotificationsList extends StatelessWidget {
  final NotificationController controller;
  const _NotificationsList({required this.controller});

  @override
  Widget build(BuildContext context) {
    final grouped = controller.groupedNotifications;
    final groupEntries = grouped.entries.toList();

    return ListView.builder(
      padding: EdgeInsets.only(top: 8.h, bottom: 20.h),
      itemCount: groupEntries.length,
      itemBuilder: (context, groupIndex) {
        final entry = groupEntries[groupIndex];
        final items = entry.value;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(bottom: 10.h, top: 6.h),
              child: Text(
                entry.key,
                style: GoogleFonts.poppins(
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.white38,
                  letterSpacing: 1.2,
                ),
              ),
            ),
            ...List.generate(items.length, (index) {
              return Column(
                children: [
                  _NotificationTile(item: items[index]),
                  if (index != items.length - 1)
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 12.h),
                      child: Divider(
                        color: Colors.white.withValues(alpha: 0.2),
                        thickness: 1,
                        height: 0,
                      ),
                    ),
                ],
              );
            }),
            SizedBox(height: 18.h),
          ],
        );
      },
    );
  }
}

class _NotificationTile extends StatelessWidget {
  final NotificationItemModel item;
  const _NotificationTile({required this.item});

  ({IconData icon, Color bg, Color fg}) get _iconStyle {
    switch (item.type) {
      case NotificationType.signal:
        return (
        icon: Icons.bolt,
        bg: const Color(0xFF2ECC71).withValues(alpha: 0.15),
        fg: const Color(0xFF2ECC71),
        );
      case NotificationType.update:
        return (
        icon: Icons.show_chart,
        bg: const Color(0xFF7B1FE0).withValues(alpha: 0.15),
        fg: const Color(0xFF9B6BFF),
        );
      case NotificationType.alert:
        return (
        icon: Icons.error_outline,
        bg: const Color(0xFFE0A11F).withValues(alpha: 0.15),
        fg: const Color(0xFFE0A11F),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final style = _iconStyle;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.all(10.w),
          decoration: BoxDecoration(
            color: style.bg,
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Icon(style.icon, size: 18.sp, color: style.fg),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  if (item.isUnread) ...[
                    Container(
                      width: 6.w,
                      height: 6.w,
                      margin: EdgeInsets.only(right: 6.w),
                      decoration: const BoxDecoration(
                        color: Colors.redAccent,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ],
                  Expanded(
                    child: Text(
                      item.title,
                      style: GoogleFonts.poppins(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  SizedBox(width: 8.w),
                  Text(
                    item.timeAgo,
                    style: GoogleFonts.poppins(
                      fontSize: 11.sp,
                      color: Colors.white38,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 6.h),
              Text(
                item.description,
                style: GoogleFonts.poppins(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w400,
                  color: Colors.white54,
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
      ],
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