import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../data/model/take_profile_model.dart';

class SignalCard extends StatelessWidget {
  final SignalModel signal;
  const SignalCard({super.key, required this.signal});

  @override
  Widget build(BuildContext context) {
    final isBuy = signal.type == SignalType.buy;

    return Container(
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    signal.pair,
                    style: GoogleFonts.poppins(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    signal.subtitleLabel,
                    style: GoogleFonts.poppins(
                      fontSize: 11.sp,
                      color: Colors.white54,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Container(
                    width: 8.w,
                    height: 8.w,
                    margin: EdgeInsets.only(right: 8.w),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: signal.isLive
                          ? const Color(0xFF2ECC71)
                          : const Color(0xFFE0A11F),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
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
                          color: isBuy ? const Color(0xFF2ECC71) : const Color(0xFFE0405C),
                        ),
                        SizedBox(width: 4.w),
                        Text(
                          isBuy ? 'BUY' : 'SELL',
                          style: GoogleFonts.poppins(
                            fontSize: 11.sp,
                            fontWeight: FontWeight.w700,
                            color: isBuy ? const Color(0xFF2ECC71) : const Color(0xFFE0405C),
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
          Divider(color: Colors.white24,thickness: 0.5,),
          SizedBox(height: 4.h),
          Text(
            'ENTRY PRICE',
            style: GoogleFonts.poppins(
              fontSize: 9.sp,
              fontWeight: FontWeight.w600,
              color: Color(0xFFBFA06D),
              letterSpacing: 1,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            '\$${signal.entryPrice.toStringAsFixed(2)}',
            style: GoogleFonts.poppins(
              fontSize: 18.sp,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 14.h),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 4,
                child: Container(
                  padding: EdgeInsets.all(12.w),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFF5A6B).withValues(alpha: 0.07),
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all( color: const Color(0xFFFF5A6B).withValues(alpha: 0.27),width: 0.75)
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
                        '\$${signal.stopLoss.toStringAsFixed(2)}',
                        style: GoogleFonts.poppins(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 6.h),
                      Text(
                        '${signal.stopLossPercent.toStringAsFixed(2)}%',
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
              Expanded(
                flex: 5,
                child: Container(
                  padding: EdgeInsets.all(12.w),
                  decoration: BoxDecoration(
                    color: const Color(0xFF00D084).withValues(alpha: 0.07),
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(
                      width: 0.75,
                      color: const Color(0xFF00D084).withValues(alpha: 0.07),
                    )
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
                      ...signal.takeProfits.map(
                            (tp) => Padding(
                          padding: EdgeInsets.only(bottom: 4.h),
                          child: Row(
                            children: [
                              Icon(
                                tp.isHit
                                    ? Icons.check_circle_outline
                                    : Icons.radio_button_unchecked,
                                size: 12.sp,
                                color: tp.isHit
                                    ? const Color(0xFF2ECC71)
                                    : Colors.white38,
                              ),
                              SizedBox(width: 3.w),
                              Text(
                                tp.label,
                                style: GoogleFonts.poppins(
                                  fontSize: 10.sp,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white54,
                                ),
                              ),
                              SizedBox(width:36.w),
                              Text(
                                '\$${tp.price.toStringAsFixed(2)}',
                                style: GoogleFonts.poppins(
                                  fontSize: 10.sp,
                                  fontWeight: FontWeight.w600,
                                  color: tp.isHit
                                      ? const Color(0xFF2ECC71)
                                      : Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Risk:Reward ${signal.riskReward}',
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
    );
  }
}