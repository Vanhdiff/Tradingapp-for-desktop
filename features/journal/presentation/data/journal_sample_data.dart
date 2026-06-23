abstract final class JournalSampleData {
  static const title = '🇪🇺🇺🇸 EURUSD · ↑ Buy · Mon, Dec 8, 2025';
  static const instrument = '🇪🇺🇺🇸 EURUSD';
  static const direction = '↑ Buy';
  static const lotSize = '3.00';
  static const netPnl = '+\$1,329.00';

  static const initialReflection =
      'Followed plan: waited for liquidity sweep above Asia high, entered after MTF confirmation. Took partials at 1R/2R, SL to BE. Next time: skip the add-on while spread widens.';

  static const confluences = [
    'Trailing Stop Loss',
    'Breakout + Pullback',
    'Mean reversion',
  ];

  static const plans = ['Weekly Range', 'London Sweep', 'NY Continuation'];

  static const emotions = ['Calm', 'Confident', 'Disappointed', 'Rushed'];

  static const overviewTrades = [
    JournalOverviewTrade(
      symbol: 'XAUUSD',
      direction: 'Buy',
      pnl: 420,
      rMultiple: 1.4,
      lots: 0.30,
      time: '09:25',
      setup: 'London sweep',
      status: 'Win',
    ),
    JournalOverviewTrade(
      symbol: 'EURUSD',
      direction: 'Sell',
      pnl: -180,
      rMultiple: -0.6,
      lots: 1.00,
      time: '10:40',
      setup: 'NY continuation',
      status: 'Loss',
    ),
    JournalOverviewTrade(
      symbol: 'GBPUSD',
      direction: 'Buy',
      pnl: 92,
      rMultiple: 0.3,
      lots: 0.70,
      time: '14:15',
      setup: 'Weekly range',
      status: 'Win',
    ),
  ];

  static const calendarDays = [
    JournalCalendarDay(day: 24, isMuted: true),
    JournalCalendarDay(day: 25, isMuted: true),
    JournalCalendarDay(day: 26, isMuted: true),
    JournalCalendarDay(day: 27, isMuted: true),
    JournalCalendarDay(day: 28, isMuted: true),
    JournalCalendarDay(day: 1, pnl: 240, tradeCount: 2),
    JournalCalendarDay(day: 2),
    JournalCalendarDay(day: 3, pnl: -120, tradeCount: 1),
    JournalCalendarDay(day: 4, pnl: 315, tradeCount: 3),
    JournalCalendarDay(day: 5),
    JournalCalendarDay(day: 6, pnl: 98, tradeCount: 1),
    JournalCalendarDay(day: 7),
    JournalCalendarDay(day: 8, pnl: 1329, tradeCount: 4),
    JournalCalendarDay(day: 9, pnl: -260, tradeCount: 2),
    JournalCalendarDay(day: 10, pnl: 332, tradeCount: 3, hasReview: true),
    JournalCalendarDay(day: 11),
    JournalCalendarDay(day: 12, pnl: 148, tradeCount: 1),
    JournalCalendarDay(day: 13, pnl: -90, tradeCount: 1),
    JournalCalendarDay(day: 14),
    JournalCalendarDay(day: 15, pnl: 74, tradeCount: 1),
    JournalCalendarDay(day: 16),
    JournalCalendarDay(day: 17, pnl: 505, tradeCount: 2),
    JournalCalendarDay(day: 18, pnl: -310, tradeCount: 2),
    JournalCalendarDay(day: 19),
    JournalCalendarDay(day: 20, pnl: 126, tradeCount: 1),
    JournalCalendarDay(day: 21),
    JournalCalendarDay(day: 22),
    JournalCalendarDay(day: 23, pnl: 210, tradeCount: 2),
    JournalCalendarDay(day: 24, pnl: -85, tradeCount: 1),
    JournalCalendarDay(day: 25),
    JournalCalendarDay(day: 26, pnl: 640, tradeCount: 3),
    JournalCalendarDay(day: 27),
    JournalCalendarDay(day: 28, pnl: 96, tradeCount: 1),
    JournalCalendarDay(day: 29),
    JournalCalendarDay(day: 30, pnl: -150, tradeCount: 1),
    JournalCalendarDay(day: 31),
    JournalCalendarDay(day: 1, isMuted: true),
    JournalCalendarDay(day: 2, isMuted: true),
    JournalCalendarDay(day: 3, isMuted: true),
    JournalCalendarDay(day: 4, isMuted: true),
    JournalCalendarDay(day: 5, isMuted: true),
    JournalCalendarDay(day: 6, isMuted: true),
  ];
}

class JournalCalendarDay {
  final int day;
  final double pnl;
  final int tradeCount;
  final bool isMuted;
  final bool hasReview;

  const JournalCalendarDay({
    required this.day,
    this.pnl = 0,
    this.tradeCount = 0,
    this.isMuted = false,
    this.hasReview = false,
  });
}

class JournalOverviewTrade {
  final String symbol;
  final String direction;
  final double pnl;
  final double rMultiple;
  final double lots;
  final String time;
  final String setup;
  final String status;

  const JournalOverviewTrade({
    required this.symbol,
    required this.direction,
    required this.pnl,
    required this.rMultiple,
    required this.lots,
    required this.time,
    required this.setup,
    required this.status,
  });
}
