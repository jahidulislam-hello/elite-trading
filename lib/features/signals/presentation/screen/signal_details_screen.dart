import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../data/model/take_profile_model.dart';
import '../controller/signal_controller.dart';
import '../widget/signal_candle_chart.dart';

class SignalDetailScreen extends GetView<SignalController> {
  const SignalDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final signal = controller.currentSignal.value;

      if (signal == null) {
        return const Scaffold(
          backgroundColor: Color(0xFF0F0B1E),
          body: Center(child: CircularProgressIndicator(color: Colors.white54)),
        );
      }

      final isBuy = signal.type == SignalType.buy;

      return Scaffold(
        backgroundColor: const Color(0xFF0F0B1E),
        body: Stack(
          children: [
            // Background
            Positioned.fill(
              child: Image.asset(
                "asset/image/onboarding/background.png",
                fit: BoxFit.cover,
              ),
            ),

            // Content
            SafeArea(
              child: SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 30.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ── Header ──
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
                              signal.pair.replaceAll('/', ' / '),
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
                          child: Icon(
                            controller.isFavorite.value
                                ? Icons.star
                                : Icons.star_border,
                            color: const Color(0xFFE0A11F),
                            size: 22.sp,
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 18.h),

                    // ── Signal type + status pills ──
                    Row(
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 12.w, vertical: 6.h),
                          decoration: BoxDecoration(
                            color: const Color(0xFF7B1FE0).withValues(alpha: 0.18),
                            borderRadius: BorderRadius.circular(20.r),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: 6.w,
                                height: 6.w,
                                decoration: const BoxDecoration(
                                  color: Color(0xFF9B6BFF),
                                  shape: BoxShape.circle,
                                ),
                              ),
                              SizedBox(width: 6.w),
                              Text(
                                isBuy ? 'Buy Signal' : 'Sell Signal',
                                style: GoogleFonts.poppins(
                                  fontSize: 11.sp,
                                  fontWeight: FontWeight.w600,
                                  color: const Color(0xFFCDA1FF),
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
                                signal.isLive
                                    ? Icons.check_circle_outline
                                    : Icons.watch_later_outlined,
                                size: 12.sp,
                                color: Colors.white54,
                              ),
                              SizedBox(width: 5.w),
                              Text(
                                signal.isLive ? 'Active' : 'Closed',
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

                    // ── Price + change ──
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          '\$${signal.entryPrice.toStringAsFixed(2)}',
                          style: GoogleFonts.poppins(
                            fontSize: 30.sp,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(width: 10.w),
                        Padding(
                          padding: EdgeInsets.only(bottom: 6.h),
                          child: Row(
                            children: [
                              Icon(
                                (signal.change24hPercent ?? 0) >= 0
                                    ? Icons.trending_up
                                    : Icons.trending_down,
                                size: 15.sp,
                                color: (signal.change24hPercent ?? 0) >= 0
                                    ? const Color(0xFF2ECC71)
                                    : const Color(0xFFE0405C),
                              ),
                              SizedBox(width: 3.w),
                              Text(
                                '${(signal.change24hPercent ?? 0) >= 0 ? '+' : ''}${(signal.change24hPercent ?? 0).toStringAsFixed(2)}%',
                                style: GoogleFonts.poppins(
                                  fontSize: 13.sp,
                                  fontWeight: FontWeight.w600,
                                  color: (signal.change24hPercent ?? 0) >= 0
                                      ? const Color(0xFF2ECC71)
                                      : const Color(0xFFE0405C),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 18.h),

                    // ── Timeframe chips ──
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: controller.timeframes.map((tf) {
                        return Obx(() {
                          final isSelected =
                              controller.selectedTimeframe.value == tf;
                          return GestureDetector(
                            onTap: () => controller.selectTimeframe(tf),
                            child: Container(
                              width: 44.w,
                              height: 36.h,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? const Color(0xFF7B1FE0)
                                    : const Color(0xFF1E1B2E),
                                borderRadius: BorderRadius.circular(22.r),
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

                    // ── Chart ──
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
                      child: SignalCandleChart(signal: signal, height: 300),
                    ),

                    SizedBox(height: 18.h),

                    // ── Tab switcher under chart ──
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
                                      controller.selectedTabIndex.value == 0,
                                  onTap: () => controller.selectDetailTab(0),
                                ),
                              ),
                              Expanded(
                                child: _TabButton(
                                  label: 'Details',
                                  isSelected:
                                      controller.selectedTabIndex.value == 1,
                                  onTap: () => controller.selectDetailTab(1),
                                ),
                              ),
                            ],
                          ),
                        )),

                    SizedBox(height: 18.h),

                    // ── Tab content ──
                    Obx(() => controller.selectedTabIndex.value == 0
                        ? _SummaryTab(signal: signal, controller: controller)
                        : _DetailsTab(signal: signal, controller: controller)),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}

// ====================================================================
// Tab Button
// ====================================================================
class _TabButton extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _TabButton({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        height: 44.h,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF2E2650) : Colors.transparent,
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

// ====================================================================
// SUMMARY TAB
// ====================================================================
class _SummaryTab extends StatelessWidget {
  final SignalModel signal;
  final SignalController controller;
  const _SummaryTab({required this.signal, required this.controller});

  @override
  Widget build(BuildContext context) {
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
          value:
              '\$${(signal.previousClose ?? signal.entryPrice).toStringAsFixed(2)}',
        ),
        Divider(color: Colors.white.withValues(alpha: 0.08), height: 26.h),
        _StatRow(
          label: 'Opening Price',
          value:
              '\$${(signal.openingPrice ?? signal.entryPrice).toStringAsFixed(2)}',
        ),
        Divider(color: Colors.white.withValues(alpha: 0.08), height: 26.h),
        _StatRow(
          label: '24H Returns %',
          value:
              '${(signal.change24hPercent ?? 0) >= 0 ? '+' : ''}${(signal.change24hPercent ?? 0).toStringAsFixed(2)}%',
          valueColor: (signal.change24hPercent ?? 0) >= 0
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
                color: const Color(0xFF7B1FE0).withValues(alpha: 0.25)),
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
                      'Pro Tip',
                      style: GoogleFonts.poppins(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFFCDA1FF),
                        height: 1.5,
                      ),
                    ),
                    Text(
                      'Move Stop Loss to Break Even (BE) after TP1 is hit to secure profits.',
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

        // Enable Alerts
        _EnableAlertsButton(onTap: controller.onEnableAlertsPressed),
      ],
    );
  }
}

class _StatRow extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;
  const _StatRow({required this.label, required this.value, this.valueColor});

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

// ====================================================================
// DETAILS TAB
// ====================================================================
class _DetailsTab extends StatelessWidget {
  final SignalModel signal;
  final SignalController controller;
  const _DetailsTab({required this.signal, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section header
        Text('SIGNAL OVERVIEW',
            style: GoogleFonts.poppins(
                fontSize: 10.sp,
                fontWeight: FontWeight.w600,
                color: Colors.white38,
                letterSpacing: 1.2)),
        SizedBox(height: 8.h),

        // Signal Overview card
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
                    child: _OverviewItem(label: 'ASSET', value: signal.pair)),
                Expanded(
                    child: _OverviewItem(
                        label: 'MARKET', value: signal.subtitleLabel)),
              ]),
              SizedBox(height: 16.h),
              Row(children: [
                Expanded(
                    child: _OverviewItem(
                        label: 'SIGNAL TYPE', value: signal.tradeType)),
                Expanded(
                  child: _OverviewItem(
                    label: 'DIRECTION',
                    value: signal.type == SignalType.buy ? 'BUY' : 'SELL',
                    valueColor: signal.type == SignalType.buy
                        ? const Color(0xFF2ECC71)
                        : const Color(0xFFE0405C),
                  ),
                ),
              ]),
              SizedBox(height: 16.h),
              Row(children: [
                Expanded(
                    child: _OverviewItem(
                        label: 'RISK:REWARD', value: signal.riskReward)),
                Expanded(
                  child: _OverviewItem(
                    label: 'PUBLISHED',
                    value: signal.publishedDate.isEmpty
                        ? signal.timeAgo
                        : signal.publishedDate,
                  ),
                ),
              ]),
            ],
          ),
        ),

        SizedBox(height: 20.h),

        // Section header
        Text('ENTRY & EXIT LEVELS',
            style: GoogleFonts.poppins(
                fontSize: 10.sp,
                fontWeight: FontWeight.w600,
                color: Colors.white38,
                letterSpacing: 1.2)),
        SizedBox(height: 8.h),

        // Levels card
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: const Color(0xFF1B1830),
            borderRadius: BorderRadius.circular(16.r),
          ),
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
          child: Column(
            children: [
              _LevelRow(
                icon: Icons.flag_outlined,
                iconColor: const Color(0xFF9B6BFF),
                label: 'ENTRY PRICE',
                price: signal.entryPrice,
                tag: 'TRADE',
                tagColor: const Color(0xFF9B6BFF),
              ),
              Divider(
                  color: Colors.white.withValues(alpha: 0.08), thickness: 0.5),
              _LevelRow(
                icon: Icons.warning_amber_rounded,
                iconColor: const Color(0xFFE0405C),
                label: 'STOP LOSS',
                price: signal.stopLoss,
                percent: signal.stopLossPercent,
                tag: 'SL',
                tagColor: const Color(0xFFE0405C),
              ),
              ...signal.takeProfits.map((tp) {
                final percent =
                    ((tp.price - signal.entryPrice) / signal.entryPrice) * 100;
                return Column(children: [
                  Divider(
                      color: Colors.white.withValues(alpha: 0.08),
                      thickness: 0.5),
                  _LevelRow(
                    icon: tp.isHit
                        ? Icons.check_circle_outline
                        : Icons.radio_button_unchecked,
                    iconColor: const Color(0xFF2ECC71),
                    label: tp.label.toUpperCase(),
                    price: tp.price,
                    percent: percent,
                    tag: tp.isHit ? '✓ HIT' : 'TP',
                    tagColor: const Color(0xFF2ECC71),
                  ),
                ]);
              }),
            ],
          ),
        ),

        SizedBox(height: 22.h),

        // Enable Alerts
        _EnableAlertsButton(onTap: controller.onEnableAlertsPressed),
      ],
    );
  }
}

// ====================================================================
// Shared widgets
// ====================================================================

class _EnableAlertsButton extends StatelessWidget {
  final VoidCallback onTap;
  const _EnableAlertsButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: 54.h,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF9B2BFF), Color(0xFF6A1BFF)],
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
            Icon(Icons.notifications_active_outlined,
                size: 16.sp, color: Colors.white),
            SizedBox(width: 8.w),
            Text(
              'Enable Alerts',
              style: GoogleFonts.poppins(
                fontSize: 14.sp,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _OverviewItem extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;
  const _OverviewItem({required this.label, required this.value, this.valueColor});

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
  final double price;
  final double? percent;
  final String tag;
  final Color tagColor;

  const _LevelRow({
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.price,
    required this.tag,
    required this.tagColor,
    this.percent,
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
              Text('\$${price.toStringAsFixed(2)}',
                  style: GoogleFonts.poppins(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w700,
                      color: iconColor)),
            ],
          ),
          const Spacer(),
          if (percent != null) ...[
            Text(
              '${percent! >= 0 ? '+' : ''}${percent!.toStringAsFixed(2)}%',
              style: GoogleFonts.poppins(
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w600,
                  color: percent! >= 0
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
