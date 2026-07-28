import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../data/model/take_profile_model.dart';

class SignalCandleChart extends StatelessWidget {
  final SignalModel signal;
  final double height;

  const SignalCandleChart({
    super.key,
    required this.signal,
    this.height = 200,
  });

  // -------- Figma color tokens --------
  static const Color _successColor = Color(0xFF22C55E); // Semantic-Success (TP)
  static const Color _activeColor = Color(0xFF7C3AED); // Signal-Active (Entry)
  static const Color _errorColor = Color(0xFFEF4444); // Semantic-Error (SL)

  @override
  Widget build(BuildContext context) {
    // -------- Compute the same price → y mapping the painter uses --------
    final highestTp = signal.takeProfits.isNotEmpty
        ? signal.takeProfits.map((t) => t.price).reduce(max)
        : signal.entryPrice * 1.05;
    final lowestVal = min(signal.stopLoss, signal.entryPrice * 0.97);
    final highestVal = max(highestTp, signal.entryPrice * 1.03);
    final range = (highestVal - lowestVal) == 0 ? 1.0 : (highestVal - lowestVal);

    final chartHeight = height.h;

    double yFor(double price) {
      final t = (price - lowestVal) / range;
      return chartHeight - (t * chartHeight);
    }

    // -------- Deterministic last-candle close (mirrors painter logic) for tooltip placement --------
    final rnd = Random(signal.id.hashCode);
    const candleCount = 26;
    double lastClose = signal.entryPrice * 0.985;
    for (int i = 0; i < candleCount; i++) {
      final open = lastClose;
      final move = (rnd.nextDouble() - 0.42) * range * 0.05;
      lastClose = (open + move).clamp(lowestVal, highestVal);
    }
    final candleWidth = 1.0; // fractional width placeholder, real width computed in LayoutBuilder below

    return LayoutBuilder(
      builder: (context, constraints) {
        final chartWidth = constraints.maxWidth;
        final realCandleWidth = chartWidth / candleCount;
        final tooltipCx = (candleCount * 0.62) * realCandleWidth;
        final tooltipCy = yFor(lastClose) - 26.h;

        return SizedBox(
          width: double.infinity,
          height: chartHeight,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              // -------- Candles (painted) --------
              Positioned.fill(
                child: CustomPaint(
                  painter: _CandleChartPainter(signal: signal),
                ),
              ),

              // -------- Take Profit labels --------
              ...signal.takeProfits.map((tp) {
                final ly = yFor(tp.price);
                return Positioned(
                  left: -1.5.w,
                  top: (ly - 10.h).clamp(0.0, chartHeight - 12.h),
                  child: SizedBox(
                    width: 60.w,
                    child: Text(
                      '${tp.label} \$${tp.price.toStringAsFixed(0)}',
                      style: GoogleFonts.poppins(
                        color: _successColor,
                        fontSize: 9.sp,
                        fontWeight: FontWeight.w600,
                        height: 1.20,
                      ),
                    ),
                  ),
                );
              }),

              // -------- Entry label --------
              Positioned(
                left: -2.w,
                top: (yFor(signal.entryPrice) - 10.h).clamp(0.0, chartHeight - 12.h),
                child: SizedBox(
                  width: 70.w,
                  child: Text(
                    'ENTRY \$${signal.entryPrice.toStringAsFixed(0)}',
                    style: GoogleFonts.poppins(
                      color: _activeColor,
                      fontSize: 9.sp,
                      fontWeight: FontWeight.w600,
                      height: 1.20,
                    ),
                  ),
                ),
              ),

              // -------- Stop Loss label --------
              Positioned(
                left: -2.w,
                top: (yFor(signal.stopLoss) - 10.h).clamp(0.0, chartHeight - 12.h),
                child: SizedBox(
                  width: 60.w,
                  child: Text(
                    'SL \$${signal.stopLoss.toStringAsFixed(0)}',
                    style: GoogleFonts.poppins(
                      color: _errorColor,
                      fontSize: 9.sp,
                      fontWeight: FontWeight.w600,
                      height: 1.20,
                    ),
                  ),
                ),
              ),

              // -------- Floating price tooltip --------
              Positioned(
                left: tooltipCx - 34.w,
                top: tooltipCy,
                child: Container(
                  width: 68.w,
                  height: 20.h,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(10.r),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x66212222),
                        blurRadius: 24,
                        offset: Offset(0, 8),
                        spreadRadius: 0,
                      ),
                    ],
                  ),
                  child: Text(
                    '\$${lastClose.toStringAsFixed(2)}',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w600,
                      height: 1.20,
                      letterSpacing: 0.10,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _CandleChartPainter extends CustomPainter {
  final SignalModel signal;
  _CandleChartPainter({required this.signal});

  @override
  void paint(Canvas canvas, Size size) {
    final rnd = Random(signal.id.hashCode);
    const candleCount = 26;

    final highestTp = signal.takeProfits.isNotEmpty
        ? signal.takeProfits.map((t) => t.price).reduce(max)
        : signal.entryPrice * 1.05;
    final lowestVal = min(signal.stopLoss, signal.entryPrice * 0.97);
    final highestVal = max(highestTp, signal.entryPrice * 1.03);
    final range = (highestVal - lowestVal) == 0 ? 1.0 : (highestVal - lowestVal);

    double y(double price) {
      final t = (price - lowestVal) / range;
      return size.height - (t * size.height);
    }

    // -------- Dashed level lines only (labels are drawn as widgets above) --------
    final levels = <(double price, Color color)>[
      (signal.stopLoss, const Color(0xFFEF4444)),
      (signal.entryPrice, const Color(0xFF7C3AED)),
      for (final tp in signal.takeProfits) (tp.price, const Color(0xFF22C55E)),
    ];

    for (final level in levels) {
      final ly = y(level.$1);
      final dashPaint = Paint()
        ..color = level.$2.withValues(alpha: 0.5)
        ..strokeWidth = 1;
      double dashX = 0;
      while (dashX < size.width) {
        canvas.drawLine(Offset(dashX, ly), Offset(dashX + 4, ly), dashPaint);
        dashX += 8;
      }
    }

    // -------- Candles --------
    final candleWidth = size.width / candleCount;
    double lastClose = signal.entryPrice * 0.985;

    for (int i = 0; i < candleCount; i++) {
      final open = lastClose;
      final move = (rnd.nextDouble() - 0.42) * range * 0.05;
      final close = (open + move).clamp(lowestVal, highestVal);
      final high = max(open, close) + rnd.nextDouble() * range * 0.015;
      final low = min(open, close) - rnd.nextDouble() * range * 0.015;
      lastClose = close;

      final isUp = close >= open;
      final color = isUp ? const Color(0xFF22C55E) : const Color(0xFFEF4444);
      final cx = i * candleWidth + candleWidth / 2;

      // wick
      canvas.drawLine(
        Offset(cx, y(high)),
        Offset(cx, y(low)),
        Paint()
          ..color = color
          ..strokeWidth = 1.2,
      );

      // body
      final bodyTop = y(max(open, close));
      final bodyBottom = y(min(open, close));
      final bodyRect = Rect.fromLTRB(
        cx - candleWidth * 0.28,
        bodyTop,
        cx + candleWidth * 0.28,
        bodyBottom == bodyTop ? bodyTop + 1.5 : bodyBottom,
      );
      canvas.drawRect(bodyRect, Paint()..color = color);
    }
  }

  @override
  bool shouldRepaint(covariant _CandleChartPainter oldDelegate) => false;
}