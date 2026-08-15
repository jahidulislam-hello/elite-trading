import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../data/model/signal_model.dart';

class SignalCandleChart extends StatelessWidget {
  final SignalModel signal;
  final double height;

  const SignalCandleChart({
    super.key,
    required this.signal,
    this.height = 300,
  });

  static const Color _successColor = Color(0xFF22C55E);
  static const Color _activeColor = Color(0xFF7C3AED);
  static const Color _errorColor = Color(0xFFEF4444);

  // Left padding reserved for price labels
  static const double _labelWidth = 90.0;

  static double? _parsePrice(String? value) {
    if (value == null || value == '—' || value.isEmpty) return null;
    final cleaned = value.replaceAll(',', '');
    return double.tryParse(cleaned);
  }

  @override
  Widget build(BuildContext context) {
    final entryPrice = _parsePrice(signal.entry) ?? 100.0;
    final slPrice = _parsePrice(signal.sl) ?? entryPrice * 0.97;
    final tp1Price = _parsePrice(signal.tp1) ?? entryPrice * 1.03;
    final tp2Price = _parsePrice(signal.tp2);
    final tp3Price = _parsePrice(signal.tp3);

    final highestTp = [tp3Price, tp2Price, tp1Price]
        .whereType<double>()
        .fold(tp1Price, (a, b) => b > a ? b : a);

    final lowestVal = min(slPrice, entryPrice * 0.97);
    final highestVal = max(highestTp, entryPrice * 1.03);
    final range = (highestVal - lowestVal) == 0 ? 1.0 : (highestVal - lowestVal);
    final chartHeight = height.h;

    double yFor(double price) {
      final t = (price - lowestVal) / range;
      return chartHeight - (t * chartHeight);
    }

    // Simulate last close for tooltip
    final rnd = Random(signal.id.hashCode);
    const candleCount = 26;
    double lastClose = entryPrice * 0.985;
    for (int i = 0; i < candleCount; i++) {
      final open = lastClose;
      final move = (rnd.nextDouble() - 0.42) * range * 0.05;
      lastClose = (open + move).clamp(lowestVal, highestVal);
    }

    // Build level entries
    final levels = <_LevelEntry>[
      _LevelEntry(
        label: 'SL ${signal.sl}',
        price: slPrice,
        color: _errorColor,
      ),
      _LevelEntry(
        label: 'ENTRY ${signal.entry}',
        price: entryPrice,
        color: _activeColor,
      ),
      _LevelEntry(
        label: 'TP1 ${signal.tp1}',
        price: tp1Price,
        color: _successColor,
      ),
      if (tp2Price != null)
        _LevelEntry(
          label: 'TP2 ${signal.tp2}',
          price: tp2Price,
          color: _successColor,
        ),
      if (tp3Price != null)
        _LevelEntry(
          label: 'TP3 ${signal.tp3}',
          price: tp3Price,
          color: _successColor,
        ),
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        final totalWidth = constraints.maxWidth;
        final chartAreaWidth = totalWidth - _labelWidth.w;
        final realCandleWidth = chartAreaWidth / candleCount;
        final tooltipCx =
            _labelWidth.w + (candleCount * 0.62) * realCandleWidth;
        final tooltipCy = yFor(lastClose) - 28.h;

        return SizedBox(
          width: double.infinity,
          height: chartHeight,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              // Candles drawn only in the right area
              Positioned(
                left: _labelWidth.w,
                top: 0,
                width: chartAreaWidth,
                height: chartHeight,
                child: CustomPaint(
                  painter: _CandleChartPainter(
                    entryPrice: entryPrice,
                    slPrice: slPrice,
                    highestVal: highestVal,
                    lowestVal: lowestVal,
                    range: range,
                    seed: signal.id.hashCode,
                  ),
                ),
              ),

              // Level labels + dashed lines spanning full width
              ...levels.map((lvl) {
                final ly =
                    yFor(lvl.price).clamp(8.0, chartHeight - 14.h);
                return Positioned(
                  left: 0,
                  top: ly - 9.h,
                  width: totalWidth,
                  child: Row(
                    children: [
                      SizedBox(
                        width: _labelWidth.w,
                        child: Text(
                          lvl.label,
                          style: GoogleFonts.poppins(
                            color: lvl.color,
                            fontSize: 9.sp,
                            fontWeight: FontWeight.w600,
                            height: 1.2,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Expanded(
                        child: CustomPaint(
                          size: const Size(double.infinity, 1),
                          painter: _DashedLinePainter(color: lvl.color),
                        ),
                      ),
                    ],
                  ),
                );
              }),

              // Floating price tooltip
              Positioned(
                left:
                    (tooltipCx - 40.w).clamp(0.0, totalWidth - 80.w),
                top: tooltipCy.clamp(0.0, chartHeight - 24.h),
                child: Container(
                  padding: EdgeInsets.symmetric(
                      horizontal: 10.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(10.r),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x55000000),
                        blurRadius: 16,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Text(
                    lastClose.toStringAsFixed(
                        entryPrice > 100 ? 2 : 4),
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w700,
                      height: 1.2,
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

class _LevelEntry {
  final String label;
  final double price;
  final Color color;
  const _LevelEntry(
      {required this.label, required this.price, required this.color});
}

class _DashedLinePainter extends CustomPainter {
  final Color color;
  const _DashedLinePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color.withValues(alpha: 0.55)
      ..strokeWidth = 1.0;
    double x = 0;
    while (x < size.width) {
      canvas.drawLine(Offset(x, 0), Offset(x + 5, 0), paint);
      x += 9;
    }
  }

  @override
  bool shouldRepaint(covariant _DashedLinePainter old) =>
      old.color != color;
}

class _CandleChartPainter extends CustomPainter {
  final double entryPrice;
  final double slPrice;
  final double highestVal;
  final double lowestVal;
  final double range;
  final int seed;

  const _CandleChartPainter({
    required this.entryPrice,
    required this.slPrice,
    required this.highestVal,
    required this.lowestVal,
    required this.range,
    required this.seed,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final rnd = Random(seed);
    const candleCount = 26;

    double y(double price) {
      final t = (price - lowestVal) / range;
      return size.height - (t * size.height);
    }

    final candleWidth = size.width / candleCount;
    double lastClose = entryPrice * 0.985;

    for (int i = 0; i < candleCount; i++) {
      final open = lastClose;
      final move = (rnd.nextDouble() - 0.42) * range * 0.055;
      final close = (open + move).clamp(lowestVal, highestVal);
      final high = max(open, close) + rnd.nextDouble() * range * 0.018;
      final low = min(open, close) - rnd.nextDouble() * range * 0.018;
      lastClose = close;

      final isUp = close >= open;
      final color =
          isUp ? const Color(0xFF22C55E) : const Color(0xFFEF4444);
      final cx = i * candleWidth + candleWidth / 2;

      // wick
      canvas.drawLine(
        Offset(cx, y(high)),
        Offset(cx, y(low)),
        Paint()
          ..color = color
          ..strokeWidth = 1.5,
      );

      // body
      final bodyTop = y(max(open, close));
      final bodyBottom = y(min(open, close));
      final bodyRect = Rect.fromLTRB(
        cx - candleWidth * 0.30,
        bodyTop,
        cx + candleWidth * 0.30,
        bodyBottom == bodyTop ? bodyTop + 2.0 : bodyBottom,
      );
      canvas.drawRect(bodyRect, Paint()..color = color);
    }
  }

  @override
  bool shouldRepaint(covariant _CandleChartPainter old) => false;
}
