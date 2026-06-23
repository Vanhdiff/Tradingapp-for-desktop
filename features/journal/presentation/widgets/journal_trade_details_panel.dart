import 'package:fluent_ui/fluent_ui.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../shared/widgets/app_panel.dart';

class JournalTradeDetailsPanel extends StatelessWidget {
  final String netPnl;
  final String instrument;
  final String direction;
  final String lotSize;

  JournalTradeDetailsPanel({
    super.key,
    required this.netPnl,
    required this.instrument,
    required this.direction,
    required this.lotSize,
  });

  @override
  Widget build(BuildContext context) {
    return AppPanel(
      padding: EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Trade details',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
          ),
          SizedBox(height: 26),
          Text(
            netPnl,
            style: TextStyle(
              color: AppColors.success,
              fontSize: 31,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: 6),
          Text(
            'NET PNL',
            style: TextStyle(color: AppColors.textSecondary, fontSize: 11),
          ),
          SizedBox(height: 24),
          Row(
            children: [
              Expanded(child: _TradeMetric(instrument, 'INSTRUMENT')),
              Expanded(child: _TradeMetric(direction, 'DIRECTION')),
              Expanded(child: _TradeMetric(lotSize, 'LOT SIZE')),
            ],
          ),
          SizedBox(height: 22),
          _BrokerCallout(),
          SizedBox(height: 16),
          _DetailsSection('Context', [
            _DetailRow('Session', 'London'),
            _DetailRow('Duration', '1 hr 55 min'),
          ]),
          SizedBox(height: 14),
          _DetailsSection('Execution', [
            _DetailRow('Entry / Exit Price', '1.0790 / 1.0840'),
            _DetailRow('Stop Loss', '1.0770'),
            _DetailRow('Take Profit', '1.0840'),
          ]),
          SizedBox(height: 14),
          _DetailsSection('Performance', [
            _DetailRow('Risk (R)', '1.00R'),
            _DetailRow('Return (R)', '+1.33R'),
          ]),
          SizedBox(height: 14),
          _DetailsSection('Costs', [
            _DetailRow('Fees', '-\$21.00'),
            _DetailRow('Swap', '\$0.00', valueColor: AppColors.textSecondary),
          ]),
        ],
      ),
    );
  }
}

class _BrokerCallout extends StatelessWidget {
  _BrokerCallout();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        'Trades auto-import from your broker',
        style: TextStyle(
          color: Colors.white,
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _TradeMetric extends StatelessWidget {
  final String value;
  final String label;

  _TradeMetric(this.value, this.label);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          value,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
        ),
        SizedBox(height: 7),
        Text(
          label,
          style: TextStyle(
            color: AppColors.textSecondary,
            fontSize: 10,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

class _DetailsSection extends StatelessWidget {
  final String title;
  final List<Widget> children;

  _DetailsSection(this.title, this.children);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            color: AppColors.primary,
            fontSize: 11,
            fontWeight: FontWeight.w700,
          ),
        ),
        SizedBox(height: 8),
        ...children,
      ],
    );
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;

  _DetailRow(this.label, this.value, {this.valueColor});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 13,
              ),
            ),
          ),
          Text(
            value,
            style: TextStyle(
              color: valueColor ?? AppColors.textPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
