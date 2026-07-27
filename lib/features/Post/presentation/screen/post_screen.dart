import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../data/model/post_data.dart';
import '../controller/post_controller.dart';

class PostScreen extends GetView<PostController> {
  const PostScreen({super.key});

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
                  Obx(() {
                    final isEmpty = controller.posts.isEmpty;
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Posts',
                                style: GoogleFonts.poppins(
                                  fontSize: 24.sp,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(height: 4.h),
                              Text(
                                isEmpty
                                    ? 'Market News, Education & Expert Analysis'
                                    : 'Latest Market Insights & Trading Updates',
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
                          child:  Image.network(
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
                    );
                  }),

                  SizedBox(height: 8.h),

                  // -------- Body --------
                  Expanded(
                    child: Obx(() {
                      if (controller.posts.isEmpty) {
                        return const _EmptyPostsState();
                      }
                      return ListView.builder(
                        padding: EdgeInsets.only(top: 16.h, bottom: 90.h),
                        itemCount: controller.posts.length,
                        itemBuilder: (context, index) =>
                            _PostCard(post: controller.posts[index]),
                      );
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

class _PostCard extends StatelessWidget {
  final PostModel post;
  const _PostCard({required this.post});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<PostController>();

    return Padding(
      padding: EdgeInsets.only(bottom: 18.h),
      child: GestureDetector(
        onTap: () => controller.onPostTap(post),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20.r),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.06),
                borderRadius: BorderRadius.circular(20.r),
                border: Border.all(color: Colors.white.withValues(alpha: 0.14)),
              ),
              child: Column(
                children: [
                  Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(14.r),
                        child: Image.asset(
                          post.imageAsset,
                          width: double.infinity,
                          height: 160.h,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Container(
                            width: double.infinity,
                            height: 160.h,
                            color: const Color(0xFF1B1830),
                          ),
                        ),
                      ),
                      Positioned(
                        top: 12.h,
                        right: 12.w,
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.55),
                            borderRadius: BorderRadius.circular(20.r),
                          ),
                          child: Text(
                            post.tag,
                            style: GoogleFonts.poppins(
                              fontSize: 11.sp,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.all(14.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 26.w,
                              height: 26.w,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: const Color(0xFF7B1FE0),
                                borderRadius: BorderRadius.circular(8.r),
                              ),
                              child: Text(
                                'ET',
                                style: GoogleFonts.poppins(
                                  fontSize: 10.sp,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            SizedBox(width: 8.w),
                            Text(
                              post.authorName,
                              style: GoogleFonts.poppins(
                                fontSize: 13.sp,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                            if (post.isVerified) ...[
                              SizedBox(width: 4.w),
                              Icon(Icons.verified, size: 14.sp, color: const Color(0xFF7B1FE0)),
                            ],
                            const Spacer(),
                            Text(
                              post.timeAgo,
                              style: GoogleFonts.poppins(
                                fontSize: 11.sp,
                                color: Colors.white38,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10.h),
                        Text(
                          post.title,
                          style: GoogleFonts.poppins(
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 6.h),
                        Text(
                          post.description,
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.poppins(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w400,
                            color: Colors.white54,
                            height: 1.4,
                          ),
                        ),
                        SizedBox(height: 7.h),
                        Divider(
                          color: Colors.white38,thickness: 0.5,
                        ),
                        SizedBox(height: 12.h),
                        Row(
                          children: [
                            Icon(Icons.favorite_border, size: 16.sp, color: Colors.white54),
                            SizedBox(width: 6.w),
                            Text(
                              '${post.likes}',
                              style: GoogleFonts.poppins(fontSize: 12.sp, color: Colors.white54),
                            ),
                            SizedBox(width: 20.w),
                            Icon(Icons.mode_comment_outlined, size: 16.sp, color: Colors.white54),
                            SizedBox(width: 6.w),
                            Text(
                              '${post.comments}',
                              style: GoogleFonts.poppins(fontSize: 12.sp, color: Colors.white54),
                            ),
                            const Spacer(),
                            Icon(Icons.share_outlined, size: 16.sp, color: Colors.white54),
                            SizedBox(width: 6.w),
                            Text(
                              '${post.shares}',
                              style: GoogleFonts.poppins(fontSize: 12.sp, color: Colors.white54),
                            ),
                          ],
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
    );
  }
}

class _EmptyPostsState extends StatelessWidget {
  const _EmptyPostsState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 200.w,
            height: 200.h,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Positioned(
                  left: 20.w,
                  top: 40.h,
                  child: _bubble(60.w, const Color(0xFF3A3160)),
                ),
                Positioned(
                  right: 20.w,
                  top: 30.h,
                  child: _bubble(70.w, const Color(0xFF433A70)),
                ),
                Positioned(
                  top: 70.h,
                  child: _bubble(90.w, const Color(0xFF5C4E99)),
                ),
                Container(
                  width: 64.w,
                  height: 64.w,
                  alignment: Alignment.center,
                  decoration: const BoxDecoration(
                    color: Color(0xFF7B1FE0),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.search, size: 28.sp, color: Colors.white),
                ),
                Positioned(
                  top: 10.h,
                  left: 40.w,
                  child: _dot(8.w),
                ),
                Positioned(
                  top: 0,
                  right: 30.w,
                  child: _dot(6.w),
                ),
                Positioned(
                  top: 40.h,
                  right: 0,
                  child: _dot(10.w),
                ),
                Positioned(
                  bottom: 10.h,
                  left: 20.w,
                  child: _dot(9.w),
                ),
              ],
            ),
          ),
          SizedBox(height: 24.h),
          Text(
            'There have no post yet',
            style: GoogleFonts.poppins(
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
              color: Colors.white70,
            ),
          ),
        ],
      ),
    );
  }

  Widget _bubble(double size, Color color) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.6),
        shape: BoxShape.circle,
      ),
    );
  }

  Widget _dot(double size) {
    return Container(
      width: size,
      height: size,
      decoration: const BoxDecoration(
        color: Color(0xFF9B5CFF),
        shape: BoxShape.circle,
      ),
    );
  }
}