import 'package:fluent_ui/fluent_ui.dart';

import '../../../../app/theme/app_colors.dart';
import '../data/news_sample_data.dart';

class NewsCalendarPanel extends StatelessWidget {
  final List<CalendarDayData> days;

  const NewsCalendarPanel({super.key, required this.days});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _panelDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _CalendarHeader(),
          const SizedBox(height: 14),
          const _WeekdayHeader(),
          const SizedBox(height: 8),
          LayoutBuilder(
            builder: (context, constraints) {
              final compact = constraints.maxWidth < 760;

              return GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: days.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 7,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                  childAspectRatio: compact ? 0.98 : 1.28,
                ),
                itemBuilder: (context, index) => _CalendarDayTile(days[index]),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _CalendarHeader extends StatelessWidget {
  const _CalendarHeader();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const _NavButton(FluentIcons.chevron_left),
        const SizedBox(width: 6),
        const _NavButton(FluentIcons.chevron_right),
        const SizedBox(width: 12),
        const Text(
          'January 2026',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w800,
            color: AppColors.textPrimary,
          ),
        ),
        const Spacer(),
        _LegendDot(AppColors.danger, 'High'),
        const SizedBox(width: 10),
        _LegendDot(AppColors.warning, 'Med'),
        const SizedBox(width: 10),
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
      children: const [
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
        style: const TextStyle(
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

  const _CalendarDayTile(this.day);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(9),
      decoration: BoxDecoration(
        color: day.isMuted ? const Color(0xFFF9F7FC) : Colors.white,
        borderRadius: BorderRadius.circular(9),
        border: Border.all(
          color: day.isToday ? AppColors.primary : const Color(0xFFEDE7F8),
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
                    ? const Color(0xFFB7B0C4)
                    : AppColors.textPrimary,
              ),
            ),
          ),
          if (day.isToday)
            Align(
              alignment: Alignment.topLeft,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(999),
                ),
                child: const Text(
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
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.primarySoft,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppColors.primary),
                ),
                child: const Text(
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
      padding: const EdgeInsets.only(top: 3),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 5),
          Text(
            '$count',
            style: const TextStyle(
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
        const SizedBox(width: 5),
        Text(
          label,
          style: const TextStyle(
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
    color: Colors.white.withValues(alpha: 0.96),
    borderRadius: BorderRadius.circular(12),
    border: Border.all(color: AppColors.border),
    boxShadow: [
      BoxShadow(
        color: AppColors.primary.withValues(alpha: 0.04),
        blurRadius: 18,
        offset: const Offset(0, 10),
      ),
    ],
  );
}
