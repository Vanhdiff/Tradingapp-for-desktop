import 'package:fluent_ui/fluent_ui.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../mt5/data/datasources/mt5_remote_datasource.dart';
import '../../../mt5/domain/entities/mt5_account.dart';
import '../../../mt5/domain/entities/mt5_performance_summary.dart';
import '../../../mt5/domain/entities/mt5_position.dart';
import '../models/dashboard_mt5_snapshot.dart';
import '../widgets/dashboard_top_metrics.dart';
import '../widgets/discipline_panel.dart';
import '../widgets/equity_chart.dart';
import '../widgets/recent_trades_table.dart';
import '../widgets/rule_break_panel.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final Mt5RemoteDataSource _mt5RemoteDataSource = Mt5RemoteDataSource();

  DashboardMt5Snapshot _snapshot = DashboardMt5Snapshot.sample();
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadMt5Snapshot();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final horizontalPadding = 22.0;
        final contentWidth = constraints.maxWidth - horizontalPadding * 2;
        final targetWidth = contentWidth * 0.9;
        final pageWidth = targetWidth < 1120 ? 1120.0 : targetWidth;
        final scrollWidth = pageWidth > contentWidth ? pageWidth : contentWidth;

        return SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(
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
                      _DashboardHeader(
                        isLoading: _isLoading,
                        errorMessage: _errorMessage,
                      ),
                      SizedBox(height: 14),
                      DashboardTopMetrics(snapshot: _snapshot),
                      SizedBox(height: 10),
                      _RiskCoachBanner(snapshot: _snapshot),
                      SizedBox(height: 12),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(flex: 8, child: EquityChart()),
                          SizedBox(width: 14),
                          Expanded(
                            flex: 5,
                            child: DisciplinePanel(snapshot: _snapshot),
                          ),
                        ],
                      ),
                      SizedBox(height: 12),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(flex: 8, child: RecentTradesTable()),
                          SizedBox(width: 14),
                          Expanded(
                            flex: 5,
                            child: RuleBreakPanel(snapshot: _snapshot),
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

  Future<void> _loadMt5Snapshot() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final results = await Future.wait([
        _mt5RemoteDataSource.fetchAccount(),
        _mt5RemoteDataSource.fetchPositions(),
        _mt5RemoteDataSource.fetchPerformanceSummary(period: 'month'),
      ]);

      if (!mounted) return;
      setState(() {
        _snapshot = DashboardMt5Snapshot.fromMt5(
          account: results[0] as Mt5Account,
          positions: results[1] as List<Mt5Position>,
          summary: results[2] as Mt5PerformanceSummary,
        );
        _isLoading = false;
      });
    } catch (error) {
      if (!mounted) return;
      setState(() {
        _snapshot = DashboardMt5Snapshot.sample();
        _isLoading = false;
        _errorMessage = 'MT5 backend offline - showing sample analytics';
      });
    }
  }
}

class _DashboardHeader extends StatelessWidget {
  final bool isLoading;
  final String? errorMessage;

  const _DashboardHeader({required this.isLoading, required this.errorMessage});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          'Dashboard',
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.w800,
            color: AppColors.textPrimary,
          ),
        ),
        SizedBox(width: 14),
        Expanded(
          child: Text(
            _subtitle,
            style: TextStyle(
              fontSize: 11,
              color: errorMessage == null
                  ? AppColors.textSecondary
                  : AppColors.warning,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        _TimeRangeFilter(),
      ],
    );
  }

  String get _subtitle {
    if (isLoading) {
      return 'Loading MT5 account, positions, and performance analytics...';
    }
    if (errorMessage != null) return errorMessage!;
    return 'MT5 analytics connected — account, risk, and performance are calculated from broker data.';
  }
}

class _TimeRangeFilter extends StatelessWidget {
  const _TimeRangeFilter();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _RangeButton('Day'),
        SizedBox(width: 6),
        _RangeButton('Week'),
        SizedBox(width: 6),
        _RangeButton('14 D'),
        SizedBox(width: 6),
        _RangeButton('30 D', selected: true),
      ],
    );
  }
}

class _RangeButton extends StatelessWidget {
  final String label;
  final bool selected;

  const _RangeButton(this.label, {this.selected = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: selected ? AppColors.primary : AppColors.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: selected ? AppColors.primary : AppColors.border,
        ),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w700,
          color: selected ? Colors.white : AppColors.textSecondary,
        ),
      ),
    );
  }
}

class _RiskCoachBanner extends StatelessWidget {
  final DashboardMt5Snapshot snapshot;

  const _RiskCoachBanner({required this.snapshot});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 38,
      padding: EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: AppColors.danger.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.danger.withValues(alpha: 0.20)),
      ),
      child: Row(
        children: [
          Icon(FluentIcons.error_badge, size: 15, color: AppColors.danger),
          SizedBox(width: 8),
          Expanded(
            child: Text(
              snapshot.riskMessage,
              style: TextStyle(
                fontSize: 11,
                color: Color(0xFFA46A82),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
