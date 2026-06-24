import 'package:fluent_ui/fluent_ui.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../shared/widgets/app_panel.dart';
import '../../data/datasources/journal_remote_datasource.dart';
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
  late DateTime _visibleMonth;
  List<JournalCalendarDay> _calendarDays = const [];
  List<JournalOverviewTrade> _overviewTrades = const [];
  JournalMonthSummary _monthSummary = JournalMonthSummary.sample();
  List<JournalWeekSummary> _weekSummary = [
    JournalWeekSummary.sample(1, 640),
    JournalWeekSummary.sample(2, 1120),
    JournalWeekSummary.sample(3, -310),
    JournalWeekSummary.sample(4, 466),
  ];
  JournalDaySummary _daySummary = JournalDaySummary.sample();
  bool _isLoadingOverview = true;
  String? _overviewError;

  final JournalRemoteDataSource _journalRemoteDataSource =
      JournalRemoteDataSource();

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _visibleMonth = DateTime(now.year, now.month);
    _calendarDays = _buildJournalCalendarGrid(_visibleMonth);
    _selectedCalendarDayIndex = _defaultSelectedDayIndex(_calendarDays);
    _daySummary = _emptyDaySummary(_dateKey(now));
    _loadJournalOverview();
  }

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
                          visibleMonth: _visibleMonth,
                          calendarDays: _calendarDays,
                          monthSummary: _monthSummary,
                          weekSummary: _weekSummary,
                          daySummary: _daySummary,
                          trades: _overviewTrades,
                          isLoading: _isLoadingOverview,
                          errorMessage: _overviewError,
                          onCalendarDaySelected: (index) {
                            _selectCalendarDay(index);
                          },
                          onPreviousMonth: () => _changeVisibleMonth(-1),
                          onNextMonth: () => _changeVisibleMonth(1),
                          selectedTradeIndex: _selectedTradeIndex,
                          onTradeClicked: (index) {
                            setState(() => _selectedTradeIndex = index);
                          },
                          onTradeSelected: (index) {
                            setState(() {
                              _selectedTradeIndex = index;
                              _showTradeDetail = true;
                            });
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
    final trade = _selectedTrade;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        JournalHeader(
          title: _detailTitle(trade),
          onBack: () => setState(() => _showTradeDetail = false),
        ),
        const SizedBox(height: 18),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 360,
              child: JournalTradeDetailsPanel(
                netPnl: trade == null
                    ? JournalSampleData.netPnl
                    : _money(trade.pnl),
                instrument: trade == null
                    ? JournalSampleData.instrument
                    : trade.symbol,
                direction: trade == null
                    ? JournalSampleData.direction
                    : _directionLabel(trade.direction),
                lotSize: trade == null
                    ? JournalSampleData.lotSize
                    : trade.lots.toStringAsFixed(2),
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

  JournalOverviewTrade? get _selectedTrade {
    final index = _selectedTradeIndex;
    if (index == null || index < 0 || index >= _overviewTrades.length) {
      return null;
    }
    return _overviewTrades[index];
  }

  String _detailTitle(JournalOverviewTrade? trade) {
    if (trade == null) return JournalSampleData.title;
    return '${trade.symbol} · ${_directionLabel(trade.direction)} · ${trade.setup}';
  }

  String _directionLabel(String direction) {
    final isBuy = direction.toLowerCase() == 'buy';
    return '${isBuy ? '↑' : '↓'} ${isBuy ? 'Buy' : 'Sell'}';
  }

  Future<void> _loadJournalOverview() async {
    setState(() {
      _isLoadingOverview = true;
      _overviewError = null;
    });

    try {
      final results = await Future.wait([
        _journalRemoteDataSource.fetchCalendar(
          year: _visibleMonth.year,
          month: _visibleMonth.month,
        ),
        _journalRemoteDataSource.fetchMonthSummary(
          year: _visibleMonth.year,
          month: _visibleMonth.month,
        ),
        _journalRemoteDataSource.fetchWeekSummary(
          year: _visibleMonth.year,
          month: _visibleMonth.month,
        ),
      ]);

      if (!mounted) return;
      final days = results[0] as List<JournalCalendarDay>;
      final selectedIndex = _defaultSelectedDayIndex(days);
      final selectedDateKey = selectedIndex == null
          ? _dateKey(DateTime(_visibleMonth.year, _visibleMonth.month))
          : days[selectedIndex].dateKey!;
      final daySummary = await _journalRemoteDataSource.fetchDaySummary(
        dateKey: selectedDateKey,
      );

      if (!mounted) return;
      setState(() {
        _calendarDays = days;
        _monthSummary = results[1] as JournalMonthSummary;
        _weekSummary = results[2] as List<JournalWeekSummary>;
        _daySummary = daySummary;
        _overviewTrades = daySummary.trades;
        _selectedCalendarDayIndex = selectedIndex;
        _selectedTradeIndex = null;
        _isLoadingOverview = false;
      });
    } catch (error) {
      if (!mounted) return;
      setState(() {
        _calendarDays = _buildJournalCalendarGrid(_visibleMonth);
        _selectedCalendarDayIndex = _defaultSelectedDayIndex(_calendarDays);
        _daySummary = _emptyDaySummary(
          _selectedCalendarDayIndex == null
              ? _dateKey(DateTime(_visibleMonth.year, _visibleMonth.month))
              : _calendarDays[_selectedCalendarDayIndex!].dateKey!,
        );
        _overviewTrades = const [];
        _isLoadingOverview = false;
        _overviewError = 'Backend offline - showing sample journal data';
      });
    }
  }

  void _changeVisibleMonth(int offset) {
    final nextMonth = DateTime(
      _visibleMonth.year,
      _visibleMonth.month + offset,
    );
    final days = _buildJournalCalendarGrid(nextMonth);
    final selectedIndex = _defaultSelectedDayIndex(days);
    final selectedDateKey = selectedIndex == null
        ? _dateKey(DateTime(nextMonth.year, nextMonth.month))
        : days[selectedIndex].dateKey!;

    setState(() {
      _visibleMonth = nextMonth;
      _calendarDays = days;
      _selectedCalendarDayIndex = selectedIndex;
      _selectedTradeIndex = null;
      _showTradeDetail = false;
      _daySummary = _emptyDaySummary(selectedDateKey);
      _overviewTrades = const [];
    });

    _loadJournalOverview();
  }

  Future<void> _selectCalendarDay(int index) async {
    setState(() {
      _selectedCalendarDayIndex = index;
      _selectedTradeIndex = null;
    });

    final dateKey = _calendarDays[index].dateKey;
    if (dateKey == null) return;

    try {
      final daySummary = await _journalRemoteDataSource.fetchDaySummary(
        dateKey: dateKey,
      );
      if (!mounted) return;
      setState(() {
        _daySummary = daySummary;
        _overviewTrades = daySummary.trades;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _daySummary = _emptyDaySummary(dateKey);
        _overviewTrades = const [];
      });
    }
  }

  int? _defaultSelectedDayIndex(List<JournalCalendarDay> days) {
    final todayKey = _dateKey(DateTime.now());
    final todayIndex = days.indexWhere((day) => day.dateKey == todayKey);
    if (todayIndex != -1) return todayIndex;
    final tradeIndex = days.indexWhere(
      (day) => !day.isMuted && day.tradeCount > 0,
    );
    return tradeIndex == -1 ? null : tradeIndex;
  }

  List<JournalCalendarDay> _buildJournalCalendarGrid(DateTime visibleMonth) {
    final firstDay = DateTime(visibleMonth.year, visibleMonth.month);
    final leadingDays = firstDay.weekday - DateTime.monday;

    return List.generate(42, (index) {
      final date = DateTime(
        visibleMonth.year,
        visibleMonth.month,
        1 - leadingDays + index,
      );

      return JournalCalendarDay(
        day: date.day,
        dateKey: _dateKey(date),
        isMuted: date.month != visibleMonth.month,
      );
    });
  }

  JournalDaySummary _emptyDaySummary(String dateKey) {
    return JournalDaySummary(
      dateKey: dateKey,
      netPnl: 0,
      returnPercent: 0,
      expectancy: 0,
      tradeCount: 0,
      ruleBreakCount: 0,
      maxDailyLossUsed: 0,
      disciplineScore: 0,
      trades: const [],
    );
  }

  String _dateKey(DateTime value) {
    final month = value.month.toString().padLeft(2, '0');
    final day = value.day.toString().padLeft(2, '0');
    return '${value.year}-$month-$day';
  }
}

class _JournalOverview extends StatelessWidget {
  final int? selectedCalendarDayIndex;
  final DateTime visibleMonth;
  final List<JournalCalendarDay> calendarDays;
  final JournalMonthSummary monthSummary;
  final List<JournalWeekSummary> weekSummary;
  final JournalDaySummary daySummary;
  final List<JournalOverviewTrade> trades;
  final bool isLoading;
  final String? errorMessage;
  final ValueChanged<int> onCalendarDaySelected;
  final VoidCallback onPreviousMonth;
  final VoidCallback onNextMonth;
  final int? selectedTradeIndex;
  final ValueChanged<int> onTradeClicked;
  final ValueChanged<int> onTradeSelected;

  const _JournalOverview({
    required this.selectedCalendarDayIndex,
    required this.visibleMonth,
    required this.calendarDays,
    required this.monthSummary,
    required this.weekSummary,
    required this.daySummary,
    required this.trades,
    required this.isLoading,
    required this.errorMessage,
    required this.onCalendarDaySelected,
    required this.onPreviousMonth,
    required this.onNextMonth,
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
              _OverviewHeader(isLoading: isLoading, errorMessage: errorMessage),
              SizedBox(height: 16),
              _JournalCalendarPanel(
                visibleMonth: visibleMonth,
                days: calendarDays,
                selectedDayIndex: selectedCalendarDayIndex,
                onDaySelected: onCalendarDaySelected,
                onPreviousMonth: onPreviousMonth,
                onNextMonth: onNextMonth,
              ),
              SizedBox(height: 16),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: _MonthlySummaryPanel(summary: monthSummary)),
                  SizedBox(width: 16),
                  Expanded(child: _WeeklyBreakdownPanel(weeks: weekSummary)),
                ],
              ),
            ],
          ),
        ),
        SizedBox(width: 18),
        SizedBox(
          width: 340,
          child: _DayTradePanel(
            trades: trades,
            selectedTradeIndex: selectedTradeIndex,
            summary: daySummary,
            onTradeClicked: onTradeClicked,
            onTradeSelected: onTradeSelected,
          ),
        ),
      ],
    );
  }
}

class _OverviewHeader extends StatelessWidget {
  final bool isLoading;
  final String? errorMessage;

  const _OverviewHeader({required this.isLoading, required this.errorMessage});

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
        SizedBox(width: 12),
        if (isLoading)
          _StatusPill(
            icon: FluentIcons.sync,
            label: 'Loading backend',
            color: AppColors.primary,
          )
        else if (errorMessage != null)
          _StatusPill(
            icon: FluentIcons.warning,
            label: errorMessage!,
            color: AppColors.warning,
          )
        else
          _StatusPill(
            icon: FluentIcons.check_mark,
            label: 'Connected to backend',
            color: AppColors.success,
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

class _StatusPill extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;

  const _StatusPill({
    required this.icon,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(maxWidth: 260),
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(7),
        border: Border.all(color: color.withValues(alpha: 0.28)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13, color: color),
          SizedBox(width: 7),
          Flexible(
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: color,
                fontSize: 11,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _JournalCalendarPanel extends StatelessWidget {
  final DateTime visibleMonth;
  final List<JournalCalendarDay> days;
  final int? selectedDayIndex;
  final ValueChanged<int> onDaySelected;
  final VoidCallback onPreviousMonth;
  final VoidCallback onNextMonth;

  const _JournalCalendarPanel({
    required this.visibleMonth,
    required this.days,
    required this.selectedDayIndex,
    required this.onDaySelected,
    required this.onPreviousMonth,
    required this.onNextMonth,
  });

  @override
  Widget build(BuildContext context) {
    return AppPanel(
      padding: EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            children: [
              _NavButton(FluentIcons.chevron_left, onPressed: onPreviousMonth),
              SizedBox(width: 6),
              _NavButton(FluentIcons.chevron_right, onPressed: onNextMonth),
              SizedBox(width: 12),
              Text(
                _monthTitle(visibleMonth),
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
            itemCount: days.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
              childAspectRatio: 1.24,
            ),
            itemBuilder: (context, index) {
              return _CalendarTradeDay(
                day: days[index],
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
  final List<JournalOverviewTrade> trades;
  final JournalDaySummary summary;
  final int? selectedTradeIndex;
  final ValueChanged<int> onTradeClicked;
  final ValueChanged<int> onTradeSelected;

  const _DayTradePanel({
    required this.trades,
    required this.summary,
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
            _dayTitle(summary.dateKey),
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
          ),
          SizedBox(height: 4),
          Text(
            '${summary.tradeCount} trades imported from MT5',
            style: TextStyle(color: AppColors.textSecondary, fontSize: 11),
          ),
          SizedBox(height: 18),
          Text(
            _money(summary.netPnl),
            style: TextStyle(
              color: summary.netPnl >= 0 ? AppColors.success : AppColors.danger,
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
              Expanded(
                child: _DayMetric(
                  '${summary.returnPercent.toStringAsFixed(2)}%',
                  'Return',
                ),
              ),
              Expanded(child: _DayMetric(_r(summary.expectancy), 'Expectancy')),
            ],
          ),
          SizedBox(height: 16),
          Row(
            children: [
              Expanded(child: _DayMetric('${summary.tradeCount}', 'Trades')),
              Expanded(
                child: _DayMetric('${summary.ruleBreakCount}', 'Rule break'),
              ),
            ],
          ),
          SizedBox(height: 20),
          _RiskLine(label: 'Max daily loss', value: summary.maxDailyLossUsed),
          SizedBox(height: 10),
          _RiskLine(label: 'Discipline score', value: summary.disciplineScore),
          SizedBox(height: 18),
          _TradeTabs(),
          SizedBox(height: 12),
          if (trades.isEmpty)
            _EmptyTradesNotice()
          else
            ...trades.asMap().entries.map((entry) {
              return _TradeListItem(
                trade: entry.value,
                selected: selectedTradeIndex == entry.key,
                onPressed: () => onTradeClicked(entry.key),
                onDoublePressed: () => onTradeSelected(entry.key),
              );
            }),
        ],
      ),
    );
  }
}

class _EmptyTradesNotice extends StatelessWidget {
  const _EmptyTradesNotice();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surfaceAlt,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.border),
      ),
      child: Text(
        'No trades synced for this day.',
        style: TextStyle(
          color: AppColors.textSecondary,
          fontSize: 11,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _MonthlySummaryPanel extends StatelessWidget {
  final JournalMonthSummary summary;

  const _MonthlySummaryPanel({required this.summary});

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
                    children: _bars(summary.weeklyPnl),
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
                _SummaryRow('Expectancy', _r(summary.expectancy)),
                _SummaryRow(
                  'Win rate',
                  '${summary.winRate.toStringAsFixed(0)}%',
                ),
                _SummaryRow('Avg win', _money(summary.avgWin)),
                _SummaryRow('Avg loss', _money(summary.avgLoss)),
                _SummaryRow('Net PnL', _money(summary.netPnl)),
                _SummaryRow('Mistakes', '${summary.mistakes}'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _bars(List<double> pnl) {
    final values = List<double>.from(pnl);
    while (values.length < 4) {
      values.add(0);
    }
    final maxAbs = values
        .map((value) => value.abs())
        .fold<double>(1, (max, value) => value > max ? value : max);

    return [
      for (var index = 0; index < 4; index++) ...[
        _Bar(
          height: 44 + (values[index].abs() / maxAbs) * 100,
          label: 'W${index + 1}',
          color: values[index] >= 0
              ? (index == 1 ? AppColors.primary : AppColors.success)
              : AppColors.danger,
        ),
        if (index != 3) SizedBox(width: 10),
      ],
    ];
  }
}

class _WeeklyBreakdownPanel extends StatelessWidget {
  final List<JournalWeekSummary> weeks;

  const _WeeklyBreakdownPanel({required this.weeks});

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
              for (final week in weeks.take(4))
                Expanded(
                  child: _WeekColumn(
                    'Week ${week.week}',
                    (week.pnl.abs() / _maxWeekPnl).clamp(0.08, 1.0),
                    _money(week.pnl),
                  ),
                ),
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

  double get _maxWeekPnl {
    if (weeks.isEmpty) return 1;
    return weeks
        .map((week) => week.pnl.abs())
        .fold<double>(1, (max, value) => value > max ? value : max);
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
  final VoidCallback? onPressed;

  const _NavButton(this.icon, {this.onPressed});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: 28,
        height: 28,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: AppColors.surfaceAlt,
          borderRadius: BorderRadius.circular(7),
          border: Border.all(color: AppColors.border),
        ),
        child: Icon(icon, size: 12, color: AppColors.textSecondary),
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

String _r(double value) {
  return '${value > 0 ? '+' : ''}${value.toStringAsFixed(2)}R';
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

String _dayTitle(String dateKey) {
  const weekdays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
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
  final date = DateTime.parse(dateKey);
  return '${weekdays[date.weekday - 1]}, ${months[date.month - 1]} ${date.day}';
}
