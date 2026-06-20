import 'package:fluent_ui/fluent_ui.dart';
import '../widgets/dashboard_top_metrics.dart';
import '../widgets/discipline_panel.dart';
import '../widgets/equity_chart.dart';
import '../widgets/recent_trades_table.dart';
import '../widgets/rule_break_panel.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(14, 10, 14, 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const DashboardTopMetrics(),
          const SizedBox(height: 8),
          Container(
            width: double.infinity,
            height: 38,
            padding: const EdgeInsets.symmetric(horizontal: 14),
            decoration: BoxDecoration(
              color: const Color(0xFFFFF2F5),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFF2E2E8)),
              boxShadow: [
                BoxShadow(
                  color: const Color(0x11000000),
                  blurRadius: 18,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Row(
              children: const [
                Icon(FluentIcons.info, size: 12, color: Color(0xFFE38AAA)),
                SizedBox(width: 6),
                Expanded(
                  child: Text(
                    'You are down 17% this month — review your journal, and rebuild from risk management basics.',
                    style: TextStyle(
                      fontSize: 10.5,
                      color: Color(0xFFA46A82),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          const Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(flex: 8, child: EquityChart()),
              SizedBox(width: 12),
              Expanded(flex: 4, child: DisciplinePanel()),
            ],
          ),
          const SizedBox(height: 10),
          const Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(flex: 8, child: RecentTradesTable()),
              SizedBox(width: 12),
              Expanded(flex: 4, child: RuleBreakPanel()),
            ],
          ),
        ],
      ),
    );
  }
}
