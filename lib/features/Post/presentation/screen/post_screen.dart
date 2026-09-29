import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../profile/widget/app_profile_avatar.dart';
import '../../data/model/post_model.dart';
import '../controller/post_controller.dart';

class PostScreen extends GetView<PostController> {
  const PostScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SizedBox(
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

                  // ── Header ──────────────────────────────────────────
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
                        GestureDetector(
                          onTap: () => Get.toNamed(AppRoutes.profilePage),
                          child: const AppProfileAvatar(),
                        ),
                      ],
                    );
                  }),

                  SizedBox(height: 8.h),

                  // ── Body ────────────────────────────────────────────
                  Expanded(
                    child: Obx(() {
                      // Loading
                      if (controller.isPostsLoading.value &&
                          controller.posts.isEmpty) {
                        return const Center(
                          child: CircularProgressIndicator(
                              color: Color(0xFF7B1FE0), strokeWidth: 2),
                        );
                      }

                      // Subscription required — show upgrade prompt
                      if (controller.accessLevel.value == 'limited') {
                        return _SubscriptionLockedState(
                          onSubscribe: () =>
                              Get.toNamed(AppRoutes.subscripFirstPage),
                        );
                      }

                      // Generic error
                      if (controller.postsError.value.isNotEmpty &&
                          controller.posts.isEmpty) {
                        return _PostsError(
                          message: controller.postsError.value,
                          onRetry: controller.loadPosts,
                        );
                      }

                      // No posts yet
                      if (controller.posts.isEmpty) {
                        return const _EmptyPostsState();
                      }

                      // Full post list
                      return RefreshIndicator(
                        onRefresh: () => controller.loadPosts(refresh: true),
                        color: const Color(0xFF7B1FE0),
                        backgroundColor: const Color(0xFF1B1830),
                        child: NotificationListener<ScrollNotification>(
                          onNotification: (notification) {
                            if (notification.metrics.extentAfter < 320 &&
                                controller.postsError.isEmpty) {
                              controller.loadPosts(loadMore: true);
                            }
                            return false;
                          },
                          child: ListView.builder(
                            padding: EdgeInsets.only(top: 16.h, bottom: 90.h),
                            itemCount: controller.posts.length +
                                (controller.isLoadingMorePosts.value ||
                                        (controller.postsError.isNotEmpty &&
                                            controller.hasMorePosts)
                                    ? 1
                                    : 0),
                            itemBuilder: (context, index) {
                              if (index >= controller.posts.length) {
                                if (!controller.isLoadingMorePosts.value) {
                                  return Center(
                                    child: TextButton(
                                      onPressed: () =>
                                          controller.loadPosts(loadMore: true),
                                      child: const Text('Retry loading posts'),
                                    ),
                                  );
                                }
                                return const Padding(
                                  padding: EdgeInsets.all(16),
                                  child: Center(
                                    child: CircularProgressIndicator(
                                      color: Color(0xFF7B1FE0),
                                      strokeWidth: 2,
                                    ),
                                  ),
                                );
                              }
                              return _PostCard(post: controller.posts[index]);
                            },
                          ),
                        ),
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

// ── Post Card ─────────────────────────────────────────────────────────────

class _PostCard extends StatelessWidget {
  final PostModel post;
  const _PostCard({required this.post});

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.find<PostController>();

    return Padding(
      padding: EdgeInsets.only(bottom: 18.h),
      child: GestureDetector(
        onTap: () => ctrl.onPostTap(post),
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
                  // ── Cover image / category badge ───────────────
                  Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(14.r),
                        child: post.coverImage != null
                            ? Image.network(
                                post.coverImage!,
                                width: double.infinity,
                                height: 160.h,
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) =>
                                    _ImageFallback(height: 160.h),
                              )
                            : _ImageFallback(height: 160.h),
                      ),
                      Positioned(
                        top: 12.h,
                        right: 12.w,
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 12.w, vertical: 6.h),
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.55),
                            borderRadius: BorderRadius.circular(20.r),
                          ),
                          child: Text(
                            post.category, // ← was post.tag
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
                        // ── Author row ───────────────────────────
                        Row(
                          children: [
                            _PostAuthorAvatar(author: post.author),
                            SizedBox(width: 8.w),
                            Text(
                              post.author.name,
                              style: GoogleFonts.poppins(
                                fontSize: 13.sp,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(width: 4.w),
                            if (post.author.isVerified) ...[
                              SizedBox(width: 4.w),
                              Icon(Icons.verified,
                                  size: 14.sp, color: const Color(0xFF7B1FE0)),
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

                        // ── Title ────────────────────────────────
                        Text(
                          post.title,
                          style: GoogleFonts.poppins(
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 6.h),

                        // ── Excerpt ──────────────────────────────
                        Text(
                          post.excerpt, // ← was post.description
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
                        Divider(color: Colors.white38, thickness: 0.5),
                        SizedBox(height: 12.h),

                        // ── Stats row ─────────────────────────────
                        Row(
                          children: [
                            GestureDetector(
                              onTap: () => ctrl.onTogglePostLike(post.id),
                              child: Row(
                                children: [
                                  Icon(
                                    post.isLiked
                                        ? Icons.favorite
                                        : Icons.favorite_border,
                                    size: 16.sp,
                                    color: post.isLiked
                                        ? Colors.redAccent
                                        : Colors.white54,
                                  ),
                                  SizedBox(width: 6.w),
                                  Text(
                                    '${post.likes}',
                                    style: GoogleFonts.poppins(
                                        fontSize: 12.sp, color: Colors.white54),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(width: 20.w),
                            Icon(Icons.mode_comment_outlined,
                                size: 16.sp, color: Colors.white54),
                            SizedBox(width: 6.w),
                            Text(
                              '${post.commentsCount}', // ← was post.comments
                              style: GoogleFonts.poppins(
                                  fontSize: 12.sp, color: Colors.white54),
                            ),
                            const Spacer(),
                            GestureDetector(
                              onTap: () => ctrl.onSharePost(post.id),
                              child: Row(
                                children: [
                                  Icon(Icons.share_outlined,
                                      size: 16.sp, color: Colors.white54),
                                  SizedBox(width: 6.w),
                                  Text(
                                    '${post.sharesCount}', // ← was post.shares
                                    style: GoogleFonts.poppins(
                                        fontSize: 12.sp, color: Colors.white54),
                                  ),
                                ],
                              ),
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

// ── Image fallback ────────────────────────────────────────────────────────

class _ImageFallback extends StatelessWidget {
  final double height;
  const _ImageFallback({required this.height});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: height,
      color: const Color(0xFF1B1830),
      child: Icon(Icons.image_outlined,
          size: 40, color: Colors.white.withValues(alpha: 0.15)),
    );
  }
}

class _PostAuthorAvatar extends StatelessWidget {
  final PostAuthor author;

  const _PostAuthorAvatar({required this.author});

  @override
  Widget build(BuildContext context) {
    final url = author.avatarUrl;
    return ClipRRect(
      borderRadius: BorderRadius.circular(8.r),
      child: url != null && url.isNotEmpty
          ? Image.network(
              url,
              width: 26.w,
              height: 26.w,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => _fallback(),
            )
          : _fallback(),
    );
  }

  Widget _fallback() {
    return Container(
      width: 26.w,
      height: 26.w,
      alignment: Alignment.center,
      color: const Color(0xFF7B1FE0),
      child: Text(
        author.initials,
        style: GoogleFonts.poppins(
          fontSize: 10.sp,
          fontWeight: FontWeight.w700,
          color: Colors.white,
        ),
      ),
    );
  }
}

// ── Error state ───────────────────────────────────────────────────────────

class _PostsError extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;
  const _PostsError({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 40.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.error_outline, color: Colors.redAccent, size: 32.sp),
            SizedBox(height: 12.h),
            Text(message,
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                    fontSize: 13.sp, color: Colors.white54)),
            SizedBox(height: 14.h),
            TextButton(
              onPressed: onRetry,
              child: Text('Retry',
                  style: GoogleFonts.poppins(
                      fontSize: 13.sp, color: const Color(0xFF7B1FE0))),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Subscription locked state ─────────────────────────────────────────────

class _SubscriptionLockedState extends StatelessWidget {
  final VoidCallback onSubscribe;
  const _SubscriptionLockedState({required this.onSubscribe});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 32.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Lock icon with glow
            Container(
              width: 80.w,
              height: 80.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: const LinearGradient(
                  colors: [Color(0xFF7B1FE0), Color(0xFF4A0FA8)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF7B1FE0).withValues(alpha: 0.5),
                    blurRadius: 24,
                    spreadRadius: 4,
                  ),
                ],
              ),
              child: Icon(Icons.lock_outline_rounded,
                  size: 36.sp, color: Colors.white),
            ),
            SizedBox(height: 24.h),

            Text(
              'Premium Content',
              style: GoogleFonts.poppins(
                fontSize: 20.sp,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 10.h),

            Text(
              'Subscribe to access exclusive market insights,\ntrading updates, and expert analysis.',
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: 13.sp,
                color: Colors.white54,
                height: 1.5,
              ),
            ),
            SizedBox(height: 28.h),

            // Feature chips
            Wrap(
              spacing: 8.w,
              runSpacing: 8.h,
              alignment: WrapAlignment.center,
              children: [
                _FeatureChip(label: '📊 Market Analysis'),
                _FeatureChip(label: '💡 Trading Signals'),
                _FeatureChip(label: '📰 Expert Posts'),
                _FeatureChip(label: '🔔 Daily Insights'),
              ],
            ),
            SizedBox(height: 32.h),

            // Subscribe button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: onSubscribe,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF7B1FE0),
                  padding: EdgeInsets.symmetric(vertical: 16.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14.r),
                  ),
                  elevation: 0,
                ),
                child: Text(
                  'View Subscription Plans',
                  style: GoogleFonts.poppins(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FeatureChip extends StatelessWidget {
  final String label;
  const _FeatureChip({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.07),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: Colors.white.withValues(alpha: 0.12)),
      ),
      child: Text(
        label,
        style: GoogleFonts.poppins(
          fontSize: 11.sp,
          color: Colors.white70,
        ),
      ),
    );
  }
}

// ── Empty state ───────────────────────────────────────────────────────────

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
                    child: _bubble(60.w, const Color(0xFF3A3160))),
                Positioned(
                    right: 20.w,
                    top: 30.h,
                    child: _bubble(70.w, const Color(0xFF433A70))),
                Positioned(
                    top: 70.h, child: _bubble(90.w, const Color(0xFF5C4E99))),
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
                Positioned(top: 10.h, left: 40.w, child: _dot(8.w)),
                Positioned(top: 0, right: 30.w, child: _dot(6.w)),
                Positioned(top: 40.h, right: 0, child: _dot(10.w)),
                Positioned(bottom: 10.h, left: 20.w, child: _dot(9.w)),
              ],
            ),
          ),
          SizedBox(height: 24.h),
          Text(
            'No posts yet',
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

  Widget _bubble(double size, Color color) => Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.6),
          shape: BoxShape.circle,
        ),
      );

  Widget _dot(double size) => Container(
        width: size,
        height: size,
        decoration: const BoxDecoration(
          color: Color(0xFF9B5CFF),
          shape: BoxShape.circle,
        ),
      );
}
