import 'package:fluent_ui/fluent_ui.dart';

import '../../../../app/theme/app_colors.dart';

class RuleBreakPanel extends StatelessWidget {
  RuleBreakPanel({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(minHeight: 310),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Color(0xFFEEE8F8)),
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
          _TradesProgress(),
          SizedBox(height: 11),
          _TradingWindowRow(),
          SizedBox(height: 14),
          _ClosedPnlSection(),
          SizedBox(height: 12),
          _LossProgressBar(),
          SizedBox(height: 7),
          _LimitLabels(),
          SizedBox(height: 14),
          _MaxLossAlert(),
        ],
      ),
    );
  }
}

class _PanelHeader extends StatelessWidget {
  _PanelHeader();

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
        Container(
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
      ],
    );
  }
}

class _PanelTitle extends StatelessWidget {
  _PanelTitle();

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
  _TradesProgress();

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
          '5 / 5',
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
              color: AppColors.success,
              borderRadius: BorderRadius.circular(999),
            ),
          ),
        ),
      ],
    );
  }
}

class _TradingWindowRow extends StatelessWidget {
  _TradingWindowRow();

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
  _ClosedPnlSection();

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
                  r'-$3,285.40',
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.w800,
                    color: AppColors.danger,
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
  _LossProgressBar();

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(999),
      child: Container(
        height: 10,
        color: Color(0xFFFFE6E8),
        child: Align(
          alignment: Alignment.centerLeft,
          child: FractionallySizedBox(
            widthFactor: 0.70,
            child: ColoredBox(color: Color(0xFFFF7B7F)),
          ),
        ),
      ),
    );
  }
}

class _LimitLabels extends StatelessWidget {
  _LimitLabels();

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 16,
      runSpacing: 4,
      alignment: WrapAlignment.spaceBetween,
      children: [
        Text(
          'Max loss  \$3,000',
          style: TextStyle(
            fontSize: 10,
            color: AppColors.textSecondary,
            fontWeight: FontWeight.w600,
          ),
        ),
        Text(
          'Daily Target  \$10,000',
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
  _MaxLossAlert();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Color(0xFFFFF1F1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Icon(FluentIcons.error_badge, size: 14, color: AppColors.danger),
          SizedBox(width: 8),
          Expanded(
            child: Text(
              'Max Loss is reached!',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: AppColors.danger,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
