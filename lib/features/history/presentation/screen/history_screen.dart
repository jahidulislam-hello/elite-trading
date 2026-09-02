import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../core/utils/customeTextField/custom_text_field.dart';
import '../../../profile/widget/app_profile_avatar.dart';
import '../../../signals/data/model/signal_model.dart';
import '../container/history_container.dart';

class HistoryScreen extends GetView<HistoryContainer> {
  const HistoryScreen({super.key});

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
                      GestureDetector(
                        onTap: () => Get.toNamed(AppRoutes.profilePage),
                        child: const AppProfileAvatar(),
                      ),
                    ],
                  ),

                  SizedBox(height: 18.h),

                  // ── Performance overview ─────────────────────────────
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
                        Obx(() => controller.isLoading.value &&
                                controller.signals.isEmpty
                            ? SizedBox(
                                height: 49.h,
                                child: const Center(
                                  child: CircularProgressIndicator(
                                    color: Color(0xFF7B1FE0),
                                    strokeWidth: 2,
                                  ),
                                ),
                              )
                            : SizedBox(
                                height: 49.h,
                                child: Row(
                                  children: [
                                    _StatItem(
                                      value: '${controller.wins.value}',
                                      label: 'Wins',
                                      color: const Color(0xFF2ECC71),
                                    ),
                                    VerticalDivider(
                                        color: Colors.white38,
                                        thickness: 0.5),
                                    _StatItem(
                                      value: '${controller.losses.value}',
                                      label: 'Losses',
                                      color: const Color(0xFFE0405C),
                                    ),
                                    VerticalDivider(
                                        color: Colors.white38,
                                        thickness: 0.5),
                                    _StatItem(
                                      value: '${controller.breakeven.value}',
                                      label: 'Breakeven',
                                      color: Colors.white70,
                                    ),
                                    VerticalDivider(
                                        color: Colors.white38,
                                        thickness: 0.5),
                                    _StatItem(
                                      value:
                                          '${controller.winRate.toStringAsFixed(1)}%',
                                      label: 'Win Rate',
                                      color: const Color(0xFFE0A11F),
                                    ),
                                  ],
                                ),
                              )),
                      ],
                    ),
                  ),

                  SizedBox(height: 18.h),

                  // ── Search + Filter ──────────────────────────────────
                  Row(
                    children: [
                      Expanded(
                        child: CustomTextField(
                          controller: controller.searchController,
                          onChanged: (value) =>
                              controller.onSearchChanged(value ?? ''),
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
                      Obx(() {
                        final isFiltered =
                            controller.selectedFilter.value != 'All';
                        return GestureDetector(
                          onTap: controller.toggleFilterPanel,
                          child: Container(
                            height: 50.h,
                            width: 50.h,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: const Color(0xFF1B1830),
                              borderRadius: BorderRadius.circular(14.r),
                              border: Border.all(
                                color: isFiltered
                                    ? const Color(0xFF7B1FE0)
                                    : Colors.white.withValues(alpha: 0.06),
                              ),
                            ),
                            child: Icon(
                              Icons.tune,
                              size: 18.sp,
                              color: isFiltered
                                  ? const Color(0xFF9B6BFF)
                                  : Colors.white70,
                            ),
                          ),
                        );
                      }),
                    ],
                  ),

                  SizedBox(height: 16.h),

                  Obx(
                    () => Text(
                      'CLOSED SIGNALS · ${controller.totalClosed.value} TOTAL',
                      style: GoogleFonts.poppins(
                        fontSize: 10.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.white38,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ),

                  SizedBox(height: 12.h),

                  // ── List ─────────────────────────────────────────────
                  Expanded(
                    child: Obx(() {
                      // Loading state
                      if (controller.isLoading.value &&
                          controller.signals.isEmpty) {
                        return const Center(
                          child: CircularProgressIndicator(
                              color: Color(0xFF7B1FE0), strokeWidth: 2),
                        );
                      }

                      // No subscription / access locked
                      if (controller.accessLevel.value != 'full' &&
                          controller.signals.isEmpty) {
                        return _LockedState(
                            onSubscribe: () =>
                                Get.toNamed(AppRoutes.subscripFirstPage));
                      }

                      // Error state
                      if (controller.error.value.isNotEmpty &&
                          controller.signals.isEmpty) {
                        return _ErrorState(
                          message: controller.error.value,
                          onRetry: controller.loadHistory,
                        );
                      }

                      final list = controller.filteredSignals;
                      if (list.isEmpty) {
                        final filter = controller.selectedFilter.value;
                        return Center(
                          child: Text(
                            filter == 'All'
                                ? 'No closed signals found'
                                : 'No $filter signals found',
                            style: GoogleFonts.poppins(
                              fontSize: 13.sp,
                              color: Colors.white38,
                            ),
                          ),
                        );
                      }

                      return RefreshIndicator(
                        onRefresh: () =>
                            controller.loadHistory(refresh: true),
                        color: const Color(0xFF7B1FE0),
                        backgroundColor: const Color(0xFF1B1830),
                        child: ListView.builder(
                          padding: EdgeInsets.only(bottom: 100.h),
                          itemCount: list.length,
                          itemBuilder: (context, index) =>
                              _HistoryCard(item: list[index]),
                        ),
                      );
                    }),
                  ),
                ],
              ),
            ),
          ),

          // ── Filter dropdown panel (overlay) ──────────────────────────
          Obx(() {
            if (!controller.isFilterPanelOpen.value) {
              return const SizedBox.shrink();
            }
            return Stack(
              children: [
                GestureDetector(
                  onTap: controller.closeFilterPanel,
                  child: Container(
                      color: Colors.black.withValues(alpha: 0.3)),
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

// ────────────────────────────────────────────────────────────────────────────
// Stat item
// ────────────────────────────────────────────────────────────────────────────

class _StatItem extends StatelessWidget {
  final String value;
  final String label;
  final Color color;

  const _StatItem(
      {required this.value, required this.label, required this.color});

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

// ────────────────────────────────────────────────────────────────────────────
// Filter panel
// ────────────────────────────────────────────────────────────────────────────

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
                margin:
                    EdgeInsets.symmetric(horizontal: 6.w, vertical: 4.h),
                padding: EdgeInsets.symmetric(
                    horizontal: 22.w, vertical: 10.h),
                decoration: BoxDecoration(
                  color: isSelected
                      ? const Color(0xFF7B1FE0)
                      : Colors.transparent,
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

// ────────────────────────────────────────────────────────────────────────────
// History Card — uses SignalHistoryModel from API
// ────────────────────────────────────────────────────────────────────────────

class _HistoryCard extends StatelessWidget {
  final SignalHistoryModel item;
  const _HistoryCard({required this.item});

  @override
  Widget build(BuildContext context) {
    final resultColor = item.isWin
        ? const Color(0xFF2ECC71)
        : item.isLoss
            ? const Color(0xFFE0405C)
            : Colors.white54;

    final isBuy = item.direction == 'BUY';
    final pnl = item.pnlPercent ?? 0.0;

    return Padding(
      padding: EdgeInsets.only(bottom: 14.h),
      child: _GlassContainer(
        padding: EdgeInsets.all(14.w),
        borderRadius: 16.r,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Top row: asset + PnL ─────────────────────────────
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
                        item.isWin
                            ? Icons.check
                            : item.isLoss
                                ? Icons.close
                                : Icons.remove,
                        size: 13.sp,
                        color: resultColor,
                      ),
                    ),
                    SizedBox(width: 8.w),
                    Text(
                      item.asset,
                      style: GoogleFonts.poppins(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                Text(
                  item.pnlLabel ??
                      '${pnl >= 0 ? '+' : ''}${pnl.toStringAsFixed(2)}%',
                  style: GoogleFonts.poppins(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w700,
                    color: resultColor,
                  ),
                ),
              ],
            ),

            SizedBox(height: 8.h),

            // ── Direction + category + R:R ───────────────────────
            Row(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(
                      horizontal: 8.w, vertical: 3.h),
                  decoration: BoxDecoration(
                    color: (isBuy
                            ? const Color(0xFF2ECC71)
                            : const Color(0xFFE0405C))
                        .withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(6.r),
                  ),
                  child: Text(
                    item.direction,
                    style: GoogleFonts.poppins(
                      fontSize: 9.sp,
                      fontWeight: FontWeight.w700,
                      color: isBuy
                          ? const Color(0xFF2ECC71)
                          : const Color(0xFFE0405C),
                    ),
                  ),
                ),
                SizedBox(width: 8.w),
                Text(
                  item.categoryLabel,
                  style: GoogleFonts.poppins(
                      fontSize: 11.sp, color: Colors.white54),
                ),
                SizedBox(width: 8.w),
                if (item.timeframeLabel.isNotEmpty)
                  Text(
                    '· ${item.timeframeLabel}',
                    style: GoogleFonts.poppins(
                        fontSize: 11.sp, color: Colors.white38),
                  ),
                const Spacer(),
                if (item.riskRewardRatio != null)
                  Text(
                    'R:R ${item.riskRewardRatio}',
                    style: GoogleFonts.poppins(
                        fontSize: 11.sp, color: Colors.white38),
                  ),
              ],
            ),

            SizedBox(height: 10.h),
            Divider(color: Colors.white24, thickness: 0.5),
            SizedBox(height: 10.h),

            // ── Price movement + duration + result badge ─────────
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    item.priceMovementLabel,
                    style: GoogleFonts.poppins(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w500,
                      color: Colors.white70,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Row(
                  children: [
                    if (item.duration != null) ...[
                      Text(
                        item.duration!,
                        style: GoogleFonts.poppins(
                            fontSize: 11.sp, color: Colors.white38),
                      ),
                      SizedBox(width: 8.w),
                    ],
                    Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 8.w, vertical: 3.h),
                      decoration: BoxDecoration(
                        color: resultColor.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(6.r),
                      ),
                      child: Text(
                        item.outcomeLabel ??
                            (item.isWin
                                ? 'WIN'
                                : item.isLoss
                                    ? 'LOSS'
                                    : 'BE'),
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

            // ── Closed date ──────────────────────────────────────
            Text(
              item.closedLabel,
              style:
                  GoogleFonts.poppins(fontSize: 10.sp, color: Colors.white24),
            ),
          ],
        ),
      ),
    );
  }
}

// ────────────────────────────────────────────────────────────────────────────
// Locked state (no subscription)
// ────────────────────────────────────────────────────────────────────────────

class _LockedState extends StatelessWidget {
  final VoidCallback onSubscribe;
  const _LockedState({required this.onSubscribe});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: EdgeInsets.all(20.w),
              decoration: BoxDecoration(
                color: const Color(0xFF7B1FE0).withValues(alpha: 0.12),
                shape: BoxShape.circle,
                border: Border.all(
                    color: const Color(0xFF7B1FE0).withValues(alpha: 0.3)),
              ),
              child: Icon(Icons.lock_outline,
                  size: 36.sp, color: const Color(0xFF9B6BFF)),
            ),
            SizedBox(height: 20.h),
            Text(
              'History Locked',
              style: GoogleFonts.poppins(
                fontSize: 18.sp,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 10.h),
            Text(
              'Subscribe to unlock your completed signal history and track performance.',
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: 13.sp,
                color: Colors.white54,
                height: 1.5,
              ),
            ),
            SizedBox(height: 24.h),
            GestureDetector(
              onTap: onSubscribe,
              child: Container(
                width: double.infinity,
                height: 50.h,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF9B2BFF), Color(0xFF6A1BFF)],
                  ),
                  borderRadius: BorderRadius.circular(14.r),
                ),
                child: Text(
                  'Subscribe Now',
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
    );
  }
}

// ────────────────────────────────────────────────────────────────────────────
// Error state
// ────────────────────────────────────────────────────────────────────────────

class _ErrorState extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;
  const _ErrorState({required this.message, required this.onRetry});

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
            Text(
              message,
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                  fontSize: 13.sp, color: Colors.white54),
            ),
            SizedBox(height: 14.h),
            TextButton(
              onPressed: onRetry,
              child: Text(
                'Retry',
                style: GoogleFonts.poppins(
                    fontSize: 13.sp, color: const Color(0xFF7B1FE0)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ────────────────────────────────────────────────────────────────────────────
// Glass container
// ────────────────────────────────────────────────────────────────────────────

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
