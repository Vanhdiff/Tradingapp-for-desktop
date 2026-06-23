import '../../../../app/services/api/api_client.dart';
import '../../presentation/data/journal_sample_data.dart';

class JournalRemoteDataSource {
  final ApiClient _apiClient;

  JournalRemoteDataSource({ApiClient? apiClient})
    : _apiClient = apiClient ?? ApiClient();

  Future<List<JournalOverviewTrade>> fetchTrades() async {
    final response = await _apiClient.getJson('/journal/trades');
    final items = response as List<dynamic>;

    return items.map((item) {
      final json = item as Map<String, dynamic>;
      final direction = _titleCase(json['direction'] as String);
      final openedAt = DateTime.parse(json['opened_at'] as String);

      return JournalOverviewTrade(
        id: json['id'] as int,
        symbol: json['symbol'] as String,
        direction: direction,
        pnl: (json['pnl'] as num).toDouble(),
        rMultiple: (json['r_multiple'] as num).toDouble(),
        lots: (json['lot_size'] as num).toDouble(),
        time: _formatTime(openedAt),
        setup: json['setup'] as String? ?? '',
        status: _titleCase(json['status'] as String),
      );
    }).toList();
  }

  Future<List<JournalCalendarDay>> fetchCalendar({
    required int year,
    required int month,
  }) async {
    final response = await _apiClient.getJson(
      '/mt5/journal/calendar',
      queryParameters: {'year': '$year', 'month': '$month'},
    );
    final items = response as List<dynamic>;
    final tradeDays = <int, Map<String, dynamic>>{};

    for (final item in items) {
      final json = item as Map<String, dynamic>;
      final date = DateTime.parse(json['date'] as String);
      tradeDays[date.day] = json;
    }

    return _buildMonthGrid(year: year, month: month, tradeDays: tradeDays);
  }

  List<JournalCalendarDay> _buildMonthGrid({
    required int year,
    required int month,
    required Map<int, Map<String, dynamic>> tradeDays,
  }) {
    final firstDay = DateTime(year, month);
    final leadingDays = firstDay.weekday - DateTime.monday;

    return List.generate(42, (index) {
      final date = DateTime(year, month, 1 - leadingDays + index);
      final isCurrentMonth = date.month == month;
      final tradeDay = isCurrentMonth ? tradeDays[date.day] : null;

      return JournalCalendarDay(
        day: date.day,
        dateKey: _dateKey(date),
        pnl: ((tradeDay?['pnl'] ?? 0) as num).toDouble(),
        tradeCount: ((tradeDay?['trade_count'] ?? 0) as num).toInt(),
        isMuted: !isCurrentMonth,
        hasReview: tradeDay?['has_review'] as bool? ?? false,
      );
    });
  }

  Future<JournalMonthSummary> fetchMonthSummary({
    required int year,
    required int month,
  }) async {
    final response =
        await _apiClient.getJson(
              '/mt5/journal/month-summary',
              queryParameters: {'year': '$year', 'month': '$month'},
            )
            as Map<String, dynamic>;

    return JournalMonthSummary(
      expectancy: (response['expectancy'] as num).toDouble(),
      winRate: (response['win_rate'] as num).toDouble(),
      avgWin: (response['avg_win'] as num).toDouble(),
      avgLoss: (response['avg_loss'] as num).toDouble(),
      netPnl: (response['net_pnl'] as num).toDouble(),
      mistakes: response['mistakes'] as int,
      weeklyPnl: (response['weekly_pnl'] as List<dynamic>)
          .map((item) => (item as num).toDouble())
          .toList(),
    );
  }

  Future<List<JournalWeekSummary>> fetchWeekSummary({
    required int year,
    required int month,
  }) async {
    final response =
        await _apiClient.getJson(
              '/mt5/journal/week-summary',
              queryParameters: {'year': '$year', 'month': '$month'},
            )
            as List<dynamic>;

    return response.map((item) {
      final json = item as Map<String, dynamic>;
      return JournalWeekSummary(
        week: json['week'] as int,
        pnl: (json['pnl'] as num).toDouble(),
        tradeCount: json['trade_count'] as int,
        winRate: (json['win_rate'] as num).toDouble(),
      );
    }).toList();
  }

  Future<JournalDaySummary> fetchDaySummary({required String dateKey}) async {
    final response =
        await _apiClient.getJson(
              '/mt5/journal/day-summary',
              queryParameters: {'date': dateKey},
            )
            as Map<String, dynamic>;

    final trades = (response['trades'] as List<dynamic>).map((item) {
      final json = item as Map<String, dynamic>;
      final direction = _titleCase(json['direction'] as String);
      final openedAt = DateTime.parse(json['opened_at'] as String);

      return JournalOverviewTrade(
        id: json['ticket'] as int,
        symbol: json['symbol'] as String,
        direction: direction,
        pnl: (json['pnl'] as num).toDouble(),
        rMultiple: (json['r_multiple'] as num).toDouble(),
        lots: (json['volume'] as num).toDouble(),
        time: _formatTime(openedAt),
        setup: json['setup'] as String? ?? '',
        status: _titleCase(json['status'] as String),
      );
    }).toList();

    return JournalDaySummary(
      dateKey: response['date'] as String,
      netPnl: (response['net_pnl'] as num).toDouble(),
      returnPercent: (response['return_percent'] as num).toDouble(),
      expectancy: (response['expectancy'] as num).toDouble(),
      tradeCount: response['trade_count'] as int,
      ruleBreakCount: response['rule_break_count'] as int,
      maxDailyLossUsed: (response['max_daily_loss_used'] as num).toDouble(),
      disciplineScore: (response['discipline_score'] as num).toDouble(),
      trades: trades,
    );
  }

  static String _titleCase(String value) {
    if (value.isEmpty) return value;
    return value[0].toUpperCase() + value.substring(1).toLowerCase();
  }

  static String _formatTime(DateTime value) {
    final hour = value.hour.toString().padLeft(2, '0');
    final minute = value.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  static String _dateKey(DateTime value) {
    final month = value.month.toString().padLeft(2, '0');
    final day = value.day.toString().padLeft(2, '0');
    return '${value.year}-$month-$day';
  }
}
