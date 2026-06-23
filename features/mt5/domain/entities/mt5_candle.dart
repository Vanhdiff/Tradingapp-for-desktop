class Mt5Candle {
  final String symbol;
  final String timeframe;
  final DateTime time;
  final double open;
  final double high;
  final double low;
  final double close;
  final int tickVolume;

  const Mt5Candle({
    required this.symbol,
    required this.timeframe,
    required this.time,
    required this.open,
    required this.high,
    required this.low,
    required this.close,
    required this.tickVolume,
  });

  factory Mt5Candle.fromJson(Map<String, dynamic> json) {
    return Mt5Candle(
      symbol: json['symbol'] as String,
      timeframe: json['timeframe'] as String,
      time: DateTime.parse(json['time'] as String),
      open: (json['open'] as num).toDouble(),
      high: (json['high'] as num).toDouble(),
      low: (json['low'] as num).toDouble(),
      close: (json['close'] as num).toDouble(),
      tickVolume: json['tick_volume'] as int,
    );
  }
}
