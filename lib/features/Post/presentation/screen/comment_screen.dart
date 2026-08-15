import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../data/model/post_model.dart';
import '../controller/post_controller.dart';

class CommentScreen extends GetView<PostController> {
  const CommentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final post = controller.selectedPost.value;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: const Color(0xFF0F0B1E),
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
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () => Get.back(),
                            child: Container(
                              padding: EdgeInsets.all(8.w),
                              decoration: const BoxDecoration(
                                color: Color(0xFF73737380),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(Icons.arrow_back, color: Colors.white, size: 18.sp),
                            ),
                          ),
                          SizedBox(width: 14.w),
                          Text(
                            'Comments',
                            style: GoogleFonts.poppins(
                              fontSize: 18.sp,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                      Obx(
                            () => Container(
                          width: 30.w,
                          height: 30.w,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: const Color(0xFF7B1FE0),
                            shape: BoxShape.circle,
                          ),
                          child: Text(
                            '${controller.totalComments}',
                            style: GoogleFonts.poppins(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 16.h),

                // -------- Glass post preview (image + detail BELOW image) --------
                if (post != null)
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(18.r),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.06),
                            borderRadius: BorderRadius.circular(18.r),
                            border: Border.all(color: Colors.white.withValues(alpha: 0.14)),
                          ),
                          child: Column(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(12.r),
                                child: post.coverImage != null
                                    ? Image.network(
                                        post.coverImage!,
                                        width: double.infinity,
                                        height: 130.h,
                                        fit: BoxFit.cover,
                                        errorBuilder: (_, __, ___) => Container(
                                          width: double.infinity,
                                          height: 130.h,
                                          color: const Color(0xFF1B1830),
                                        ),
                                      )
                                    : Container(
                                        width: double.infinity,
                                        height: 130.h,
                                        color: const Color(0xFF1B1830),
                                        child: Icon(Icons.image_outlined,
                                            size: 36,
                                            color: Colors.white
                                                .withValues(alpha: 0.15)),
                                      ),
                              ),
                              Padding(
                                padding: EdgeInsets.all(10.w),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [

                                    SizedBox(height: 10.h),
                                    Text(
                                      post.title,
                                      style: GoogleFonts.poppins(
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.white,
                                      ),
                                    ),
                                    SizedBox(height: 4.h),
                                    Obx(
                                          () => Text(
                                        '${post.likes} likes · ${controller.totalComments} comments',
                                        style: GoogleFonts.poppins(
                                          fontSize: 11.sp,
                                          color: Colors.white54,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),

                SizedBox(height: 20.h),

                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'ALL COMMENTS',
                      style: GoogleFonts.poppins(
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.white38,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 14.h),

                Expanded(
                  child: Obx(
                        () => ListView.builder(
                      padding: EdgeInsets.symmetric(horizontal: 20.w),
                      itemCount: controller.comments.length,
                      itemBuilder: (context, index) =>
                          _CommentTile(comment: controller.comments[index]),
                    ),
                  ),
                ),

                // -------- Comment input --------
                Padding(
                  padding: EdgeInsets.fromLTRB(20.w, 10.h, 20.w, 14.h),
                  child: Row(
                    children: [
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
                      SizedBox(width: 10.w),
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 16.w),
                          decoration: BoxDecoration(
                            color: const Color(0xFF1B1830),
                            borderRadius: BorderRadius.circular(24.r),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  controller: controller.commentInputController,
                                  style: GoogleFonts.poppins(
                                    fontSize: 13.sp,
                                    color: Colors.white,
                                  ),
                                  decoration: InputDecoration(
                                    hintText: 'Write a comment...',
                                    hintStyle: GoogleFonts.poppins(
                                      fontSize: 13.sp,
                                      color: Colors.white38,
                                    ),
                                    border: InputBorder.none,
                                    isDense: true,
                                    contentPadding: EdgeInsets.symmetric(vertical: 14.h),
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: controller.onSendComment,
                                child: Icon(
                                  Icons.send,
                                  size: 18.sp,
                                  color: const Color(0xFF7B1FE0),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
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

class _CommentTile extends StatelessWidget {
  final CommentModel comment;
  const _CommentTile({required this.comment});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 18.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 34.w,
            height: 34.w,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: const Color(0xFF3A3160),
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Text(
              comment.authorInitials,
              style: GoogleFonts.poppins(
                fontSize: 11.sp,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      comment.authorName,
                      style: GoogleFonts.poppins(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      comment.timeAgo,
                      style: GoogleFonts.poppins(
                        fontSize: 11.sp,
                        color: Colors.white38,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 6.h),
                Container(
                  padding: EdgeInsets.all(12.w),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1B1830),
                    borderRadius: BorderRadius.circular(14.r),
                  ),
                  child: Text(
                    comment.text,
                    style: GoogleFonts.poppins(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w400,
                      color: Colors.white70,
                      height: 1.4,
                    ),
                  ),
                ),
                SizedBox(height: 6.h),
                Row(
                  children: [
                    Icon(Icons.favorite_border, size: 14.sp, color: Colors.white38),
                    SizedBox(width: 4.w),
                    Text(
                      '${comment.likes}',
                      style: GoogleFonts.poppins(
                        fontSize: 11.sp,
                        color: Colors.white38,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}