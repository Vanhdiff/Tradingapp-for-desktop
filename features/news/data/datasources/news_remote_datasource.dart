import '../../../../app/services/api/api_client.dart';
import '../../../../app/theme/app_colors.dart';
import '../../presentation/data/news_sample_data.dart';

class NewsRemoteDataSource {
  final ApiClient _apiClient;

  NewsRemoteDataSource({ApiClient? apiClient})
    : _apiClient = apiClient ?? ApiClient();

  Future<List<CalendarDayData>> fetchCalendar({
    required int year,
    required int month,
  }) async {
    final response =
        await _apiClient.getJson(
              '/news/calendar',
              queryParameters: {'year': '$year', 'month': '$month'},
            )
            as List<dynamic>;
    final eventDays = <int, Map<String, dynamic>>{};

    for (final item in response) {
      final json = item as Map<String, dynamic>;
      final date = DateTime.parse(json['date'] as String);
      eventDays[date.day] = json;
    }

    return _buildMonthGrid(year: year, month: month, eventDays: eventDays);
  }

  Future<List<NewsEventData>> fetchUpcoming({int limit = 20}) async {
    final response =
        await _apiClient.getJson(
              '/news/upcoming',
              queryParameters: {'limit': '$limit'},
            )
            as List<dynamic>;
    return response
        .map((item) => _eventFromJson(item as Map<String, dynamic>))
        .toList();
  }

  Future<List<NewsEventData>> fetchDayEvents({required String dateKey}) async {
    final response =
        await _apiClient.getJson(
              '/news/day',
              queryParameters: {'date': dateKey},
            )
            as List<dynamic>;
    return response
        .map((item) => _eventFromJson(item as Map<String, dynamic>))
        .toList();
  }

  List<CalendarDayData> _buildMonthGrid({
    required int year,
    required int month,
    required Map<int, Map<String, dynamic>> eventDays,
  }) {
    final firstDay = DateTime(year, month);
    final leadingDays = firstDay.weekday - DateTime.monday;
    final todayKey = _dateKey(DateTime.now());

    return List.generate(42, (index) {
      final date = DateTime(year, month, 1 - leadingDays + index);
      final isCurrentMonth = date.month == month;
      final eventDay = isCurrentMonth ? eventDays[date.day] : null;
      final dateKey = _dateKey(date);

      return CalendarDayData(
        day: date.day,
        dateKey: dateKey,
        lowImpact: ((eventDay?['low_impact'] ?? 0) as num).toInt(),
        mediumImpact: ((eventDay?['medium_impact'] ?? 0) as num).toInt(),
        highImpact: ((eventDay?['high_impact'] ?? 0) as num).toInt(),
        isToday: dateKey == todayKey,
        isMuted: !isCurrentMonth,
        isBlocked: eventDay?['is_blocked'] as bool? ?? false,
      );
    });
  }

  NewsEventData _eventFromJson(Map<String, dynamic> json) {
    final time = DateTime.parse(json['time'] as String).toLocal();
    final impact = json['impact'] as String;
    return NewsEventData(
      id: json['id'] as String? ?? '',
      time:
          '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}',
      currency: '${_flag(json['currency'] as String)} ${json['currency']}',
      impactColor: switch (impact) {
        'high' => AppColors.danger,
        'medium' => AppColors.warning,
        _ => AppColors.textSecondary,
      },
      event: json['event'] as String,
      actual: _valueOrDash(json['actual'] as String?),
      forecast: _valueOrDash(json['forecast'] as String?),
      previous: _valueOrDash(json['previous'] as String?),
    );
  }

  String _valueOrDash(String? value) {
    final normalized = value?.trim() ?? '';
    return normalized.isEmpty ? '-' : normalized;
  }

  String _flag(String currency) {
    return switch (currency) {
      'USD' => '🇺🇸',
      'EUR' => '🇪🇺',
      'GBP' => '🇬🇧',
      'JPY' => '🇯🇵',
      'AUD' => '🇦🇺',
      'CAD' => '🇨🇦',
      'CHF' => '🇨🇭',
      'NZD' => '🇳🇿',
      _ => '•',
    };
  }

  String _dateKey(DateTime value) {
    final month = value.month.toString().padLeft(2, '0');
    final day = value.day.toString().padLeft(2, '0');
    return '${value.year}-$month-$day';
  }
}
