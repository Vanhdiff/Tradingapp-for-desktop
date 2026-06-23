import 'package:fluent_ui/fluent_ui.dart';

import '../../../../app/theme/app_colors.dart';
import '../data/news_sample_data.dart';

class NewsCalendarPanel extends StatelessWidget {
  final List<CalendarDayData> days;
  final DateTime visibleMonth;
  final ValueChanged<CalendarDayData>? onDaySelected;

  const NewsCalendarPanel({
    super.key,
    required this.days,
    required this.visibleMonth,
    this.onDaySelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: _panelDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _CalendarHeader(visibleMonth: visibleMonth),
          SizedBox(height: 14),
          _WeekdayHeader(),
          SizedBox(height: 8),
          LayoutBuilder(
            builder: (context, constraints) {
              final compact = constraints.maxWidth < 760;

              return GridView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: days.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 7,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                  childAspectRatio: compact ? 0.98 : 1.28,
                ),
                itemBuilder: (context, index) => _CalendarDayTile(
                  days[index],
                  onPressed: onDaySelected == null
                      ? null
                      : () => onDaySelected!(days[index]),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _CalendarHeader extends StatelessWidget {
  final DateTime visibleMonth;

  const _CalendarHeader({required this.visibleMonth});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _NavButton(FluentIcons.chevron_left),
        SizedBox(width: 6),
        _NavButton(FluentIcons.chevron_right),
        SizedBox(width: 12),
        Text(
          _monthTitle(visibleMonth),
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w800,
            color: AppColors.textPrimary,
          ),
        ),
        Spacer(),
        _LegendDot(AppColors.danger, 'High'),
        SizedBox(width: 10),
        _LegendDot(AppColors.warning, 'Med'),
        SizedBox(width: 10),
        _LegendDot(AppColors.textSecondary, 'Low'),
      ],
    );
  }
}

class _WeekdayHeader extends StatelessWidget {
  const _WeekdayHeader();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _Weekday('Mon'),
        _Weekday('Tue'),
        _Weekday('Wed'),
        _Weekday('Thu'),
        _Weekday('Fri'),
        _Weekday('Sat'),
        _Weekday('Sun'),
      ],
    );
  }
}

class _Weekday extends StatelessWidget {
  final String label;

  const _Weekday(this.label);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Text(
        label,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: AppColors.textSecondary,
        ),
      ),
    );
  }
}

class _CalendarDayTile extends StatelessWidget {
  final CalendarDayData day;
  final VoidCallback? onPressed;

  const _CalendarDayTile(this.day, {this.onPressed});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: EdgeInsets.all(9),
        decoration: BoxDecoration(
          color: day.isMuted ? AppColors.surfaceAlt : AppColors.surface,
          borderRadius: BorderRadius.circular(9),
          border: Border.all(
            color: day.isToday ? AppColors.primary : AppColors.border,
            width: day.isToday ? 1.4 : 1,
          ),
        ),
        child: Stack(
          children: [
            Align(
              alignment: Alignment.topRight,
              child: Text(
                '${day.day}',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: day.isMuted
                      ? Color(0xFFB7B0C4)
                      : AppColors.textPrimary,
                ),
              ),
            ),
            if (day.isToday)
              Align(
                alignment: Alignment.topLeft,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    'Today',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 9,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ),
            if (day.isBlocked)
              Center(
                child: Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.primarySoft,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppColors.primary),
                  ),
                  child: Text(
                    'Trading locked around\nhigh-impact news.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: AppColors.primary,
                      fontSize: 9,
                      fontWeight: FontWeight.w700,
                      height: 1.25,
                    ),
                  ),
                ),
              )
            else
              Align(alignment: Alignment.bottomLeft, child: _ImpactCounts(day)),
          ],
        ),
      ),
    );
  }
}

class _ImpactCounts extends StatelessWidget {
  final CalendarDayData day;

  const _ImpactCounts(this.day);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (day.highImpact > 0) _ImpactCount(AppColors.danger, day.highImpact),
        if (day.mediumImpact > 0)
          _ImpactCount(AppColors.warning, day.mediumImpact),
        if (day.lowImpact > 0)
          _ImpactCount(AppColors.textSecondary, day.lowImpact),
      ],
    );
  }
}

class _ImpactCount extends StatelessWidget {
  final Color color;
  final int count;

  const _ImpactCount(this.color, this.count);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 3),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          SizedBox(width: 5),
          Text(
            '$count',
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w700,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

class _LegendDot extends StatelessWidget {
  final Color color;
  final String label;

  const _LegendDot(this.color, this.label);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 7,
          height: 7,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        SizedBox(width: 5),
        Text(
          label,
          style: TextStyle(
            fontSize: 10,
            color: AppColors.textSecondary,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}

class _NavButton extends StatelessWidget {
  final IconData icon;

  const _NavButton(this.icon);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 26,
      height: 26,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: AppColors.shellBg,
        borderRadius: BorderRadius.circular(7),
        border: Border.all(color: AppColors.border),
      ),
      child: Icon(icon, size: 12, color: AppColors.textSecondary),
    );
  }
}

BoxDecoration _panelDecoration() {
  return BoxDecoration(
    color: AppColors.surface.withValues(alpha: 0.96),
    borderRadius: BorderRadius.circular(12),
    border: Border.all(color: AppColors.border),
    boxShadow: [
      BoxShadow(
        color: AppColors.primary.withValues(alpha: 0.04),
        blurRadius: 18,
        offset: Offset(0, 10),
      ),
    ],
  );
}

String _monthTitle(DateTime value) {
  const months = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December',
  ];
  return '${months[value.month - 1]} ${value.year}';
}
