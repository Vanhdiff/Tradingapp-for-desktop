import '../../domain/entities/dashboard_summary.dart';

class DashboardState {
  final DashboardSummary summary;

  const DashboardState({required this.summary});

  factory DashboardState.mock() {
    return const DashboardState(
      summary: DashboardSummary(
        accountBalance: 18427.59,
        closedPnl: -3285.40,
        winRate: 28.21,
        profitFactor: 1.15,
        avgR: 0.42,
      ),
    );
  }
}
