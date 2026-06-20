import 'package:fluent_ui/fluent_ui.dart';
import '../../../../app/theme/app_colors.dart';

class DashboardTopMetrics extends StatelessWidget {
  const DashboardTopMetrics({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: const [
        Expanded(
          child: _SummaryMetricCard(
            title: 'ACCOUNT BALANCE',
            value: '18,427.59',
          ),
        ),
        SizedBox(width: 12),
        Expanded(
          child: _SummaryMetricCard(
            title: 'TOTAL CLOSED PnL',
            value: '3,285.40',
            valueColor: AppColors.danger,
          ),
        ),
        SizedBox(width: 12),
        Expanded(
          child: _SummaryMetricCard(
            title: 'WIN RATE',
            value: '28.21%',
            trailing: Icon(
              FluentIcons.down,
              size: 12,
              color: AppColors.danger,
            ),
          ),
        ),
        SizedBox(width: 12),
        Expanded(child: _AvgRMetricCard()),
        SizedBox(width: 12),
        Expanded(child: _ProfitFactorCard()),
      ],
    );
  }
}

class _SummaryMetricCard extends StatelessWidget {
  final String title;
  final String value;
  final Color? valueColor;
  final Widget? trailing;

  const _SummaryMetricCard({
    required this.title,
    required this.value,
    this.valueColor,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 78,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFEEE8F8)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 10,
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w600,
            ),
          ),
          const Spacer(),
          Row(
            children: [
              Text(
                value,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: valueColor ?? AppColors.textPrimary,
                ),
              ),
              if (trailing != null) ...[
                const SizedBox(width: 4),
                trailing!,
              ],
            ],
          ),
        ],
      ),
    );
  }
}

class _AvgRMetricCard extends StatelessWidget {
  const _AvgRMetricCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 78,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFEEE8F8)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'AVG R PER TRADE',
            style: TextStyle(
              fontSize: 10,
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w600,
            ),
          ),
          const Spacer(),
          Row(
            children: [
              const Text(
                '+0.42R',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                '+2.33R',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  color: AppColors.success,
                ),
              ),
              const SizedBox(width: 8),
              const Text(
                '-1.00R',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  color: AppColors.danger,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              Expanded(
                child: Container(
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.success,
                    borderRadius: BorderRadius.circular(999),
                  ),
                ),
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Container(
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.danger,
                    borderRadius: BorderRadius.circular(999),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ProfitFactorCard extends StatelessWidget {
  const _ProfitFactorCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 78,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFEEE8F8)),
      ),
      child: Row(
        children: [
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'PROFIT FACTOR',
                  style: TextStyle(
                    fontSize: 10,
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Spacer(),
                Row(
                  children: [
                    Text(
                      '1.15',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    SizedBox(width: 4),
                    Icon(
                      FluentIcons.info,
                      size: 10,
                      color: AppColors.warning,
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          const _MiniGauge(),
        ],
      ),
    );
  }
}

class _MiniGauge extends StatelessWidget {
  const _MiniGauge();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 34,
      height: 34,
      child: CustomPaint(
        painter: _MiniGaugePainter(),
      ),
    );
  }
}

class _MiniGaugePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    const stroke = 4.0;
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - stroke) / 2;

    final basePaint = Paint()
      ..color = const Color(0xFFF2EEF8)
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke;

    final greenPaint = Paint()
      ..color = AppColors.success
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke
      ..strokeCap = StrokeCap.round;

    final redPaint = Paint()
      ..color = AppColors.danger
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, basePaint);

    final rect = Rect.fromCircle(center: center, radius: radius);

    canvas.drawArc(rect, -1.9, 2.4, false, greenPaint);
    canvas.drawArc(rect, 0.7, 1.2, false, redPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}