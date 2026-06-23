import 'package:fluent_ui/fluent_ui.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../shared/widgets/app_panel.dart';
import '../data/journal_sample_data.dart';
import '../widgets/journal_charts_panel.dart';
import '../widgets/journal_header.dart';
import '../widgets/journal_review_panel.dart';
import '../widgets/journal_trade_details_panel.dart';

class JournalPage extends StatefulWidget {
  const JournalPage({super.key});

  @override
  State<JournalPage> createState() => _JournalPageState();
}

class _JournalPageState extends State<JournalPage> {
  final TextEditingController _reflectionController = TextEditingController(
    text: JournalSampleData.initialReflection,
  );

  String _entryConfluence = JournalSampleData.confluences.first;
  String _entryPlan = JournalSampleData.plans.first;
  String _entryEmotion = JournalSampleData.emotions.first;
  String _exitEmotion = 'Disappointed';
  bool _followedPlan = true;
  bool _showTradeDetail = false;
  int? _selectedCalendarDayIndex;
  int? _selectedTradeIndex;

  @override
  void dispose() {
    _reflectionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        const horizontalPadding = 20.0;
        final contentWidth = constraints.maxWidth - horizontalPadding * 2;
        final targetWidth = contentWidth * 0.9;
        final pageWidth = targetWidth < 1120 ? 1120.0 : targetWidth;
        final scrollWidth = pageWidth > contentWidth ? pageWidth : contentWidth;

        return SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(
            horizontalPadding,
            12,
            horizontalPadding,
            18,
          ),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: SizedBox(
              width: scrollWidth,
              child: Align(
                alignment: Alignment.topCenter,
                child: SizedBox(
                  width: pageWidth,
                  child: _showTradeDetail
                      ? _buildTradeDetail()
                      : _JournalOverview(
                          selectedCalendarDayIndex: _selectedCalendarDayIndex,
                          onCalendarDaySelected: (index) {
                            setState(() => _selectedCalendarDayIndex = index);
                          },
                          selectedTradeIndex: _selectedTradeIndex,
                          onTradeClicked: (index) {
                            setState(() => _selectedTradeIndex = index);
                          },
                          onTradeSelected: () {
                            setState(() => _showTradeDetail = true);
                          },
                        ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildTradeDetail() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        JournalHeader(
          title: JournalSampleData.title,
          onBack: () => setState(() => _showTradeDetail = false),
        ),
        const SizedBox(height: 18),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 360,
              child: JournalTradeDetailsPanel(
                netPnl: JournalSampleData.netPnl,
                instrument: JournalSampleData.instrument,
                direction: JournalSampleData.direction,
                lotSize: JournalSampleData.lotSize,
              ),
            ),
            const SizedBox(width: 18),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  JournalChartsPanel(),
                  const SizedBox(height: 18),
                  JournalReviewPanel(
                    reflectionController: _reflectionController,
                    followedPlan: _followedPlan,
                    onFollowedPlanChanged: _setFollowedPlan,
                    entryPlan: _entryPlan,
                    plans: JournalSampleData.plans,
                    onEntryPlanChanged: (value) {
                      setState(() => _entryPlan = value);
                    },
                    entryConfluence: _entryConfluence,
                    confluences: JournalSampleData.confluences,
                    onEntryConfluenceChanged: (value) {
                      setState(() => _entryConfluence = value);
                    },
                    entryEmotion: _entryEmotion,
                    exitEmotion: _exitEmotion,
                    emotions: JournalSampleData.emotions,
                    onEntryEmotionChanged: (value) {
                      setState(() => _entryEmotion = value);
                    },
                    onExitEmotionChanged: (value) {
                      setState(() => _exitEmotion = value);
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  void _setFollowedPlan(bool value) {
    setState(() => _followedPlan = value);
  }
}

class _JournalOverview extends StatelessWidget {
  final int? selectedCalendarDayIndex;
  final ValueChanged<int> onCalendarDaySelected;
  final int? selectedTradeIndex;
  final ValueChanged<int> onTradeClicked;
  final VoidCallback onTradeSelected;

  const _JournalOverview({
    required this.selectedCalendarDayIndex,
    required this.onCalendarDaySelected,
    required this.selectedTradeIndex,
    required this.onTradeClicked,
    required this.onTradeSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _OverviewHeader(),
              SizedBox(height: 16),
              _JournalCalendarPanel(
                selectedDayIndex: selectedCalendarDayIndex,
                onDaySelected: onCalendarDaySelected,
              ),
              SizedBox(height: 16),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: _MonthlySummaryPanel()),
                  SizedBox(width: 16),
                  Expanded(child: _WeeklyBreakdownPanel()),
                ],
              ),
            ],
          ),
        ),
        SizedBox(width: 18),
        SizedBox(
          width: 340,
          child: _DayTradePanel(
            selectedTradeIndex: selectedTradeIndex,
            onTradeClicked: onTradeClicked,
            onTradeSelected: onTradeSelected,
          ),
        ),
      ],
    );
  }
}

class _OverviewHeader extends StatelessWidget {
  const _OverviewHeader();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          'Journal',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w800,
            color: AppColors.textPrimary,
          ),
        ),
        Spacer(),
        _ToolbarButton(icon: FluentIcons.list, label: 'List'),
        SizedBox(width: 8),
        _ToolbarButton(
          icon: FluentIcons.calendar,
          label: 'Calendar',
          selected: true,
        ),
        SizedBox(width: 8),
        _ToolbarButton(icon: FluentIcons.add, label: 'Add trade'),
        SizedBox(width: 8),
        _IconSquare(FluentIcons.refresh),
      ],
    );
  }
}

class _JournalCalendarPanel extends StatelessWidget {
  final int? selectedDayIndex;
  final ValueChanged<int> onDaySelected;

  const _JournalCalendarPanel({
    required this.selectedDayIndex,
    required this.onDaySelected,
  });

  @override
  Widget build(BuildContext context) {
    return AppPanel(
      padding: EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            children: [
              _NavButton(FluentIcons.chevron_left),
              SizedBox(width: 6),
              _NavButton(FluentIcons.chevron_right),
              SizedBox(width: 12),
              Text(
                'March 2026',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
              ),
              SizedBox(width: 10),
              Text(
                'Syncing trades from MT5',
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Spacer(),
              _LegendDot(AppColors.success, 'Profit'),
              SizedBox(width: 12),
              _LegendDot(AppColors.danger, 'Loss'),
              SizedBox(width: 12),
              _LegendDot(AppColors.warning, 'Reviewed'),
            ],
          ),
          SizedBox(height: 16),
          _WeekdayHeader(),
          SizedBox(height: 8),
          GridView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: JournalSampleData.calendarDays.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
              childAspectRatio: 1.24,
            ),
            itemBuilder: (context, index) {
              return _CalendarTradeDay(
                day: JournalSampleData.calendarDays[index],
                selected: selectedDayIndex == index,
                onPressed: () => onDaySelected(index),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _CalendarTradeDay extends StatelessWidget {
  final JournalCalendarDay day;
  final bool selected;
  final VoidCallback onPressed;

  const _CalendarTradeDay({
    required this.day,
    required this.selected,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final hasTrades = day.tradeCount > 0;
    final pnlColor = day.pnl >= 0 ? AppColors.success : AppColors.danger;

    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: EdgeInsets.all(9),
        decoration: BoxDecoration(
          color: selected
              ? AppColors.primarySoft
              : day.isMuted
              ? AppColors.surfaceAlt
              : AppColors.surface,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: selected ? AppColors.primary : AppColors.border,
            width: selected ? 1.4 : 1,
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
                  fontWeight: FontWeight.w800,
                  color: day.isMuted
                      ? AppColors.textSecondary.withValues(alpha: 0.55)
                      : AppColors.textPrimary,
                ),
              ),
            ),
            if (day.hasReview)
              Align(
                alignment: Alignment.topLeft,
                child: Icon(
                  FluentIcons.edit_note,
                  size: 13,
                  color: AppColors.warning,
                ),
              ),
            if (hasTrades)
              Align(
                alignment: Alignment.center,
                child: Container(
                  width: 104,
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(7),
                    border: Border.all(color: pnlColor.withValues(alpha: 0.42)),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _money(day.pnl),
                        style: TextStyle(
                          color: pnlColor,
                          fontSize: 12,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        '${day.tradeCount} trade${day.tradeCount == 1 ? '' : 's'}',
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _DayTradePanel extends StatelessWidget {
  final int? selectedTradeIndex;
  final ValueChanged<int> onTradeClicked;
  final VoidCallback onTradeSelected;

  const _DayTradePanel({
    required this.selectedTradeIndex,
    required this.onTradeClicked,
    required this.onTradeSelected,
  });

  @override
  Widget build(BuildContext context) {
    return AppPanel(
      padding: EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Tue, March 10',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
          ),
          SizedBox(height: 4),
          Text(
            '3 trades imported from MT5',
            style: TextStyle(color: AppColors.textSecondary, fontSize: 11),
          ),
          SizedBox(height: 18),
          Text(
            '+\$332',
            style: TextStyle(
              color: AppColors.success,
              fontSize: 34,
              fontWeight: FontWeight.w800,
            ),
          ),
          SizedBox(height: 4),
          Text(
            'NET PNL',
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 10,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: 18),
          Row(
            children: [
              Expanded(child: _DayMetric('0.9%', 'Return')),
              Expanded(child: _DayMetric('+0.32R', 'Expectancy')),
            ],
          ),
          SizedBox(height: 16),
          Row(
            children: [
              Expanded(child: _DayMetric('4', 'Trades')),
              Expanded(child: _DayMetric('1', 'Rule break')),
            ],
          ),
          SizedBox(height: 20),
          _RiskLine(label: 'Max daily loss', value: 0.38),
          SizedBox(height: 10),
          _RiskLine(label: 'Discipline score', value: 0.72),
          SizedBox(height: 18),
          _TradeTabs(),
          SizedBox(height: 12),
          ...JournalSampleData.overviewTrades.asMap().entries.map((entry) {
            return _TradeListItem(
              trade: entry.value,
              selected: selectedTradeIndex == entry.key,
              onPressed: () => onTradeClicked(entry.key),
              onDoublePressed: onTradeSelected,
            );
          }),
        ],
      ),
    );
  }
}

class _MonthlySummaryPanel extends StatelessWidget {
  const _MonthlySummaryPanel();

  @override
  Widget build(BuildContext context) {
    return AppPanel(
      height: 250,
      padding: EdgeInsets.all(16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Monthly Summary',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800),
                ),
                SizedBox(height: 18),
                Expanded(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      _Bar(height: 84, label: 'W1', color: AppColors.success),
                      SizedBox(width: 10),
                      _Bar(height: 144, label: 'W2', color: AppColors.primary),
                      SizedBox(width: 10),
                      _Bar(height: 54, label: 'W3', color: AppColors.danger),
                      SizedBox(width: 10),
                      _Bar(height: 110, label: 'W4', color: AppColors.success),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 12),
          SizedBox(
            width: 138,
            child: Column(
              children: [
                _SummaryRow('Expectancy', '+0.38R'),
                _SummaryRow('Win rate', '61%'),
                _SummaryRow('Avg win', '\$420'),
                _SummaryRow('Avg loss', '-\$180'),
                _SummaryRow('Net PnL', '+\$1,916'),
                _SummaryRow('Mistakes', '4'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _WeeklyBreakdownPanel extends StatelessWidget {
  const _WeeklyBreakdownPanel();

  @override
  Widget build(BuildContext context) {
    return AppPanel(
      height: 250,
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Weekly Breakdown',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800),
          ),
          SizedBox(height: 20),
          Row(
            children: [
              Expanded(child: _WeekColumn('Week 1', 0.62, '+\$640')),
              Expanded(child: _WeekColumn('Week 2', 0.86, '+\$1,120')),
              Expanded(child: _WeekColumn('Week 3', 0.34, '-\$310')),
              Expanded(child: _WeekColumn('Week 4', 0.58, '+\$466')),
            ],
          ),
          Spacer(),
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.surfaceAlt,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppColors.border),
            ),
            child: Row(
              children: [
                Icon(FluentIcons.lightbulb, size: 16, color: AppColors.warning),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Best trades came after London open. Reduce NY late-session entries.',
                    style: TextStyle(
                      fontSize: 11,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TradeListItem extends StatelessWidget {
  final JournalOverviewTrade trade;
  final bool selected;
  final VoidCallback onPressed;
  final VoidCallback onDoublePressed;

  const _TradeListItem({
    required this.trade,
    required this.selected,
    required this.onPressed,
    required this.onDoublePressed,
  });

  @override
  Widget build(BuildContext context) {
    final isBuy = trade.direction == 'Buy';
    final pnlColor = trade.pnl >= 0 ? AppColors.success : AppColors.danger;

    return GestureDetector(
      onTap: onPressed,
      onDoubleTap: onDoublePressed,
      child: Container(
        margin: EdgeInsets.only(bottom: 10),
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: selected ? AppColors.primarySoft : AppColors.surfaceAlt,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: selected ? AppColors.primary : AppColors.border,
            width: selected ? 1.4 : 1,
          ),
        ),
        child: Row(
          children: [
            _PairDot(),
            SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        trade.symbol,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      SizedBox(width: 8),
                      Text(
                        '${isBuy ? '↑' : '↓'} ${trade.direction}',
                        style: TextStyle(
                          color: isBuy ? AppColors.success : AppColors.danger,
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 5),
                  Text(
                    '${trade.time} · ${trade.setup} · ${trade.lots.toStringAsFixed(2)} lot',
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 10,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  _money(trade.pnl),
                  style: TextStyle(
                    color: pnlColor,
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  '${trade.rMultiple > 0 ? '+' : ''}${trade.rMultiple.toStringAsFixed(2)}R',
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _DayMetric extends StatelessWidget {
  final String value;
  final String label;

  const _DayMetric(this.value, this.label);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          value,
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800),
        ),
        SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            color: AppColors.textSecondary,
            fontSize: 10,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}

class _RiskLine extends StatelessWidget {
  final String label;
  final double value;

  const _RiskLine({required this.label, required this.value});

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
                style: TextStyle(color: AppColors.textSecondary, fontSize: 11),
              ),
            ),
            Text(
              '${(value * 100).round()}%',
              style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700),
            ),
          ],
        ),
        SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: Container(
            height: 5,
            color: AppColors.surfaceAlt,
            child: Align(
              alignment: Alignment.centerLeft,
              child: FractionallySizedBox(
                widthFactor: value.clamp(0, 1),
                child: ColoredBox(
                  color: value > 0.65 ? AppColors.success : AppColors.warning,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _TradeTabs extends StatelessWidget {
  const _TradeTabs();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _TabChip('All', selected: true),
        SizedBox(width: 8),
        _TabChip('Wins'),
        SizedBox(width: 8),
        _TabChip('Losses'),
      ],
    );
  }
}

class _TabChip extends StatelessWidget {
  final String label;
  final bool selected;

  const _TabChip(this.label, {this.selected = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 7),
      decoration: BoxDecoration(
        color: selected ? AppColors.primary : AppColors.surfaceAlt,
        borderRadius: BorderRadius.circular(7),
        border: Border.all(
          color: selected ? AppColors.primary : AppColors.border,
        ),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: selected ? Colors.white : AppColors.textSecondary,
          fontSize: 11,
          fontWeight: FontWeight.w800,
        ),
      ),
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
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: AppColors.textSecondary,
        ),
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final String label;
  final String value;

  const _SummaryRow(this.label, this.value);

  @override
  Widget build(BuildContext context) {
    final isPositive = value.startsWith('+');
    final isNegative = value.startsWith('-');

    return Padding(
      padding: EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: TextStyle(color: AppColors.textSecondary, fontSize: 11),
            ),
          ),
          Text(
            value,
            style: TextStyle(
              color: isPositive
                  ? AppColors.success
                  : isNegative
                  ? AppColors.danger
                  : AppColors.textPrimary,
              fontSize: 11,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

class _Bar extends StatelessWidget {
  final double height;
  final String label;
  final Color color;

  const _Bar({required this.height, required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          width: 28,
          height: height,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(7),
          ),
        ),
        SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(color: AppColors.textSecondary, fontSize: 10),
        ),
      ],
    );
  }
}

class _WeekColumn extends StatelessWidget {
  final String label;
  final double value;
  final String pnl;

  const _WeekColumn(this.label, this.value, this.pnl);

  @override
  Widget build(BuildContext context) {
    final color = pnl.startsWith('-') ? AppColors.danger : AppColors.success;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(color: AppColors.textSecondary, fontSize: 10),
        ),
        SizedBox(height: 8),
        Container(
          height: 86,
          width: 10,
          alignment: Alignment.bottomCenter,
          decoration: BoxDecoration(
            color: AppColors.surfaceAlt,
            borderRadius: BorderRadius.circular(999),
          ),
          child: FractionallySizedBox(
            heightFactor: value,
            child: Container(
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(999),
              ),
            ),
          ),
        ),
        SizedBox(height: 8),
        Text(
          pnl,
          style: TextStyle(
            color: color,
            fontSize: 11,
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    );
  }
}

class _ToolbarButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool selected;

  const _ToolbarButton({
    required this.icon,
    required this.label,
    this.selected = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 34,
      padding: EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: selected ? AppColors.primary : AppColors.surface,
        borderRadius: BorderRadius.circular(7),
        border: Border.all(
          color: selected ? AppColors.primary : AppColors.border,
        ),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            size: 14,
            color: selected ? Colors.white : AppColors.textSecondary,
          ),
          SizedBox(width: 7),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: selected ? Colors.white : AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

class _IconSquare extends StatelessWidget {
  final IconData icon;

  const _IconSquare(this.icon);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 34,
      height: 34,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(7),
        border: Border.all(color: AppColors.border),
      ),
      child: Icon(icon, size: 15, color: AppColors.textSecondary),
    );
  }
}

class _NavButton extends StatelessWidget {
  final IconData icon;

  const _NavButton(this.icon);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 28,
      height: 28,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: AppColors.surfaceAlt,
        borderRadius: BorderRadius.circular(7),
        border: Border.all(color: AppColors.border),
      ),
      child: Icon(icon, size: 12, color: AppColors.textSecondary),
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
        SizedBox(width: 6),
        Text(
          label,
          style: TextStyle(
            color: AppColors.textSecondary,
            fontSize: 10,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}

class _PairDot extends StatelessWidget {
  const _PairDot();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 24,
      height: 16,
      child: Stack(
        children: [
          Positioned(
            left: 0,
            child: Container(
              width: 15,
              height: 15,
              decoration: BoxDecoration(
                color: Color(0xFF2979FF),
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.surface, width: 1),
              ),
            ),
          ),
          Positioned(
            left: 10,
            child: Container(
              width: 15,
              height: 15,
              decoration: BoxDecoration(
                color: Color(0xFFE53935),
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.surface, width: 1),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

String _money(double value) {
  final sign = value > 0
      ? '+'
      : value < 0
      ? '-'
      : '';
  return '$sign\$${value.abs().toStringAsFixed(0)}';
}
