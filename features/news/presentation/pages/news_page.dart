import 'package:fluent_ui/fluent_ui.dart';

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
                      const SizedBox(height: 16),
                      Stack(
                        clipBehavior: Clip.none,
                        children: [
                          const Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              NewsCalendarPanel(
                                days: NewsSampleData.calendarDays,
                              ),
                              SizedBox(height: 14),
                              UpcomingEventsPanel(
                                events: NewsSampleData.upcomingEvents,
                              ),
                            ],
                          ),
                          if (_showListNotice)
                            const Positioned(
                              top: 0,
                              right: 0,
                              child: SizedBox(
                                width: 560,
                                child: NewsEventsPanel(
                                  events: NewsSampleData.todayEvents,
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
}
