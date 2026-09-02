import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../data/model/signal_model.dart';
import '../controller/signal_controller.dart';
import '../widget/signal_candle_chart.dart';

class SignalDetailScreen extends GetView<SignalController> {
  const SignalDetailScreen({super.key});

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
            child: Obx(() {
              final listItem = controller.currentSignalListItem.value;
              final detail = controller.currentSignalDetail.value;
              final isLoading = controller.isDetailLoading.value;

              // ── Header info comes from listItem immediately ──────────
              final asset = detail?.header.asset ??
                  listItem?.asset ??
                  '—';
              final direction = detail?.header.direction ??
                  listItem?.direction ??
                  'BUY';
              final isBuy = direction == 'BUY';
              final status = detail?.header.status ??
                  listItem?.status ??
                  'Active';
              final isActive = status == 'Active';

              return SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 30.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ── Header row ──────────────────────────────────
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
                              asset.replaceAll('/', ' / '),
                              style: GoogleFonts.poppins(
                                fontSize: 18.sp,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                        GestureDetector(
                          onTap: controller.toggleFavorite,
                          child: Obx(() => Icon(
                                controller.isFavorite.value
                                    ? Icons.star
                                    : Icons.star_border,
                                color: const Color(0xFFE0A11F),
                                size: 22.sp,
                              )),
                        ),
                      ],
                    ),

                    SizedBox(height: 18.h),

                    // ── Direction + status pills ────────────────────
                    Row(
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 12.w, vertical: 6.h),
                          decoration: BoxDecoration(
                            color: isBuy
                                ? const Color(0xFF2ECC71)
                                    .withValues(alpha: 0.18)
                                : const Color(0xFFE0405C)
                                    .withValues(alpha: 0.18),
                            borderRadius: BorderRadius.circular(20.r),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: 6.w,
                                height: 6.w,
                                decoration: BoxDecoration(
                                  color: isBuy
                                      ? const Color(0xFF2ECC71)
                                      : const Color(0xFFE0405C),
                                  shape: BoxShape.circle,
                                ),
                              ),
                              SizedBox(width: 6.w),
                              Text(
                                isBuy ? 'Buy Signal' : 'Sell Signal',
                                style: GoogleFonts.poppins(
                                  fontSize: 11.sp,
                                  fontWeight: FontWeight.w600,
                                  color: isBuy
                                      ? const Color(0xFF2ECC71)
                                      : const Color(0xFFE0405C),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: 10.w),
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 12.w, vertical: 6.h),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.06),
                            borderRadius: BorderRadius.circular(20.r),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                isActive
                                    ? Icons.check_circle_outline
                                    : Icons.watch_later_outlined,
                                size: 12.sp,
                                color: Colors.white54,
                              ),
                              SizedBox(width: 5.w),
                              Text(
                                status,
                                style: GoogleFonts.poppins(
                                  fontSize: 11.sp,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white54,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 18.h),

                    // ── Live price + change ─────────────────────────
                    if (isLoading && detail == null)
                      _LoadingRow()
                    else if (detail != null) ...[
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            detail.live.currentPrice != null
                                ? detail.live.currentPrice!
                                    .toStringAsFixed(
                                        (detail.live.currentPrice! > 100)
                                            ? 2
                                            : 4)
                                : listItem?.entry ?? '—',
                            style: GoogleFonts.poppins(
                              fontSize: 30.sp,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(width: 10.w),
                          if (detail.live.change24h != null)
                            Padding(
                              padding: EdgeInsets.only(bottom: 6.h),
                              child: Row(
                                children: [
                                  Icon(
                                    (detail.live.change24h! >= 0)
                                        ? Icons.trending_up
                                        : Icons.trending_down,
                                    size: 15.sp,
                                    color: detail.live.change24h! >= 0
                                        ? const Color(0xFF2ECC71)
                                        : const Color(0xFFE0405C),
                                  ),
                                  SizedBox(width: 3.w),
                                  Text(
                                    detail.live.change24hLabel ?? '',
                                    style: GoogleFonts.poppins(
                                      fontSize: 13.sp,
                                      fontWeight: FontWeight.w600,
                                      color: detail.live.change24h! >= 0
                                          ? const Color(0xFF2ECC71)
                                          : const Color(0xFFE0405C),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                        ],
                      ),
                    ] else ...[
                      // Fallback from list item
                      Text(
                        listItem?.entry ?? '—',
                        style: GoogleFonts.poppins(
                          fontSize: 30.sp,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ],

                    SizedBox(height: 18.h),

                    // ── Timeframe chips ─────────────────────────────
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: controller.timeframes.map((tf) {
                        return Obx(() {
                          final isSelected =
                              controller.selectedTimeframe.value == tf;
                          return GestureDetector(
                            onTap: () =>
                                controller.selectTimeframe(tf),
                            child: Container(
                              width: 44.w,
                              height: 36.h,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? const Color(0xFF7B1FE0)
                                    : const Color(0xFF1E1B2E),
                                borderRadius:
                                    BorderRadius.circular(22.r),
                              ),
                              child: Text(
                                tf,
                                style: GoogleFonts.poppins(
                                  fontSize: 11.sp,
                                  fontWeight: FontWeight.w600,
                                  color: isSelected
                                      ? Colors.white
                                      : Colors.white54,
                                ),
                              ),
                            ),
                          );
                        });
                      }).toList(),
                    ),

                    SizedBox(height: 16.h),

                    // ── Chart ───────────────────────────────────────
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(
                          horizontal: 8.w, vertical: 16.h),
                      decoration: BoxDecoration(
                        color: const Color(0xFF13102A),
                        borderRadius: BorderRadius.circular(16.r),
                        border: Border.all(
                            color: Colors.white.withValues(alpha: 0.06)),
                      ),
                      child: Obx(() {
                        final chart = controller.chartData.value;
                        final loading = controller.isChartLoading.value;
                        return SignalCandleChart(
                          chartData: chart,
                          signal: listItem,
                          isLoading: loading,
                          height: 300,
                        );
                      }),
                    ),

                    SizedBox(height: 18.h),

                    // ── Tab switcher ────────────────────────────────
                    Obx(() => Container(
                          padding: EdgeInsets.all(4.w),
                          decoration: BoxDecoration(
                            color: const Color(0xFF1B1830),
                            borderRadius: BorderRadius.circular(14.r),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: _TabButton(
                                  label: 'Summary',
                                  isSelected:
                                      controller.selectedTabIndex.value ==
                                          0,
                                  onTap: () =>
                                      controller.selectDetailTab(0),
                                ),
                              ),
                              Expanded(
                                child: _TabButton(
                                  label: 'Details',
                                  isSelected:
                                      controller.selectedTabIndex.value ==
                                          1,
                                  onTap: () =>
                                      controller.selectDetailTab(1),
                                ),
                              ),
                            ],
                          ),
                        )),

                    SizedBox(height: 18.h),

                    // ── Tab content ─────────────────────────────────
                    Obx(() {
                      // Read every observable this builder depends on up
                      // front — Obx throws if a build path returns without
                      // touching one (e.g. the loading branch below).
                      final tabIndex = controller.selectedTabIndex.value;
                      final error = controller.detailError.value;

                      if (isLoading && detail == null) {
                        return const Center(
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical: 40),
                            child: CircularProgressIndicator(
                                color: Color(0xFF7B1FE0), strokeWidth: 2),
                          ),
                        );
                      }
                      if (error.isNotEmpty && detail == null) {
                        return Center(
                          child: Padding(
                            padding:
                                EdgeInsets.symmetric(vertical: 30.h),
                            child: Text(
                              error,
                              style: GoogleFonts.poppins(
                                  fontSize: 13.sp, color: Colors.white54),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        );
                      }
                      if (detail == null) return const SizedBox.shrink();

                      return tabIndex == 0
                          ? _SummaryTab(
                              detail: detail, controller: controller)
                          : _DetailsTab(
                              detail: detail,
                              listItem: listItem,
                              controller: controller);
                    }),
                  ],
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}

// ────────────────────────────────────────────────────────────────────────────
// Tab button
// ────────────────────────────────────────────────────────────────────────────

class _TabButton extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _TabButton(
      {required this.label, required this.isSelected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        height: 44.h,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0xFF2E2650)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(10.r),
        ),
        child: Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 13.sp,
            fontWeight: FontWeight.w600,
            color: isSelected ? Colors.white : Colors.white38,
          ),
        ),
      ),
    );
  }
}

// ────────────────────────────────────────────────────────────────────────────
// Summary Tab
// ────────────────────────────────────────────────────────────────────────────

class _SummaryTab extends StatelessWidget {
  final SignalDetailModel detail;
  final SignalController controller;

  const _SummaryTab({required this.detail, required this.controller});

  @override
  Widget build(BuildContext context) {
    final stats = detail.summary.statistics;
    final proTip = detail.summary.proTip;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Statistics',
          style: GoogleFonts.poppins(
            fontSize: 14.sp,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
        SizedBox(height: 12.h),
        _StatRow(
          label: 'Previous Close',
          value: stats.previousClose != null
              ? stats.previousClose!.toStringAsFixed(2)
              : '—',
        ),
        Divider(color: Colors.white.withValues(alpha: 0.08), height: 26.h),
        _StatRow(
          label: 'Opening Price',
          value: stats.openingPrice != null
              ? stats.openingPrice!.toStringAsFixed(2)
              : '—',
        ),
        Divider(color: Colors.white.withValues(alpha: 0.08), height: 26.h),
        _StatRow(
          label: '24H Returns',
          value: stats.returns24hLabel ?? '—',
          valueColor: (stats.returns24h ?? 0) >= 0
              ? const Color(0xFF2ECC71)
              : const Color(0xFFE0405C),
        ),
        SizedBox(height: 22.h),

        // Pro Tip
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(14.w),
          decoration: BoxDecoration(
            color: const Color(0xFF7B1FE0).withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(14.r),
            border: Border.all(
                color:
                    const Color(0xFF7B1FE0).withValues(alpha: 0.25)),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.lightbulb_outline,
                  size: 18.sp, color: const Color(0xFFCDA1FF)),
              SizedBox(width: 10.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      proTip.title,
                      style: GoogleFonts.poppins(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFFCDA1FF),
                        height: 1.5,
                      ),
                    ),
                    Text(
                      proTip.message,
                      style: GoogleFonts.poppins(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w400,
                        color: Colors.white70,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        SizedBox(height: 22.h),

        _EnableAlertsButton(
          controller: controller,
          signalId: detail.header.id,
        ),
      ],
    );
  }
}

// ────────────────────────────────────────────────────────────────────────────
// Details Tab
// ────────────────────────────────────────────────────────────────────────────

class _DetailsTab extends StatelessWidget {
  final SignalDetailModel detail;
  final SignalModel? listItem;
  final SignalController controller;

  const _DetailsTab(
      {required this.detail,
      required this.listItem,
      required this.controller});

  @override
  Widget build(BuildContext context) {
    final overview = detail.details.overview;
    final levels = detail.details.levels;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'SIGNAL OVERVIEW',
          style: GoogleFonts.poppins(
            fontSize: 10.sp,
            fontWeight: FontWeight.w600,
            color: Colors.white38,
            letterSpacing: 1.2,
          ),
        ),
        SizedBox(height: 8.h),

        // Overview card
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: const Color(0xFF1B1830),
            borderRadius: BorderRadius.circular(16.r),
          ),
          padding: EdgeInsets.all(16.w),
          child: Column(
            children: [
              Row(children: [
                Expanded(
                    child: _OverviewItem(
                        label: 'ASSET', value: overview.asset)),
                Expanded(
                    child: _OverviewItem(
                        label: 'MARKET',
                        value: overview.marketCategory)),
              ]),
              SizedBox(height: 16.h),
              Row(children: [
                Expanded(
                    child: _OverviewItem(
                        label: 'SIGNAL TYPE',
                        value: overview.tradeType)),
                Expanded(
                  child: _OverviewItem(
                    label: 'DIRECTION',
                    value: overview.direction,
                    valueColor: overview.direction == 'BUY'
                        ? const Color(0xFF2ECC71)
                        : const Color(0xFFE0405C),
                  ),
                ),
              ]),
              SizedBox(height: 16.h),
              Row(children: [
                Expanded(
                    child: _OverviewItem(
                        label: 'RISK:REWARD',
                        value: overview.riskRewardRatio ?? '—')),
                Expanded(
                  child: _OverviewItem(
                    label: 'PUBLISHED',
                    value: overview.publishedLabel.isNotEmpty
                        ? overview.publishedLabel
                        : overview.timeAgo,
                  ),
                ),
              ]),
            ],
          ),
        ),

        SizedBox(height: 20.h),

        Text(
          'ENTRY & EXIT LEVELS',
          style: GoogleFonts.poppins(
            fontSize: 10.sp,
            fontWeight: FontWeight.w600,
            color: Colors.white38,
            letterSpacing: 1.2,
          ),
        ),
        SizedBox(height: 8.h),

        // Levels card
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: const Color(0xFF1B1830),
            borderRadius: BorderRadius.circular(16.r),
          ),
          padding:
              EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
          child: Column(
            children: [
              _LevelRow(
                icon: Icons.flag_outlined,
                iconColor: const Color(0xFF9B6BFF),
                label: 'ENTRY PRICE',
                priceLabel: levels.entry.priceLabel,
                tag: 'TRADE',
                tagColor: const Color(0xFF9B6BFF),
              ),
              Divider(
                  color: Colors.white.withValues(alpha: 0.08),
                  thickness: 0.5),
              _LevelRow(
                icon: Icons.warning_amber_rounded,
                iconColor: const Color(0xFFE0405C),
                label: 'STOP LOSS',
                priceLabel: levels.stopLoss.priceLabel,
                percentLabel: levels.stopLoss.percentLabel,
                tag: 'SL',
                tagColor: const Color(0xFFE0405C),
              ),
              ...levels.takeProfits.map((tp) => Column(
                    children: [
                      Divider(
                          color: Colors.white.withValues(alpha: 0.08),
                          thickness: 0.5),
                      _LevelRow(
                        icon: tp.isHit
                            ? Icons.check_circle_outline
                            : Icons.radio_button_unchecked,
                        iconColor: const Color(0xFF2ECC71),
                        label: tp.label,
                        priceLabel: tp.priceLabel,
                        percentLabel: tp.percentLabel,
                        tag: tp.isHit ? '✓ HIT' : 'TP',
                        tagColor: const Color(0xFF2ECC71),
                      ),
                    ],
                  )),
            ],
          ),
        ),

        if (detail.details.notes.isNotEmpty) ...[
          SizedBox(height: 20.h),
          Text(
            'NOTES',
            style: GoogleFonts.poppins(
              fontSize: 10.sp,
              fontWeight: FontWeight.w600,
              color: Colors.white38,
              letterSpacing: 1.2,
            ),
          ),
          SizedBox(height: 8.h),
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(14.w),
            decoration: BoxDecoration(
              color: const Color(0xFF1B1830),
              borderRadius: BorderRadius.circular(14.r),
            ),
            child: Text(
              detail.details.notes,
              style: GoogleFonts.poppins(
                fontSize: 12.sp,
                color: Colors.white70,
                height: 1.5,
              ),
            ),
          ),
        ],

        SizedBox(height: 22.h),

        _EnableAlertsButton(
          controller: controller,
          signalId: detail.header.id,
        ),
      ],
    );
  }
}

// ────────────────────────────────────────────────────────────────────────────
// Shared widgets
// ────────────────────────────────────────────────────────────────────────────

class _LoadingRow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40.h,
      width: 120.w,
      decoration: BoxDecoration(
        color: const Color(0xFF1B1830),
        borderRadius: BorderRadius.circular(8.r),
      ),
    );
  }
}

class _EnableAlertsButton extends StatelessWidget {
  final SignalController controller;
  final String signalId;

  const _EnableAlertsButton(
      {required this.controller, required this.signalId});

  @override
  Widget build(BuildContext context) {
    return Obx(() => GestureDetector(
          onTap: controller.onEnableAlertsPressed,
          child: Container(
            width: double.infinity,
            height: 54.h,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: controller.alertsEnabled.value
                    ? [const Color(0xFF1A6B3A), const Color(0xFF0F3A1A)]
                    : [
                        const Color(0xFF9B2BFF),
                        const Color(0xFF6A1BFF)
                      ],
              ),
              borderRadius: BorderRadius.circular(16.r),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF8A2BE2).withValues(alpha: 0.35),
                  blurRadius: 16,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  controller.alertsEnabled.value
                      ? Icons.notifications_off_outlined
                      : Icons.notifications_active_outlined,
                  size: 16.sp,
                  color: Colors.white,
                ),
                SizedBox(width: 8.w),
                Text(
                  controller.alertsEnabled.value
                      ? 'Disable Alerts'
                      : 'Enable Alerts',
                  style: GoogleFonts.poppins(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}

class _StatRow extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;

  const _StatRow(
      {required this.label, required this.value, this.valueColor});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label,
            style: GoogleFonts.poppins(
                fontSize: 13.sp,
                fontWeight: FontWeight.w400,
                color: Colors.white54)),
        Text(value,
            style: GoogleFonts.poppins(
                fontSize: 14.sp,
                fontWeight: FontWeight.w700,
                color: valueColor ?? Colors.white)),
      ],
    );
  }
}

class _OverviewItem extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;

  const _OverviewItem(
      {required this.label, required this.value, this.valueColor});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: GoogleFonts.poppins(
                fontSize: 9.sp,
                fontWeight: FontWeight.w500,
                color: Colors.white38,
                letterSpacing: 0.8)),
        SizedBox(height: 4.h),
        Text(value,
            style: GoogleFonts.poppins(
                fontSize: 13.sp,
                fontWeight: FontWeight.w700,
                color: valueColor ?? Colors.white)),
      ],
    );
  }
}

class _LevelRow extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String label;
  final String priceLabel;
  final String? percentLabel;
  final String tag;
  final Color tagColor;

  const _LevelRow({
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.priceLabel,
    required this.tag,
    required this.tagColor,
    this.percentLabel,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(8.w),
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 15.sp, color: iconColor),
          ),
          SizedBox(width: 12.w),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label,
                  style: GoogleFonts.poppins(
                      fontSize: 9.sp,
                      fontWeight: FontWeight.w400,
                      color: Colors.white54)),
              Text(priceLabel,
                  style: GoogleFonts.poppins(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w700,
                      color: iconColor)),
            ],
          ),
          const Spacer(),
          if (percentLabel != null) ...[
            Text(
              percentLabel!,
              style: GoogleFonts.poppins(
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w600,
                  color: percentLabel!.startsWith('+')
                      ? const Color(0xFF2ECC71)
                      : const Color(0xFFE0405C)),
            ),
            SizedBox(width: 8.w),
          ],
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
            decoration: BoxDecoration(
              color: tagColor.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Text(tag,
                style: GoogleFonts.poppins(
                    fontSize: 9.sp,
                    fontWeight: FontWeight.w700,
                    color: tagColor)),
          ),
        ],
      ),
    );
  }
}
