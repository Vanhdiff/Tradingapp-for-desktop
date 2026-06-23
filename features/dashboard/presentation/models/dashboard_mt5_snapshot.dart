import '../../../mt5/domain/entities/mt5_account.dart';
import '../../../mt5/domain/entities/mt5_performance_summary.dart';
import '../../../mt5/domain/entities/mt5_position.dart';

class DashboardMt5Snapshot {
  final double accountBalance;
  final double equity;
  final double totalClosedPnl;
  final double winRate;
  final double avgRPerTrade;
  final double bestR;
  final double worstR;
  final double profitFactor;
  final int todayTradeCount;
  final int maxTradesPerDay;
  final double todayClosedPnl;
  final double maxDailyLoss;
  final double dailyTarget;
  final int disciplineScore;
  final int performanceScore;
  final int consistencyScore;
  final int maxLossViolations;
  final int profitTargetViolations;
  final bool maxLossReached;
  final String bestSymbol;
  final String worstSymbol;

  const DashboardMt5Snapshot({
    required this.accountBalance,
    required this.equity,
    required this.totalClosedPnl,
    required this.winRate,
    required this.avgRPerTrade,
    required this.bestR,
    required this.worstR,
    required this.profitFactor,
    required this.todayTradeCount,
    required this.maxTradesPerDay,
    required this.todayClosedPnl,
    required this.maxDailyLoss,
    required this.dailyTarget,
    required this.disciplineScore,
    required this.performanceScore,
    required this.consistencyScore,
    required this.maxLossViolations,
    required this.profitTargetViolations,
    required this.maxLossReached,
    required this.bestSymbol,
    required this.worstSymbol,
  });

  factory DashboardMt5Snapshot.fromMt5({
    required Mt5Account account,
    required List<Mt5Position> positions,
    required Mt5PerformanceSummary summary,
  }) {
    final openPnl = positions.fold<double>(
      0,
      (total, position) => total + position.profit,
    );
    final tradeCount = summary.tradeCount == 0 ? 1 : summary.tradeCount;
    final avgR = summary.netPnl / tradeCount / 100;
    final maxDailyLoss = account.balance * 0.02;
    final dailyTarget = account.balance * 0.04;
    final todayClosedPnl = summary.netPnl;
    final maxLossReached = todayClosedPnl <= -maxDailyLoss;
    final performanceScore = summary.profitFactor >= 2
        ? 36
        : (summary.profitFactor * 18).clamp(0, 40).round();
    final consistencyScore = (100 - summary.maxDrawdown * 7)
        .clamp(0, 20)
        .round();
    final maxLossViolations = maxLossReached ? 1 : 0;
    final profitTargetViolations = todayClosedPnl >= dailyTarget ? 0 : 1;
    final disciplineScore =
        (100 -
                maxLossViolations * 18 -
                profitTargetViolations * 8 -
                (positions.length > 5 ? 10 : 0))
            .clamp(0, 100)
            .round();

    return DashboardMt5Snapshot(
      accountBalance: account.balance,
      equity: account.equity,
      totalClosedPnl: summary.netPnl,
      winRate: summary.winRate,
      avgRPerTrade: avgR,
      bestR: 2.33,
      worstR: -1.00,
      profitFactor: summary.profitFactor,
      todayTradeCount: positions.length,
      maxTradesPerDay: 5,
      todayClosedPnl: todayClosedPnl + openPnl,
      maxDailyLoss: maxDailyLoss,
      dailyTarget: dailyTarget,
      disciplineScore: disciplineScore,
      performanceScore: performanceScore,
      consistencyScore: consistencyScore,
      maxLossViolations: maxLossViolations,
      profitTargetViolations: profitTargetViolations,
      maxLossReached: maxLossReached,
      bestSymbol: summary.bestSymbol,
      worstSymbol: summary.worstSymbol,
    );
  }

  factory DashboardMt5Snapshot.sample() {
    return const DashboardMt5Snapshot(
      accountBalance: 18427.59,
      equity: 15142.19,
      totalClosedPnl: -3285.40,
      winRate: 28.21,
      avgRPerTrade: 0.42,
      bestR: 2.33,
      worstR: -1.00,
      profitFactor: 1.15,
      todayTradeCount: 5,
      maxTradesPerDay: 5,
      todayClosedPnl: -3285.40,
      maxDailyLoss: 3000,
      dailyTarget: 10000,
      disciplineScore: 64,
      performanceScore: 26,
      consistencyScore: 6,
      maxLossViolations: 1,
      profitTargetViolations: 1,
      maxLossReached: true,
      bestSymbol: 'XAUUSD',
      worstSymbol: 'EURUSD',
    );
  }

  String get riskMessage {
    if (maxLossReached) {
      return 'Max daily loss is reached - stop trading and review your journal before the next session.';
    }
    if (totalClosedPnl < 0) {
      return 'Closed PnL is negative this month - reduce size and review weak setups, especially $worstSymbol.';
    }
    return 'Positive month so far - best performance is coming from $bestSymbol. Keep risk consistent.';
  }
}

String dashboardMoney(double value) {
  final sign = value < 0 ? '-' : '';
  return '$sign\$${value.abs().toStringAsFixed(2)}';
}
