import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/utils/customeTextField/custom_text_field.dart';
import '../controller/signal_controller.dart';
import '../widget/signal_card.dart';

class AllSingnalScreen extends GetView<SignalController> {
  const AllSingnalScreen({super.key});

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
                              child: Icon(Icons.arrow_back,
                                  color: Colors.white, size: 18.sp),
                            ),
                          ),
                          SizedBox(width: 14.w),
                          Text(
                            'All Signals',
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
                          padding: EdgeInsets.symmetric(
                              horizontal: 10.w, vertical: 4.h),
                          decoration: BoxDecoration(
                            color:
                                const Color(0xFF7B1FE0).withValues(alpha: 0.2),
                            shape: BoxShape.circle,
                            border: Border.all(
                                color: const Color(0xFF7B1FE0), width: 0.5),
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

                  SizedBox(height: 18.h),

                  // -------- Search field --------
                  CustomTextField(
                    controller: controller.searchController,
                    onChanged: (value) =>
                        controller.onSearchChanged(value ?? ''),
                    hintText: 'Search assets — BTC, EUR/USD, XAU...',
                    prefixIcon: Icon(Icons.search, size: 18.sp),
                    iconColor: Colors.white38,
                    filColor: const Color(0xFF1B1830),
                    hinTextColor: Colors.white,
                    borderColor: Colors.white.withValues(alpha: 0.06),
                    borderRadius: 14,
                    borderHeight: 1,
                    contentPaddingHorizontal: 14,
                    contentPaddingVertical: 14,
                    hinTextSize: 13,
                    isvalidation: false,
                  ),

                  SizedBox(height: 14.h),

                  // -------- Category tabs --------
                  SizedBox(
                    height: 40.h,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: controller.categories.length,
                      separatorBuilder: (_, __) => SizedBox(width: 10.w),
                      itemBuilder: (context, index) {
                        final category = controller.categories[index];
                        return Obx(() {
                          final isSelected =
                              controller.selectedCategory.value == category;
                          return GestureDetector(
                            onTap: () => controller.selectCategory(category),
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 20.w),
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? const Color(0xFF7B1FE0)
                                    : const Color(0xFF1B1830),
                                borderRadius: BorderRadius.circular(24.r),
                                border: Border.all(
                                  color: isSelected
                                      ? const Color(0xFF7B1FE0)
                                      : Colors.white.withValues(alpha: 0.06),
                                ),
                              ),
                              child: Text(
                                category,
                                style: GoogleFonts.poppins(
                                  fontSize: 13.sp,
                                  fontWeight: FontWeight.w600,
                                  color: isSelected
                                      ? Colors.white
                                      : Colors.white70,
                                ),
                              ),
                            ),
                          );
                        });
                      },
                    ),
                  ),

                  SizedBox(height: 18.h),

                  // -------- API-filtered signal list --------
                  Expanded(
                    child: Obx(() {
                      if (controller.isSignalsLoading.value &&
                          controller.signals.isEmpty) {
                        return const Center(
                          child: CircularProgressIndicator(
                            color: Color(0xFF7B1FE0),
                            strokeWidth: 2,
                          ),
                        );
                      }

                      if (controller.signalsError.value.isNotEmpty &&
                          controller.signals.isEmpty) {
                        return Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                controller.signalsError.value,
                                textAlign: TextAlign.center,
                                style: GoogleFonts.poppins(
                                  fontSize: 13.sp,
                                  color: Colors.white54,
                                ),
                              ),
                              SizedBox(height: 12.h),
                              TextButton(
                                onPressed: () =>
                                    controller.loadSignals(refresh: true),
                                child: Text(
                                  'Retry',
                                  style: GoogleFonts.poppins(
                                    fontSize: 13.sp,
                                    color: const Color(0xFF7B1FE0),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      }

                      final list = controller.filteredSignals;
                      if (list.isEmpty) {
                        return Center(
                          child: Text(
                            'No signals found',
                            style: GoogleFonts.poppins(
                              fontSize: 13.sp,
                              color: Colors.white38,
                            ),
                          ),
                        );
                      }

                      return RefreshIndicator(
                        onRefresh: () => controller.loadSignals(refresh: true),
                        color: const Color(0xFF7B1FE0),
                        backgroundColor: const Color(0xFF1B1830),
                        child: NotificationListener<ScrollNotification>(
                          onNotification: (notification) {
                            if (notification.metrics.extentAfter < 320 &&
                                controller.signalsError.isEmpty) {
                              controller.loadSignals(loadMore: true);
                            }
                            return false;
                          },
                          child: ListView.builder(
                            padding: EdgeInsets.only(bottom: 20.h),
                            itemCount: list.length +
                                (controller.isLoadingMoreSignals.value ||
                                        (controller.signalsError.isNotEmpty &&
                                            controller.hasMoreSignals)
                                    ? 1
                                    : 0),
                            itemBuilder: (context, index) {
                              if (index >= list.length) {
                                if (!controller.isLoadingMoreSignals.value) {
                                  return Center(
                                    child: TextButton(
                                      onPressed: () => controller.loadSignals(
                                        loadMore: true,
                                      ),
                                      child:
                                          const Text('Retry loading signals'),
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
                              return SignalCard(signal: list[index]);
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
