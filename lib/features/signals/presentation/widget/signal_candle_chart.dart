import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../data/model/signal_model.dart';

/// Candlestick chart driven by
/// `GET /api/v1/signal/app/:id/chart?timeframe=...`
///
/// - Real OHLC candles from the API
/// - Overlay levels (entry / SL / TPs) as dashed guides
/// - Floating current-price pill on the last candle
class SignalCandleChart extends StatelessWidget {
  final SignalChartData? chartData;
  final SignalModel? signal;
  final bool isLoading;
  final double height;

  const SignalCandleChart({
    super.key,
    this.chartData,
    this.signal,
    this.isLoading = false,
    this.height = 300,
  });

  static const Color _successColor = Color(0xFF22C55E);
  static const Color _entryColor = Color(0xFF7B61FF);
  static const Color _errorColor = Color(0xFFEF4444);
  static const double _labelWidth = 92.0;

  String _fmt(double? price, {String? fallback}) {
    if (price == null) return fallback ?? '—';
    if (price.abs() >= 100) return price.toStringAsFixed(2);
    if (price.abs() >= 1) return price.toStringAsFixed(4);
    return price.toStringAsFixed(5);
  }

  @override
  Widget build(BuildContext context) {
    final chartHeight = height.h;

    if (isLoading && (chartData == null || chartData!.candles.isEmpty)) {
      return SizedBox(
        height: chartHeight,
        child: const Center(
          child: CircularProgressIndicator(
            color: Color(0xFF7B1FE0),
            strokeWidth: 2,
          ),
        ),
      );
    }

    final candles = chartData?.candles ?? const <CandleModel>[];
    if (candles.isEmpty) {
      return SizedBox(
        height: chartHeight,
        child: Center(
          child: Text(
            'No chart data',
            style: GoogleFonts.poppins(
              fontSize: 12.sp,
              color: Colors.white38,
            ),
          ),
        ),
      );
    }

    final overlays = chartData?.overlays ?? const ChartOverlays();
    final entryPrice = overlays.entry ??
        double.tryParse(signal?.entry.replaceAll(',', '') ?? '') ??
        candles.last.close;
    final slPrice = overlays.stopLoss ??
        double.tryParse(signal?.sl.replaceAll(',', '') ?? '');
    final takeProfits = overlays.takeProfits.isNotEmpty
        ? overlays.takeProfits
        : <double>[
            if (double.tryParse(signal?.tp1.replaceAll(',', '') ?? '') !=
                null)
              double.parse(signal!.tp1.replaceAll(',', '')),
            if (signal?.tp2 != null &&
                double.tryParse(signal!.tp2!.replaceAll(',', '')) != null)
              double.parse(signal!.tp2!.replaceAll(',', '')),
            if (signal?.tp3 != null &&
                double.tryParse(signal!.tp3!.replaceAll(',', '')) != null)
              double.parse(signal!.tp3!.replaceAll(',', '')),
          ];

    final candleLows = candles.map((c) => c.low);
    final candleHighs = candles.map((c) => c.high);
    final allLevels = <double>[
      ...candleLows,
      ...candleHighs,
      entryPrice,
      if (slPrice != null) slPrice,
      ...takeProfits,
    ];
    final rawLow = allLevels.reduce(min);
    final rawHigh = allLevels.reduce(max);
    final pad = (rawHigh - rawLow) == 0
        ? (rawHigh.abs() * 0.02).clamp(0.01, double.infinity)
        : (rawHigh - rawLow) * 0.12;
    final lowestVal = rawLow - pad;
    final highestVal = rawHigh + pad;
    final range =
        (highestVal - lowestVal) == 0 ? 1.0 : (highestVal - lowestVal);

    double yFor(double price) {
      final t = (price - lowestVal) / range;
      return chartHeight - (t * chartHeight);
    }

    // Display order: TP (highest index first for labels), ENTRY, SL
    final levels = <_LevelEntry>[
      for (int i = takeProfits.length - 1; i >= 0; i--)
        _LevelEntry(
          label: 'TP${i + 1} ${_fmt(takeProfits[i], fallback: signal?.tp1)}',
          price: takeProfits[i],
          color: _successColor,
        ),
      _LevelEntry(
        label: 'ENTRY ${_fmt(entryPrice, fallback: signal?.entry)}',
        price: entryPrice,
        color: _entryColor,
      ),
      if (slPrice != null)
        _LevelEntry(
          label: 'SL ${_fmt(slPrice, fallback: signal?.sl)}',
          price: slPrice,
          color: _errorColor,
        ),
    ];

    // Sort by price descending so labels don't overlap incorrectly in stack
    levels.sort((a, b) => b.price.compareTo(a.price));

    final lastCandle = candles.last;
    final tooltipPrice = lastCandle.close;

    return LayoutBuilder(
      builder: (context, constraints) {
        final totalWidth = constraints.maxWidth.isFinite
            ? constraints.maxWidth
            : MediaQuery.of(context).size.width - 32.w;
        final chartAreaWidth = totalWidth - _labelWidth.w;
        final candleWidth = chartAreaWidth / candles.length;

        final tooltipCx =
            _labelWidth.w + (candles.length - 0.5) * candleWidth;
        final tooltipCy = yFor(tooltipPrice) - 28.h;

        return SizedBox(
          width: double.infinity,
          height: chartHeight,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              // Dim overlay while refreshing timeframe
              if (isLoading)
                Positioned.fill(
                  child: Container(
                    color: Colors.black.withValues(alpha: 0.15),
                    alignment: Alignment.center,
                    child: const SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(
                        color: Color(0xFF7B1FE0),
                        strokeWidth: 2,
                      ),
                    ),
                  ),
                ),

              Positioned(
                left: _labelWidth.w,
                top: 0,
                width: chartAreaWidth,
                height: chartHeight,
                child: CustomPaint(
                  painter: _CandleChartPainter(
                    candles: candles,
                    highestVal: highestVal,
                    lowestVal: lowestVal,
                    range: range,
                  ),
                ),
              ),

              ...levels.map((lvl) {
                final ly = yFor(lvl.price).clamp(8.h, chartHeight - 8.h);
                return Positioned(
                  left: 0,
                  top: ly - 8.h,
                  width: totalWidth,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: _labelWidth.w,
                        child: Text(
                          lvl.label,
                          style: GoogleFonts.poppins(
                            color: lvl.color,
                            fontSize: 10.sp,
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

              Positioned(
                left: (tooltipCx - 42.w)
                    .clamp(_labelWidth.w, totalWidth - 84.w),
                top: tooltipCy.clamp(0.0, chartHeight - 24.h),
                child: Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 12.w, vertical: 5.h),
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(10.r),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x66000000),
                        blurRadius: 14,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Text(
                    _fmt(tooltipPrice),
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
  const _LevelEntry({
    required this.label,
    required this.price,
    required this.color,
  });
}

class _DashedLinePainter extends CustomPainter {
  final Color color;
  const _DashedLinePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color.withValues(alpha: 0.45)
      ..strokeWidth = 1.0;
    double x = 0;
    const dash = 4.0;
    const gap = 4.0;
    while (x < size.width) {
      canvas.drawLine(Offset(x, 0), Offset(x + dash, 0), paint);
      x += dash + gap;
    }
  }

  @override
  bool shouldRepaint(covariant _DashedLinePainter old) => old.color != color;
}

class _CandleChartPainter extends CustomPainter {
  final List<CandleModel> candles;
  final double highestVal;
  final double lowestVal;
  final double range;

  const _CandleChartPainter({
    required this.candles,
    required this.highestVal,
    required this.lowestVal,
    required this.range,
  });

  static const Color _up = Color(0xFF22C55E);
  static const Color _down = Color(0xFFEF4444);

  @override
  void paint(Canvas canvas, Size size) {
    double y(double price) {
      final t = (price - lowestVal) / range;
      return size.height - (t * size.height);
    }

    final candleWidth = size.width / candles.length;

    for (int i = 0; i < candles.length; i++) {
      final c = candles[i];
      final isUp = c.close >= c.open;
      final color = isUp ? _up : _down;
      final cx = i * candleWidth + candleWidth / 2;

      canvas.drawLine(
        Offset(cx, y(c.high)),
        Offset(cx, y(c.low)),
        Paint()
          ..color = color
          ..strokeWidth = 1.4,
      );

      final bodyTop = y(max(c.open, c.close));
      final bodyBottom = y(min(c.open, c.close));
      final bodyRect = Rect.fromLTRB(
        cx - candleWidth * 0.24,
        bodyTop,
        cx + candleWidth * 0.24,
        bodyBottom == bodyTop ? bodyTop + 2.0 : bodyBottom,
      );
      canvas.drawRRect(
        RRect.fromRectAndRadius(bodyRect, const Radius.circular(1)),
        Paint()..color = color,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _CandleChartPainter old) =>
      old.candles != candles ||
      old.highestVal != highestVal ||
      old.lowestVal != lowestVal ||
      old.range != range;
}
