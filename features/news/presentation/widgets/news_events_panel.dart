import 'package:fluent_ui/fluent_ui.dart';

import '../../../../app/theme/app_colors.dart';
import '../data/news_sample_data.dart';

class NewsEventsPanel extends StatelessWidget {
  final List<NewsEventData> events;

  const NewsEventsPanel({super.key, required this.events});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: _panelDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _NavButton(FluentIcons.chevron_left),
              SizedBox(width: 6),
              _NavButton(FluentIcons.chevron_right),
              SizedBox(width: 12),
              Text(
                'Wed, Jan 8 · Today',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                ),
              ),
              Spacer(),
              _TodayPill(),
            ],
          ),
          SizedBox(height: 14),
          _EventHeader(),
          SizedBox(height: 8),
          ...events.map((event) => _EventRow(event)),
        ],
      ),
    );
  }
}

class UpcomingEventsPanel extends StatelessWidget {
  final List<NewsEventData> events;

  const UpcomingEventsPanel({super.key, required this.events});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: _panelDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Upcoming',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimary,
            ),
          ),
          SizedBox(height: 14),
          _EventHeader(compact: true),
          SizedBox(height: 8),
          ...events.map((event) => _EventRow(event, compact: true)),
        ],
      ),
    );
  }
}

class CurrencyWatchlistPanel extends StatelessWidget {
  final List<String> currencies;

  const CurrencyWatchlistPanel({super.key, required this.currencies});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: _panelDecoration(),
      child: Row(
        children: [
          Text(
            'Currencies',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimary,
            ),
          ),
          SizedBox(width: 12),
          Text(
            '18 from watchlist',
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 12,
              fontWeight: FontWeight.w700,
            ),
          ),
          Spacer(),
          Text(
            'Clear',
            style: TextStyle(color: AppColors.textSecondary, fontSize: 12),
          ),
          SizedBox(width: 16),
          ...currencies.map((currency) => _CurrencyChip(currency)),
        ],
      ),
    );
  }
}

class _EventHeader extends StatelessWidget {
  final bool compact;

  const _EventHeader({this.compact = false});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(width: 78, child: _HeaderText('Time')),
        SizedBox(width: 76, child: _HeaderText('Currency')),
        SizedBox(width: 62, child: _HeaderText('Impact')),
        Expanded(flex: compact ? 4 : 5, child: _HeaderText('Event')),
        if (!compact) ...[
          SizedBox(width: 78, child: _HeaderText('Actual')),
          SizedBox(width: 78, child: _HeaderText('Forecast')),
          SizedBox(width: 78, child: _HeaderText('Previous')),
        ],
      ],
    );
  }
}

class _EventRow extends StatelessWidget {
  final NewsEventData event;
  final bool compact;

  const _EventRow(this.event, {this.compact = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 9),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColors.border)),
      ),
      child: Row(
        children: [
          SizedBox(width: 78, child: _CellText(event.time)),
          SizedBox(width: 76, child: _CellText(event.currency, strong: true)),
          SizedBox(
            width: 62,
            child: Align(
              alignment: Alignment.centerLeft,
              child: Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: event.impactColor,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ),
          Expanded(
            flex: compact ? 4 : 5,
            child: _CellText(event.event, strong: true),
          ),
          if (!compact) ...[
            SizedBox(
              width: 78,
              child: _CellText(
                event.actual,
                strong: true,
                color: event.actual.startsWith('-')
                    ? AppColors.danger
                    : AppColors.success,
              ),
            ),
            SizedBox(width: 78, child: _CellText(event.forecast)),
            SizedBox(width: 78, child: _CellText(event.previous)),
          ],
        ],
      ),
    );
  }
}

class _CurrencyChip extends StatelessWidget {
  final String currency;

  const _CurrencyChip(this.currency);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 10),
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 9),
      decoration: BoxDecoration(
        color: currency == 'USD' ? AppColors.primarySoft : AppColors.surface,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: currency == 'USD' ? AppColors.primary : AppColors.border,
        ),
      ),
      child: Row(
        children: [
          Text(
            currency,
            style: TextStyle(
              fontWeight: FontWeight.w800,
              color: currency == 'USD'
                  ? AppColors.primary
                  : AppColors.textPrimary,
            ),
          ),
          SizedBox(width: 8),
          Icon(FluentIcons.cancel, size: 10, color: AppColors.textSecondary),
        ],
      ),
    );
  }
}

class _HeaderText extends StatelessWidget {
  final String text;

  const _HeaderText(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        color: AppColors.textSecondary,
        fontSize: 10,
        fontWeight: FontWeight.w800,
      ),
    );
  }
}

class _CellText extends StatelessWidget {
  final String text;
  final bool strong;
  final Color? color;

  const _CellText(this.text, {this.strong = false, this.color});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(
        fontSize: 11,
        fontWeight: strong ? FontWeight.w800 : FontWeight.w600,
        color: color ?? AppColors.textPrimary,
      ),
    );
  }
}

class _TodayPill extends StatelessWidget {
  const _TodayPill();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.shellBg,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.border),
      ),
      child: Text(
        'Today',
        style: TextStyle(
          color: AppColors.textSecondary,
          fontSize: 10,
          fontWeight: FontWeight.w800,
        ),
      ),
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
