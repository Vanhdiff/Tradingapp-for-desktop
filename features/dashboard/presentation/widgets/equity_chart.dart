import 'package:fluent_ui/fluent_ui.dart';
import '../../../../app/theme/app_colors.dart';
import '../../domain/entities/chart_metric_mode.dart';
import '../../domain/entities/dashboard_query.dart';
import 'chart_filter_bar.dart';

class EquityChart extends StatefulWidget {
  const EquityChart({super.key});

  @override
  State<EquityChart> createState() => _EquityChartState();
}

class _EquityChartState extends State<EquityChart> {
  DashboardQuery query = DashboardQuery.initial();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 250,
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFEEE8F8)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text(
                'Account Balance',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              const Spacer(),
              ChartFilterBar(
                selectedRange: query.range,
                selectedMode: query.mode,
                onRangeChanged: (range) {
                  setState(() {
                    query = query.copyWith(range: range);
                  });
                },
                onModeChanged: (mode) {
                  setState(() {
                    query = query.copyWith(mode: mode);
                  });
                },
              ),
            ],
          ),
          const SizedBox(height: 10),
          Expanded(
            child: CustomPaint(
              painter: _CompactChartPainter(mode: query.mode),
              child: Container(),
            ),
          ),
        ],
      ),
    );
  }
}

class _CompactChartPainter extends CustomPainter {
  final ChartMetricMode mode;

  _CompactChartPainter({required this.mode});

  @override
  void paint(Canvas canvas, Size size) {
    final leftPad = 36.0;
    final bottomPad = 18.0;
    final chartWidth = size.width - leftPad;
    final chartHeight = size.height - bottomPad;

    final gridPaint = Paint()
      ..color = const Color(0xFFF0ECF6)
      ..strokeWidth = 1;

    final axisPaint = Paint()
      ..color = const Color(0xFFE6E0F0)
      ..strokeWidth = 1;

    const textStyle = TextStyle(
      color: Color(0xFFB0A8BE),
      fontSize: 8,
      fontWeight: FontWeight.w500,
    );

    for (int i = 0; i < 4; i++) {
      final y = chartHeight * i / 3;
      canvas.drawLine(Offset(leftPad, y), Offset(size.width, y), gridPaint);
    }

    canvas.drawLine(
      Offset(leftPad, 0),
      Offset(leftPad, chartHeight),
      axisPaint,
    );
    canvas.drawLine(
      Offset(leftPad, chartHeight),
      Offset(size.width, chartHeight),
      axisPaint,
    );

    final yLabels = _buildYLabels();
    for (int i = 0; i < yLabels.length; i++) {
      final y = chartHeight * i / 3;
      final tp = TextPainter(
        text: TextSpan(text: yLabels[i], style: textStyle),
        textDirection: TextDirection.ltr,
      )..layout();
      tp.paint(canvas, Offset(0, y - 5));
    }

    final xLabels = ['Dec 1', 'Dec 5', 'Dec 10', 'Dec 15', 'Dec 20', 'Dec 25'];
    for (int i = 0; i < xLabels.length; i++) {
      final x = leftPad + chartWidth * i / (xLabels.length - 1);
      final tp = TextPainter(
        text: TextSpan(text: xLabels[i], style: textStyle),
        textDirection: TextDirection.ltr,
      )..layout();
      tp.paint(canvas, Offset(x - tp.width / 2, chartHeight + 4));
    }

    final path = Path()
      ..moveTo(leftPad, chartHeight * 0.88)
      ..cubicTo(
        leftPad + chartWidth * 0.08,
        chartHeight * 0.38,
        leftPad + chartWidth * 0.16,
        chartHeight * 0.86,
        leftPad + chartWidth * 0.28,
        chartHeight * 0.34,
      )
      ..cubicTo(
        leftPad + chartWidth * 0.40,
        chartHeight * 0.12,
        leftPad + chartWidth * 0.50,
        chartHeight * 0.72,
        leftPad + chartWidth * 0.64,
        chartHeight * 0.26,
      )
      ..cubicTo(
        leftPad + chartWidth * 0.74,
        chartHeight * 0.05,
        leftPad + chartWidth * 0.84,
        chartHeight * 0.52,
        leftPad + chartWidth * 0.92,
        chartHeight * 0.16,
      )
      ..cubicTo(
        leftPad + chartWidth * 0.96,
        chartHeight * 0.02,
        leftPad + chartWidth,
        chartHeight * 0.20,
        leftPad + chartWidth,
        chartHeight * 0.30,
      );

    final fillPath = Path.from(path)
      ..lineTo(leftPad + chartWidth, chartHeight)
      ..lineTo(leftPad, chartHeight)
      ..close();

    final fillPaint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Color(0x3333C981), Color(0x11F5A14B), Color(0x00FFFFFF)],
      ).createShader(Rect.fromLTWH(leftPad, 0, chartWidth, chartHeight));

    canvas.drawPath(fillPath, fillPaint);

    final linePaint = Paint()
      ..shader = const LinearGradient(
        colors: [Color(0xFFFF8D3D), Color(0xFF2FC97C)],
      ).createShader(Rect.fromLTWH(leftPad, 0, chartWidth, chartHeight))
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.1;

    canvas.drawPath(path, linePaint);
  }

  List<String> _buildYLabels() {
    switch (mode) {
      case ChartMetricMode.currency:
        return [r'$20K', r'$15K', r'$10K', r'$5K'];
      case ChartMetricMode.rMultiple:
        return ['4R', '3R', '2R', '1R'];
      case ChartMetricMode.percent:
        return ['20%', '15%', '10%', '5%'];
    }
  }

  @override
  bool shouldRepaint(covariant _CompactChartPainter oldDelegate) {
    return oldDelegate.mode != mode;
  }
}
