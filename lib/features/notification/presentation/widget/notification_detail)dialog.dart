import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../data/model/notification_model.dart';
import 'notification_list.dart';


class NotificationDetailDialog extends StatelessWidget {
  final NotificationModel item;
  const NotificationDetailDialog({super.key, required this.item});

  String get _typeLabel {
    switch (item.type) {
      case NotificationType.signal:
        return 'SIGNAL';
      case NotificationType.update:
        return 'UPDATE';
      case NotificationType.alert:
        return 'ALERT';
      case NotificationType.general:
        return 'INFO';
    }
  }

  @override
  Widget build(BuildContext context) {
    final style = notificationIconStyle(item.type);

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.symmetric(horizontal: 24.w),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            padding: EdgeInsets.fromLTRB(24.w, 34.h, 24.w, 22.h),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  const Color(0xFF2A2049),
                  const Color(0xFF15111F),
                ],
              ),
              borderRadius: BorderRadius.circular(26.r),
              border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.45),
                  blurRadius: 32,
                  offset: const Offset(0, 16),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // -------- Centered icon with glow --------
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      width: 84.w,
                      height: 84.w,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(
                          colors: [
                            style.fg.withValues(alpha: 0.25),
                            style.fg.withValues(alpha: 0.0),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(18.w),
                      decoration: BoxDecoration(
                        color: style.bg,
                        shape: BoxShape.circle,
                        border: Border.all(color: style.fg.withValues(alpha: 0.35), width: 1.2),
                      ),
                      child: Icon(style.icon, size: 30.sp, color: style.fg),
                    ),
                  ],
                ),

                SizedBox(height: 18.h),

                // -------- Type pill + time --------
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                      decoration: BoxDecoration(
                        color: style.bg,
                        borderRadius: BorderRadius.circular(20.r),
                      ),
                      child: Text(
                        _typeLabel,
                        style: GoogleFonts.poppins(
                          fontSize: 10.sp,
                          fontWeight: FontWeight.w700,
                          color: style.fg,
                          letterSpacing: 0.6,
                        ),
                      ),
                    ),
                    SizedBox(width: 8.w),
                    Text(
                      item.timeAgo,
                      style: GoogleFonts.poppins(
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w400,
                        color: Colors.white38,
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 14.h),

                // -------- Title --------
                Text(
                  item.title,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    fontSize: 17.sp,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                    height: 1.3,
                  ),
                ),

                SizedBox(height: 14.h),

                // -------- Description --------
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(14.w),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.04),
                    borderRadius: BorderRadius.circular(14.r),
                    border: Border.all(color: Colors.white.withValues(alpha: 0.06)),
                  ),
                  child: Text(
                    item.message,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w400,
                      color: Colors.white70,
                      height: 1.6,
                    ),
                  ),
                ),

                SizedBox(height: 24.h),

                // -------- Got it button --------
                GestureDetector(
                  onTap: () => Get.back(),
                  child: Container(
                    width: double.infinity,
                    height: 50.h,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF9B2BFF), Color(0xFF6A1BFF)],
                      ),
                      borderRadius: BorderRadius.circular(14.r),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF8A2BE2).withValues(alpha: 0.35),
                          blurRadius: 14,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: Text(
                      'Got it',
                      style: GoogleFonts.poppins(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // -------- Small close button, top-right, floating outside the card --------
          Positioned(
            top: -6.h,
            right: -6.w,
            child: GestureDetector(
              onTap: () => Get.back(),
              child: Container(
                width: 28.w,
                height: 28.w,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: const Color(0xFF1B1830),
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white.withValues(alpha: 0.12)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Icon(Icons.close, size: 13.sp, color: Colors.white60),
              ),
            ),
          ),
        ],
      ),
    );
  }
}