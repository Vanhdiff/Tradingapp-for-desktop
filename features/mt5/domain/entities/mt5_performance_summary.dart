class Mt5PerformanceSummary {
  final String period;
  final double netPnl;
  final int tradeCount;
  final int winCount;
  final int lossCount;
  final double winRate;
  final double profitFactor;
  final double maxDrawdown;
  final String bestSymbol;
  final String worstSymbol;

  const Mt5PerformanceSummary({
    required this.period,
    required this.netPnl,
    required this.tradeCount,
    required this.winCount,
    required this.lossCount,
    required this.winRate,
    required this.profitFactor,
    required this.maxDrawdown,
    required this.bestSymbol,
    required this.worstSymbol,
  });

  factory Mt5PerformanceSummary.fromJson(Map<String, dynamic> json) {
    return Mt5PerformanceSummary(
      period: json['period'] as String,
      netPnl: (json['net_pnl'] as num).toDouble(),
      tradeCount: json['trade_count'] as int,
      winCount: json['win_count'] as int,
      lossCount: json['loss_count'] as int,
      winRate: (json['win_rate'] as num).toDouble(),
      profitFactor: (json['profit_factor'] as num).toDouble(),
      maxDrawdown: (json['max_drawdown'] as num).toDouble(),
      bestSymbol: json['best_symbol'] as String,
      worstSymbol: json['worst_symbol'] as String,
    );
  }
}
