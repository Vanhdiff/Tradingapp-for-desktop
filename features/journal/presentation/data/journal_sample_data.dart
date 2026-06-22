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
}
