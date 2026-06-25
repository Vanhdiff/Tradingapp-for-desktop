import 'package:fluent_ui/fluent_ui.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../guardrails/presentation/widgets/guardrails_dialog.dart';
import '../models/dashboard_mt5_snapshot.dart';

class RuleBreakPanel extends StatelessWidget {
  final DashboardMt5Snapshot snapshot;

  const RuleBreakPanel({super.key, required this.snapshot});

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(minHeight: 310),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: Color(0x12000000),
            blurRadius: 24,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _PanelHeader(),
          SizedBox(height: 14),
          _TradesProgress(snapshot: snapshot),
          SizedBox(height: 11),
          _TradingWindowRow(),
          SizedBox(height: 14),
          _ClosedPnlSection(snapshot: snapshot),
          SizedBox(height: 12),
          _LossProgressBar(snapshot: snapshot),
          SizedBox(height: 7),
          _LimitLabels(snapshot: snapshot),
          SizedBox(height: 14),
          _MaxLossAlert(snapshot: snapshot),
        ],
      ),
    );
  }
}

class _PanelHeader extends StatelessWidget {
  const _PanelHeader();

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 12,
      runSpacing: 10,
      alignment: WrapAlignment.spaceBetween,
      crossAxisAlignment: WrapCrossAlignment.start,
      children: [
        ConstrainedBox(
          constraints: BoxConstraints(minWidth: 190, maxWidth: 280),
          child: _PanelTitle(),
        ),
        GestureDetector(
          onTap: () => showGuardrailsDialog(context),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 13, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.primarySoft,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Text(
              'Modify guardrails',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: AppColors.primary,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _PanelTitle extends StatelessWidget {
  const _PanelTitle();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Today's rule breaks",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w800,
            color: AppColors.textPrimary,
          ),
        ),
        SizedBox(height: 6),
        Text(
          "Quick summary of today's trading rules and loss status",
          style: TextStyle(
            fontSize: 11,
            color: AppColors.textSecondary,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

class _TradesProgress extends StatelessWidget {
  final DashboardMt5Snapshot snapshot;

  const _TradesProgress({required this.snapshot});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 6,
      runSpacing: 8,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        Text(
          'Trades:',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: AppColors.textSecondary,
          ),
        ),
        Text(
          '${snapshot.todayTradeCount} / ${snapshot.maxTradesPerDay}',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w800,
            color: AppColors.textPrimary,
          ),
        ),
        SizedBox(width: 6),
        ...List.generate(
          5,
          (i) => Container(
            width: 8,
            height: 8,
            margin: EdgeInsets.only(right: i == 4 ? 0 : 6),
            decoration: BoxDecoration(
              color: i < snapshot.todayTradeCount
                  ? AppColors.success
                  : AppColors.border,
              borderRadius: BorderRadius.circular(999),
            ),
          ),
        ),
      ],
    );
  }
}

class _TradingWindowRow extends StatelessWidget {
  const _TradingWindowRow();

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 12,
      runSpacing: 6,
      alignment: WrapAlignment.spaceBetween,
      children: [
        Text(
          'Trading Window 14:00-18:00 (SGT)',
          style: TextStyle(fontSize: 11, color: AppColors.textSecondary),
        ),
        Text(
          'Open',
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w700,
            color: AppColors.primary,
          ),
        ),
      ],
    );
  }
}

class _ClosedPnlSection extends StatelessWidget {
  final DashboardMt5Snapshot snapshot;

  const _ClosedPnlSection({required this.snapshot});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Today's Closed PnL",
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w700,
            color: AppColors.textSecondary,
          ),
        ),
        SizedBox(height: 7),
        Row(
          children: [
            Expanded(
              child: FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.centerLeft,
                child: Text(
                  dashboardMoney(snapshot.todayClosedPnl),
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.w800,
                    color: snapshot.todayClosedPnl < 0
                        ? AppColors.danger
                        : AppColors.success,
                  ),
                ),
              ),
            ),
            SizedBox(width: 10),
            Icon(FluentIcons.info, size: 15, color: AppColors.textSecondary),
          ],
        ),
      ],
    );
  }
}

class _LossProgressBar extends StatelessWidget {
  final DashboardMt5Snapshot snapshot;

  const _LossProgressBar({required this.snapshot});

  @override
  Widget build(BuildContext context) {
    final lossUsed = snapshot.todayClosedPnl < 0
        ? (snapshot.todayClosedPnl.abs() / snapshot.maxDailyLoss).clamp(
            0.0,
            1.0,
          )
        : 0.0;

    return ClipRRect(
      borderRadius: BorderRadius.circular(999),
      child: Container(
        height: 10,
        color: AppColors.danger.withValues(alpha: 0.14),
        child: Align(
          alignment: Alignment.centerLeft,
          child: FractionallySizedBox(
            widthFactor: lossUsed,
            child: ColoredBox(
              color: snapshot.maxLossReached
                  ? Color(0xFFFF7B7F)
                  : AppColors.warning,
            ),
          ),
        ),
      ),
    );
  }
}

class _LimitLabels extends StatelessWidget {
  final DashboardMt5Snapshot snapshot;

  const _LimitLabels({required this.snapshot});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 16,
      runSpacing: 4,
      alignment: WrapAlignment.spaceBetween,
      children: [
        Text(
          'Max loss  ${dashboardMoney(snapshot.maxDailyLoss)}',
          style: TextStyle(
            fontSize: 10,
            color: AppColors.textSecondary,
            fontWeight: FontWeight.w600,
          ),
        ),
        Text(
          'Daily Target  ${dashboardMoney(snapshot.dailyTarget)}',
          style: TextStyle(
            fontSize: 10,
            color: AppColors.textSecondary,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

class _MaxLossAlert extends StatelessWidget {
  final DashboardMt5Snapshot snapshot;

  const _MaxLossAlert({required this.snapshot});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: (snapshot.maxLossReached ? AppColors.danger : AppColors.success)
            .withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Icon(
            snapshot.maxLossReached
                ? FluentIcons.error_badge
                : FluentIcons.check_mark,
            size: 14,
            color: snapshot.maxLossReached
                ? AppColors.danger
                : AppColors.success,
          ),
          SizedBox(width: 8),
          Expanded(
            child: Text(
              snapshot.maxLossReached
                  ? 'Max Loss is reached!'
                  : 'Risk guardrails are within limits.',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: snapshot.maxLossReached
                    ? AppColors.danger
                    : AppColors.success,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
