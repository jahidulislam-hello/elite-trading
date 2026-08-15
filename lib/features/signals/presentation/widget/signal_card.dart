import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../data/model/signal_model.dart';
import '../controller/signal_controller.dart';

class SignalCard extends StatelessWidget {
  final SignalModel signal;
  const SignalCard({super.key, required this.signal});

  @override
  Widget build(BuildContext context) {
    final isBuy = signal.isBuy;

    return GestureDetector(
      onTap: () => Get.find<SignalController>().openSignalDetail(signal),
      child: Container(
        width: double.infinity,
        margin: EdgeInsets.only(bottom: 14.h),
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: const Color(0xFF1B1830),
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(color: Colors.white.withValues(alpha: 0.06)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Header row: asset + status pill ──────────────────────────
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      signal.asset,
                      style: GoogleFonts.poppins(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      signal.categoryLabel,
                      style: GoogleFonts.poppins(
                        fontSize: 11.sp,
                        color: Colors.white54,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    // Active/Closed dot
                    Container(
                      width: 8.w,
                      height: 8.w,
                      margin: EdgeInsets.only(right: 8.w),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: signal.isActive
                            ? const Color(0xFF2ECC71)
                            : const Color(0xFFE0A11F),
                      ),
                    ),
                    // BUY / SELL pill
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                      decoration: BoxDecoration(
                        color: isBuy
                            ? const Color(0xFF2ECC71).withValues(alpha: 0.15)
                            : const Color(0xFFE0405C).withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(20.r),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            isBuy ? Icons.trending_up : Icons.trending_down,
                            size: 13.sp,
                            color: isBuy
                                ? const Color(0xFF2ECC71)
                                : const Color(0xFFE0405C),
                          ),
                          SizedBox(width: 4.w),
                          Text(
                            signal.direction,
                            style: GoogleFonts.poppins(
                              fontSize: 11.sp,
                              fontWeight: FontWeight.w700,
                              color: isBuy
                                  ? const Color(0xFF2ECC71)
                                  : const Color(0xFFE0405C),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),

            SizedBox(height: 4.h),
            Divider(color: Colors.white24, thickness: 0.5),
            SizedBox(height: 4.h),

            // ── Entry price ──────────────────────────────────────────────
            Text(
              'ENTRY PRICE',
              style: GoogleFonts.poppins(
                fontSize: 9.sp,
                fontWeight: FontWeight.w600,
                color: const Color(0xFFBFA06D),
                letterSpacing: 1,
              ),
            ),
            SizedBox(height: 4.h),
            Text(
              signal.entry,
              style: GoogleFonts.poppins(
                fontSize: 18.sp,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),

            SizedBox(height: 14.h),

            // ── SL + TP row ───────────────────────────────────────────────
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Stop Loss
                Expanded(
                  flex: 4,
                  child: Container(
                    padding: EdgeInsets.all(12.w),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFF5A6B).withValues(alpha: 0.07),
                      borderRadius: BorderRadius.circular(12.r),
                      border: Border.all(
                        color: const Color(0xFFFF5A6B).withValues(alpha: 0.27),
                        width: 0.75,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'STOP LOSS',
                          style: GoogleFonts.poppins(
                            fontSize: 9.sp,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFFE0405C),
                            letterSpacing: 1,
                          ),
                        ),
                        SizedBox(height: 7.h),
                        Text(
                          signal.sl,
                          style: GoogleFonts.poppins(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 6.h),
                        if (signal.slPercent != null)
                          Text(
                            signal.slPercent!,
                            style: GoogleFonts.poppins(
                              fontSize: 11.sp,
                              fontWeight: FontWeight.w500,
                              color: const Color(0xFFE0405C),
                            ),
                          ),
                        SizedBox(height: 10.h),
                      ],
                    ),
                  ),
                ),

                SizedBox(width: 12.w),

                // Take Profits
                Expanded(
                  flex: 5,
                  child: Container(
                    padding: EdgeInsets.all(12.w),
                    decoration: BoxDecoration(
                      color: const Color(0xFF00D084).withValues(alpha: 0.07),
                      borderRadius: BorderRadius.circular(12.r),
                      border: Border.all(
                        width: 0.75,
                        color:
                            const Color(0xFF00D084).withValues(alpha: 0.15),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'TAKE PROFIT',
                          style: GoogleFonts.poppins(
                            fontSize: 9.sp,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF2ECC71),
                            letterSpacing: 1,
                          ),
                        ),
                        SizedBox(height: 6.h),
                        // TP1 always present
                        _TpRow(
                          label: 'TP1',
                          priceLabel: signal.tp1,
                          isHit: false,
                        ),
                        if (signal.tp2 != null)
                          _TpRow(label: 'TP2', priceLabel: signal.tp2!),
                        if (signal.tp3 != null)
                          _TpRow(label: 'TP3', priceLabel: signal.tp3!),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            SizedBox(height: 12.h),

            // ── Footer: R:R + time ────────────────────────────────────────
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  signal.riskReward != null
                      ? 'Risk:Reward ${signal.riskReward}'
                      : signal.type,
                  style: GoogleFonts.poppins(
                    fontSize: 11.sp,
                    color: Colors.white54,
                  ),
                ),
                Text(
                  signal.timeAgo,
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
    );
  }
}

class _TpRow extends StatelessWidget {
  final String label;
  final String priceLabel;
  final bool isHit;

  const _TpRow({
    required this.label,
    required this.priceLabel,
    this.isHit = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 4.h),
      child: Row(
        children: [
          Icon(
            isHit
                ? Icons.check_circle_outline
                : Icons.radio_button_unchecked,
            size: 12.sp,
            color: isHit ? const Color(0xFF2ECC71) : Colors.white38,
          ),
          SizedBox(width: 3.w),
          Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: 10.sp,
              fontWeight: FontWeight.w500,
              color: Colors.white54,
            ),
          ),
          SizedBox(width: 8.w),
          Expanded(
            child: Text(
              priceLabel,
              style: GoogleFonts.poppins(
                fontSize: 10.sp,
                fontWeight: FontWeight.w600,
                color: isHit ? const Color(0xFF2ECC71) : Colors.white,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
