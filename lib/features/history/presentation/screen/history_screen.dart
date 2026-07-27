import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/utils/customeTextField/custom_text_field.dart';
import '../../data/model/history_signal_model.dart';
import '../container/history_container.dart';


class HistoryScreen extends GetView<HistoryContainer> {
  const HistoryScreen({super.key});

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
                              'History',
                              style: GoogleFonts.poppins(
                                fontSize: 24.sp,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(height: 4.h),
                            Text(
                              'Track your completed trading signals',
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
                  ),

                  SizedBox(height: 18.h),

                  // -------- Performance overview (glass) --------
                  _GlassContainer(
                    padding: EdgeInsets.all(16.w),
                    borderRadius: 18.r,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'PERFORMANCE OVERVIEW',
                          style: GoogleFonts.poppins(
                            fontSize: 10.sp,
                            fontWeight: FontWeight.w600,
                            color: Colors.white38,
                            letterSpacing: 1.2,
                          ),
                        ),
                        SizedBox(height: 14.h),
                        SizedBox(
                          height: 44.h,
                          child: Obx(
                                () => Row(
                              children: [
                                _StatItem(
                                  value: '${controller.wins.value}',
                                  label: 'Wins',
                                  color: const Color(0xFF2ECC71),
                                ),
                                VerticalDivider(color: Colors.white38, thickness: 0.5),
                                _StatItem(
                                  value: '${controller.losses.value}',
                                  label: 'Losses',
                                  color: const Color(0xFFE0405C),
                                ),
                                VerticalDivider(color: Colors.white38, thickness: 0.5),
                                _StatItem(
                                  value: '${controller.breakeven.value}',
                                  label: 'Breakeven',
                                  color: Colors.white70,
                                ),
                                VerticalDivider(color: Colors.white38, thickness: 0.5),
                                _StatItem(
                                  value: '${controller.winRate.toStringAsFixed(1)}%',
                                  label: 'Win Rate',
                                  color: const Color(0xFFE0A11F),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 18.h),

                  // -------- Search + Filter --------
                  Row(
                    children: [
                      Expanded(
                        child: CustomTextField(
                          controller: TextEditingController(),
                          onChanged: (value) => controller.onSearchChanged(value ?? ''),
                          hintText: 'Search Signals...',
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
                      ),
                      SizedBox(width: 10.w),
                      GestureDetector(
                        onTap: controller.toggleFilterPanel,
                        child: Container(
                          height: 50.h,
                          width: 50.h,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: const Color(0xFF1B1830),
                            borderRadius: BorderRadius.circular(14.r),
                            border: Border.all(color: Colors.white.withValues(alpha: 0.06)),
                          ),
                          child: Icon(Icons.tune, size: 18.sp, color: Colors.white70),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 16.h),

                  Obx(
                        () => Text(
                      'CLOSED SIGNALS · ${controller.totalClosed} TOTAL',
                      style: GoogleFonts.poppins(
                        fontSize: 10.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.white38,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ),

                  SizedBox(height: 12.h),

                  // -------- List --------
                  Expanded(
                    child: Obx(() {
                      final list = controller.filteredSignals;
                      if (list.isEmpty) {
                        return Center(
                          child: Text(
                            'No closed signals found',
                            style: GoogleFonts.poppins(
                              fontSize: 13.sp,
                              color: Colors.white38,
                            ),
                          ),
                        );
                      }
                      return ListView.builder(
                        padding: EdgeInsets.only(bottom: 100.h),
                        itemCount: list.length,
                        itemBuilder: (context, index) =>
                            _HistoryCard(item: list[index]),
                      );
                    }),
                  ),
                ],
              ),
            ),
          ),

          // -------- Filter dropdown panel (overlay) --------
          Obx(() {
            if (!controller.isFilterPanelOpen.value) return const SizedBox.shrink();
            return Stack(
              children: [
                GestureDetector(
                  onTap: controller.closeFilterPanel,
                  child: Container(color: Colors.black.withValues(alpha: 0.3)),
                ),
                Positioned(
                  top: 220.h,
                  right: 20.w,
                  child: _FilterPanel(controller: controller),
                ),
              ],
            );
          }),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String value;
  final String label;
  final Color color;

  const _StatItem({required this.value, required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Text(
            value,
            style: GoogleFonts.poppins(
              fontSize: 18.sp,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: 10.sp,
              fontWeight: FontWeight.w400,
              color: Colors.white54,
            ),
          ),
        ],
      ),
    );
  }
}

class _FilterPanel extends StatelessWidget {
  final HistoryContainer controller;
  const _FilterPanel({required this.controller});

  @override
  Widget build(BuildContext context) {
    return _GlassContainer(
      padding: EdgeInsets.symmetric(vertical: 10.w, horizontal: 6.w),
      borderRadius: 16.r,
      child: Obx(
            () => Column(
          mainAxisSize: MainAxisSize.min,
          children: controller.filters.map((filter) {
            final isSelected = controller.selectedFilter.value == filter;
            return GestureDetector(
              onTap: () => controller.selectFilter(filter),
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 6.w, vertical: 4.h),
                padding: EdgeInsets.symmetric(horizontal: 22.w, vertical: 10.h),
                decoration: BoxDecoration(
                  color: isSelected ? const Color(0xFF7B1FE0) : Colors.transparent,
                  borderRadius: BorderRadius.circular(24.r),
                ),
                child: Text(
                  filter,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w600,
                    color: isSelected ? Colors.white : Colors.white70,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}

class _HistoryCard extends StatelessWidget {
  final HistorySignalModel item;
  const _HistoryCard({required this.item});

  @override
  Widget build(BuildContext context) {
    final isWin = item.result == HistoryResult.win;
    final isLoss = item.result == HistoryResult.loss;
    final resultColor = isWin
        ? const Color(0xFF2ECC71)
        : isLoss
        ? const Color(0xFFE0405C)
        : Colors.white54;
    final isBuy = item.side == HistorySide.buy;

    return Padding(
      padding: EdgeInsets.only(bottom: 14.h),
      child: _GlassContainer(
        padding: EdgeInsets.all(14.w),
        borderRadius: 16.r,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      width: 22.w,
                      height: 22.w,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: resultColor.withValues(alpha: 0.15),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        isWin
                            ? Icons.check
                            : isLoss
                            ? Icons.close
                            : Icons.remove,
                        size: 13.sp,
                        color: resultColor,
                      ),
                    ),
                    SizedBox(width: 8.w),
                    Text(
                      item.pair,
                      style: GoogleFonts.poppins(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                Text(
                  '${item.profitPercent >= 0 ? '+' : ''}${item.profitPercent.toStringAsFixed(2)}%',
                  style: GoogleFonts.poppins(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w700,
                    color: resultColor,
                  ),
                ),
              ],
            ),
            SizedBox(height: 8.h),
            Row(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
                  decoration: BoxDecoration(
                    color: (isBuy ? const Color(0xFF2ECC71) : const Color(0xFFE0405C))
                        .withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(6.r),
                  ),
                  child: Text(
                    isBuy ? 'BUY' : 'SELL',
                    style: GoogleFonts.poppins(
                      fontSize: 9.sp,
                      fontWeight: FontWeight.w700,
                      color: isBuy ? const Color(0xFF2ECC71) : const Color(0xFFE0405C),
                    ),
                  ),
                ),
                SizedBox(width: 8.w),
                Text(
                  item.categoryLabel,
                  style: GoogleFonts.poppins(fontSize: 11.sp, color: Colors.white54),
                ),
                const Spacer(),
                Text(
                  'R:R ${item.riskReward}',
                  style: GoogleFonts.poppins(fontSize: 11.sp, color: Colors.white38),
                ),
              ],
            ),
            SizedBox(height: 10.h),
            Divider(color: Colors.white24, thickness: 0.5),
            SizedBox(height: 10.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '\$${item.entryPrice.toStringAsFixed(2)} → \$${item.exitPrice.toStringAsFixed(2)}',
                  style: GoogleFonts.poppins(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w500,
                    color: Colors.white70,
                  ),
                ),
                Row(
                  children: [
                    Text(
                      item.duration,
                      style: GoogleFonts.poppins(fontSize: 11.sp, color: Colors.white38),
                    ),
                    SizedBox(width: 8.w),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
                      decoration: BoxDecoration(
                        color: resultColor.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(6.r),
                      ),
                      child: Text(
                        isWin
                            ? 'WIN'
                            : isLoss
                            ? 'LOSS'
                            : 'BE',
                        style: GoogleFonts.poppins(
                          fontSize: 9.sp,
                          fontWeight: FontWeight.w700,
                          color: resultColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 6.h),
            Text(
              item.closedDate,
              style: GoogleFonts.poppins(fontSize: 10.sp, color: Colors.white24),
            ),
          ],
        ),
      ),
    );
  }
}

class _GlassContainer extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final double borderRadius;

  const _GlassContainer({
    required this.child,
    required this.padding,
    required this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Container(
          padding: padding,
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.06),
            borderRadius: BorderRadius.circular(borderRadius),
            border: Border.all(color: Colors.white.withValues(alpha: 0.14)),
          ),
          child: child,
        ),
      ),
    );
  }
}