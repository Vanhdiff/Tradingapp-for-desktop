import 'package:fluent_ui/fluent_ui.dart';
import '../../../../app/theme/app_colors.dart';

class RecentTradesTable extends StatelessWidget {
  const RecentTradesTable({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 250,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFEEE8F8)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Text(
                'Recent Trades',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              Spacer(),
              Text(
                'All Trades >',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          const Row(
            children: [
              Expanded(flex: 2, child: _Header('Instrument')),
              Expanded(child: _Header('Direction')),
              Expanded(child: _Header('P/L')),
              Expanded(child: _Header('Outcome')),
              Expanded(flex: 2, child: _Header('Closed At')),
            ],
          ),
          const SizedBox(height: 6),
          const Divider(style: DividerThemeData(thickness: 1)),
          const _TradeRow('EURUSD', 'Sell', r'-$1,500.00', 'Loss', 'Today, 11:15 AM'),
          const _TradeRow('GBPJPY', 'Sell', r'-$1,250.00', 'Loss', 'Today, 10:48 AM'),
          const _TradeRow('XAUUSD', 'Sell', r'-$600.00', 'Loss', 'Today, 10:05 AM'),
          const _TradeRow('AUDUSD', 'Buy', r'+$64.60', 'Win', 'Today, 9:42 AM'),
          const _TradeRow('USDCAD', 'Sell', r'$0.00', 'BE', 'Today, 9:12 AM'),
        ],
      ),
    );
  }
}

class _Header extends StatelessWidget {
  final String text;
  const _Header(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 9,
        color: AppColors.textSecondary,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}

class _TradeRow extends StatelessWidget {
  final String instrument;
  final String direction;
  final String pnl;
  final String outcome;
  final String closedAt;

  const _TradeRow(
    this.instrument,
    this.direction,
    this.pnl,
    this.outcome,
    this.closedAt,
  );

  @override
  Widget build(BuildContext context) {
    final isBuy = direction == 'Buy';
    final isLoss = outcome == 'Loss';
    final isWin = outcome == 'Win';

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Row(
              children: [
                const _PairDot(),
                const SizedBox(width: 8),
                Text(
                  instrument,
                  style: const TextStyle(fontSize: 11),
                ),
              ],
            ),
          ),
          Expanded(
            child: Text(
              '${isBuy ? '↑' : '↓'} $direction',
              style: TextStyle(
                fontSize: 11,
                color: isBuy ? AppColors.success : AppColors.danger,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Expanded(
            child: Text(
              pnl,
              style: TextStyle(
                fontSize: 11,
                color: pnl.startsWith('+')
                    ? AppColors.success
                    : pnl.startsWith('-')
                        ? AppColors.danger
                        : AppColors.textPrimary,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          Expanded(
            child: Align(
              alignment: Alignment.centerLeft,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: isWin
                      ? const Color(0xFFEAF8F1)
                      : isLoss
                          ? const Color(0xFFFFEEEE)
                          : const Color(0xFFF1F1F4),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  outcome,
                  style: TextStyle(
                    fontSize: 9,
                    fontWeight: FontWeight.w700,
                    color: isWin
                        ? AppColors.success
                        : isLoss
                            ? AppColors.danger
                            : AppColors.textSecondary,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              closedAt,
              style: const TextStyle(
                fontSize: 10,
                color: AppColors.textSecondary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PairDot extends StatelessWidget {
  const _PairDot();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 22,
      height: 14,
      child: Stack(
        children: [
          Positioned(
            left: 0,
            child: Container(
              width: 13,
              height: 13,
              decoration: BoxDecoration(
                color: const Color(0xFF2979FF),
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 1),
              ),
            ),
          ),
          Positioned(
            left: 9,
            child: Container(
              width: 13,
              height: 13,
              decoration: BoxDecoration(
                color: const Color(0xFFE53935),
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 1),
              ),
            ),
          ),
        ],
      ),
    );
  }
}