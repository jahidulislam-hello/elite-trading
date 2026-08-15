import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../data/model/notification_model.dart';
import '../controller/notification_controller.dart';
// ignore: file_names
import 'notification_detail)dialog.dart';

/// Icon + colors per notification type — shared between the tile and the dialog.
({IconData icon, Color bg, Color fg}) notificationIconStyle(
    NotificationType type) {
  switch (type) {
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
    case NotificationType.general:
      return (
        icon: Icons.notifications_outlined,
        bg: Colors.white.withValues(alpha: 0.08),
        fg: Colors.white54,
      );
  }
}

class NotificationsList extends StatelessWidget {
  final NotificationController controller;
  const NotificationsList({super.key, required this.controller});

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
                  NotificationTile(item: items[index], controller: controller),
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

class NotificationTile extends StatelessWidget {
  final NotificationModel item;
  final NotificationController controller;

  const NotificationTile(
      {super.key, required this.item, required this.controller});

  @override
  Widget build(BuildContext context) {
    final style = notificationIconStyle(item.type);

    return GestureDetector(
      onTap: () {
        // Mark as read when tapped
        controller.markAsRead(item.id);
        Get.dialog(
          NotificationDetailDialog(item: item),
          barrierDismissible: true,
          barrierColor: Colors.black.withValues(alpha: 0.6),
        );
      },
      behavior: HitTestBehavior.opaque,
      child: Row(
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
                  item.message, // ← was item.description
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
      ),
    );
  }
}
