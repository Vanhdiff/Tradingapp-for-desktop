import 'package:fluent_ui/fluent_ui.dart';
import '../../../../app/theme/app_colors.dart';
import '../models/dashboard_mt5_snapshot.dart';

class DashboardTopMetrics extends StatelessWidget {
  final DashboardMt5Snapshot snapshot;

  const DashboardTopMetrics({super.key, required this.snapshot});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _SummaryMetricCard(
            title: 'ACCOUNT BALANCE',
            value: dashboardMoney(snapshot.accountBalance),
          ),
        ),
        SizedBox(width: 12),
        Expanded(
          child: _SummaryMetricCard(
            title: 'TOTAL CLOSED PnL',
            value: dashboardMoney(snapshot.totalClosedPnl),
            valueColor: snapshot.totalClosedPnl < 0
                ? AppColors.danger
                : AppColors.success,
          ),
        ),
        SizedBox(width: 12),
        Expanded(
          child: _SummaryMetricCard(
            title: 'WIN RATE',
            value: '${snapshot.winRate.toStringAsFixed(2)}%',
            trailing: Icon(
              snapshot.winRate >= 50 ? FluentIcons.up : FluentIcons.down,
              size: 12,
              color: snapshot.winRate >= 50
                  ? AppColors.success
                  : AppColors.danger,
            ),
          ),
        ),
        SizedBox(width: 12),
        Expanded(child: _AvgRMetricCard(snapshot: snapshot)),
        SizedBox(width: 12),
        Expanded(child: _ProfitFactorCard(snapshot: snapshot)),
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
      padding: EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: Color(0x11000000),
            blurRadius: 22,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
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
                value,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: valueColor ?? AppColors.textPrimary,
                ),
              ),
              if (trailing != null) ...[SizedBox(width: 4), trailing!],
            ],
          ),
        ],
      ),
    );
  }
}

class _AvgRMetricCard extends StatelessWidget {
  final DashboardMt5Snapshot snapshot;

  const _AvgRMetricCard({required this.snapshot});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 78,
      padding: EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: Color(0x11000000),
            blurRadius: 22,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'AVG R PER TRADE',
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
                _r(snapshot.avgRPerTrade),
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              SizedBox(width: 12),
              Text(
                _r(snapshot.bestR),
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  color: AppColors.success,
                ),
              ),
              SizedBox(width: 8),
              Text(
                _r(snapshot.worstR),
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  color: AppColors.danger,
                ),
              ),
            ],
          ),
          SizedBox(height: 6),
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
              SizedBox(width: 6),
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
  final DashboardMt5Snapshot snapshot;

  const _ProfitFactorCard({required this.snapshot});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 78,
      padding: EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: Color(0x11000000),
            blurRadius: 22,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
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
                      snapshot.profitFactor.toStringAsFixed(2),
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    SizedBox(width: 4),
                    Icon(FluentIcons.info, size: 10, color: AppColors.warning),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(width: 10),
          _MiniGauge(),
        ],
      ),
    );
  }
}

String _r(double value) {
  return '${value > 0 ? '+' : ''}${value.toStringAsFixed(2)}R';
}

class _MiniGauge extends StatelessWidget {
  const _MiniGauge();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 34,
      height: 34,
      child: CustomPaint(painter: _MiniGaugePainter()),
    );
  }
}

class _MiniGaugePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final stroke = 4.0;
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - stroke) / 2;

    final basePaint = Paint()
      ..color = AppColors.border
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
