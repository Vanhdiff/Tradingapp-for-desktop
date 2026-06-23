import 'package:fluent_ui/fluent_ui.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../shared/widgets/app_panel.dart';
import 'journal_shared_widgets.dart';

class JournalChartsPanel extends StatelessWidget {
  const JournalChartsPanel({super.key});

  @override
  Widget build(BuildContext context) {
    return AppPanel(
      padding: EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Charts',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
          ),
          SizedBox(height: 4),
          Text(
            'Add screenshots to review context + execution.',
            style: TextStyle(color: AppColors.textSecondary, fontSize: 12),
          ),
          SizedBox(height: 14),
          Row(
            children: [
              Expanded(child: _ChartCard('MTF', '+2')),
              SizedBox(width: 14),
              Expanded(child: _ChartCard('HTF', '+1', withActions: true)),
              SizedBox(width: 14),
              Expanded(child: _UploadChartCard('LTF')),
            ],
          ),
        ],
      ),
    );
  }
}

class _ChartCard extends StatelessWidget {
  final String label;
  final String count;
  final bool withActions;

  const _ChartCard(this.label, this.count, {this.withActions = false});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        JournalSectionLabel(label),
        Container(
          height: 190,
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            color: Color(0xFF081018),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppColors.border),
          ),
          child: Stack(
            children: [
              Positioned.fill(
                child: CustomPaint(painter: _ChartPreviewPainter()),
              ),
              if (withActions)
                Center(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: AppColors.isDark
                          ? AppColors.surfaceAlt.withValues(alpha: 0.78)
                          : Colors.black.withValues(alpha: 0.45),
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Text(
                      '+ Add file',
                      style: TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ),
                ),
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 7),
                  color: AppColors.isDark
                      ? AppColors.surfaceAlt.withValues(alpha: 0.78)
                      : Colors.black.withValues(alpha: 0.44),
                  alignment: Alignment.center,
                  child: Text(
                    count,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _UploadChartCard extends StatelessWidget {
  final String label;

  const _UploadChartCard(this.label);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        JournalSectionLabel(label),
        Container(
          height: 190,
          decoration: BoxDecoration(
            color: AppColors.shellBg,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: AppColors.primary.withValues(alpha: 0.35),
            ),
          ),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(FluentIcons.upload, color: AppColors.primary, size: 24),
                SizedBox(height: 8),
                Text(
                  'Upload chart',
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _ChartPreviewPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final gridPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.08)
      ..strokeWidth = 1;
    for (var i = 1; i < 5; i++) {
      final y = size.height * i / 5;
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }

    final redZone = Paint()..color = AppColors.danger.withValues(alpha: 0.22);
    final greenZone = Paint()
      ..color = AppColors.success.withValues(alpha: 0.18);
    canvas.drawRect(
      Rect.fromLTWH(
        size.width * 0.58,
        size.height * 0.36,
        size.width * 0.38,
        18,
      ),
      redZone,
    );
    canvas.drawRect(
      Rect.fromLTWH(
        size.width * 0.52,
        size.height * 0.54,
        size.width * 0.42,
        20,
      ),
      greenZone,
    );

    final linePaint = Paint()
      ..color = Color(0xFF62B7FF)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;
    final path = Path()
      ..moveTo(0, size.height * 0.62)
      ..lineTo(size.width * 0.16, size.height * 0.58)
      ..lineTo(size.width * 0.30, size.height * 0.68)
      ..lineTo(size.width * 0.44, size.height * 0.50)
      ..lineTo(size.width * 0.57, size.height * 0.55)
      ..lineTo(size.width * 0.72, size.height * 0.42)
      ..lineTo(size.width, size.height * 0.46);
    canvas.drawPath(path, linePaint);

    final candlePaint = Paint()..strokeWidth = 2;
    for (var i = 0; i < 12; i++) {
      final x = 12 + i * (size.width - 24) / 12;
      final top = size.height * (0.35 + (i % 4) * 0.05);
      final bottom = size.height * (0.55 + (i % 3) * 0.05);
      candlePaint.color = i.isEven ? AppColors.success : AppColors.danger;
      canvas.drawLine(Offset(x, top), Offset(x, bottom), candlePaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
