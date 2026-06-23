import 'package:fluent_ui/fluent_ui.dart';

import '../../data/datasources/news_remote_datasource.dart';
import '../data/news_sample_data.dart';
import '../widgets/news_calendar_panel.dart';
import '../widgets/news_events_panel.dart';
import '../widgets/news_header.dart';

class NewsPage extends StatefulWidget {
  const NewsPage({super.key});

  @override
  State<NewsPage> createState() => _NewsPageState();
}

class _NewsPageState extends State<NewsPage> {
  bool _showListNotice = false;
  late DateTime _visibleMonth;
  List<CalendarDayData> _calendarDays = NewsSampleData.calendarDays;
  List<NewsEventData> _upcomingEvents = NewsSampleData.upcomingEvents;
  List<NewsEventData> _selectedDayEvents = NewsSampleData.todayEvents;
  String _selectedDayTitle = 'Today';
  String? _errorMessage;

  final NewsRemoteDataSource _remoteDataSource = NewsRemoteDataSource();

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _visibleMonth = DateTime(now.year, now.month);
    _selectedDayTitle = _dayTitle(now);
    _loadNews();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        const horizontalPadding = 22.0;
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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      NewsHeader(
                        selectedMode: _showListNotice
                            ? NewsViewMode.list
                            : NewsViewMode.calendar,
                        onModeChanged: (mode) {
                          setState(() {
                            if (mode == NewsViewMode.list) {
                              _showListNotice = !_showListNotice;
                            } else {
                              _showListNotice = false;
                            }
                          });
                        },
                      ),
                      if (_errorMessage != null) ...[
                        const SizedBox(height: 10),
                        Text(
                          _errorMessage!,
                          style: TextStyle(
                            color: Colors.orange,
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                      const SizedBox(height: 16),
                      Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              NewsCalendarPanel(
                                visibleMonth: _visibleMonth,
                                days: _calendarDays,
                                onDaySelected: _selectDay,
                              ),
                              SizedBox(height: 14),
                              UpcomingEventsPanel(events: _upcomingEvents),
                            ],
                          ),
                          if (_showListNotice)
                            Positioned(
                              top: 0,
                              right: 0,
                              child: SizedBox(
                                width: 560,
                                child: NewsEventsPanel(
                                  title: _selectedDayTitle,
                                  events: _selectedDayEvents,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> _loadNews() async {
    try {
      final results = await Future.wait([
        _remoteDataSource.fetchCalendar(
          year: _visibleMonth.year,
          month: _visibleMonth.month,
        ),
        _remoteDataSource.fetchUpcoming(limit: 20),
        _remoteDataSource.fetchDayEvents(dateKey: _dateKey(DateTime.now())),
      ]);

      if (!mounted) return;
      setState(() {
        _calendarDays = results[0] as List<CalendarDayData>;
        _upcomingEvents = results[1] as List<NewsEventData>;
        _selectedDayEvents = results[2] as List<NewsEventData>;
        _errorMessage = null;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _calendarDays = NewsSampleData.calendarDays;
        _upcomingEvents = NewsSampleData.upcomingEvents;
        _selectedDayEvents = NewsSampleData.todayEvents;
        _errorMessage =
            'News backend offline - showing sample economic calendar';
      });
    }
  }

  Future<void> _selectDay(CalendarDayData day) async {
    final dateKey = day.dateKey;
    if (dateKey == null) return;

    setState(() {
      _showListNotice = true;
      _selectedDayTitle = _dayTitle(DateTime.parse(dateKey));
    });

    try {
      final events = await _remoteDataSource.fetchDayEvents(dateKey: dateKey);
      if (!mounted) return;
      setState(() => _selectedDayEvents = events);
    } catch (_) {
      if (!mounted) return;
      setState(() => _selectedDayEvents = NewsSampleData.todayEvents);
    }
  }

  String _dateKey(DateTime value) {
    final month = value.month.toString().padLeft(2, '0');
    final day = value.day.toString().padLeft(2, '0');
    return '${value.year}-$month-$day';
  }

  String _dayTitle(DateTime value) {
    const weekdays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return '${weekdays[value.weekday - 1]}, ${months[value.month - 1]} ${value.day}';
  }
}
