import 'dart:math' as math;
import 'package:fluent_ui/fluent_ui.dart';
import '../../../../app/theme/app_colors.dart';

class DisciplinePanel extends StatelessWidget {
  const DisciplinePanel({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 330,
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: const Color(0xFFEEE8F8)),
        boxShadow: [
          BoxShadow(
            color: const Color(0x12000000),
            blurRadius: 28,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text(
                'Discipline breakdown',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(width: 8),
              const Icon(
                FluentIcons.info,
                size: 14,
                color: AppColors.textSecondary,
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF4DF),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: const Text(
                  'Developing Trader',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: AppColors.warning,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const _MetricRow(
                        'Performance',
                        '26/40',
                        0.65,
                        AppColors.success,
                      ),
                      const SizedBox(height: 16),
                      const _MetricRow(
                        'Discipline',
                        '32/40',
                        0.78,
                        AppColors.primary,
                      ),
                      const SizedBox(height: 18),
                      _StatRow(
                        'Max Daily Loss Violations',
                        '1 / 2',
                        trailing: const Icon(
                          FluentIcons.chevron_down_small,
                          size: 12,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 10),
                      _StatRow(
                        'Profit Target Violations',
                        '1 / 2',
                        trailing: const Icon(
                          FluentIcons.chevron_down_small,
                          size: 12,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 10),
                      _StatRow(
                        'Not exceeding max trades',
                        '✓',
                        trailing: const Icon(
                          FluentIcons.check_mark,
                          size: 12,
                          color: AppColors.success,
                        ),
                      ),
                      const SizedBox(height: 18),
                      const _MetricRow(
                        'Consistency',
                        '6/20',
                        0.30,
                        Color(0xFFE96AA9),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                const _ScoreColumn(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MetricRow extends StatelessWidget {
  final String label;
  final String score;
  final double value;
  final Color color;

  const _MetricRow(this.label, this.score, this.value, this.color);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                label,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
            Text(
              score,
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(width: 4),
            const Icon(
              FluentIcons.chevron_down_small,
              size: 12,
              color: AppColors.textSecondary,
            ),
          ],
        ),
        const SizedBox(height: 8),
        Container(
          height: 6,
          decoration: BoxDecoration(
            color: const Color(0xFFF2EEF8),
            borderRadius: BorderRadius.circular(999),
          ),
          child: Align(
            alignment: Alignment.centerLeft,
            child: FractionallySizedBox(
              widthFactor: value,
              child: Container(
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _StatRow extends StatelessWidget {
  final String label;
  final String value;
  final Widget? trailing;

  const _StatRow(this.label, this.value, {this.trailing});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 10,
              color: AppColors.textSecondary,
            ),
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        if (trailing != null) ...[const SizedBox(width: 6), trailing!],
      ],
    );
  }
}

class _ScoreColumn extends StatelessWidget {
  const _ScoreColumn();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: const [
        _ScoreRing(score: 64),
        SizedBox(height: 12),
        SizedBox(
          width: 90,
          child: Text(
            "6 more points to get 'Consistent Trader'",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 10,
              color: AppColors.textSecondary,
              height: 1.3,
            ),
          ),
        ),
      ],
    );
  }
}

class _ScoreRing extends StatelessWidget {
  final int score;

  const _ScoreRing({required this.score});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 86,
      height: 86,
      child: CustomPaint(
        painter: _ScoreRingPainter(score / 100),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '$score',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                ),
              ),
              const Text(
                '/100',
                style: TextStyle(fontSize: 10, color: AppColors.textSecondary),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ScoreRingPainter extends CustomPainter {
  final double progress;

  _ScoreRingPainter(this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    const stroke = 8.0;
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - stroke) / 2;

    final bgPaint = Paint()
      ..color = const Color(0xFFF2EEF8)
      ..strokeWidth = stroke
      ..style = PaintingStyle.stroke;

    final fgPaint = Paint()
      ..color = AppColors.warning
      ..strokeWidth = stroke
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    canvas.drawCircle(center, radius, bgPaint);

    final rect = Rect.fromCircle(center: center, radius: radius);
    canvas.drawArc(rect, -math.pi / 2, math.pi * 2 * progress, false, fgPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
