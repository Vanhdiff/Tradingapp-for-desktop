import 'package:fluent_ui/fluent_ui.dart';
import '../../../../app/theme/app_colors.dart';

class RuleBreakPanel extends StatelessWidget {
  const RuleBreakPanel({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 220,
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
            children: [
              const Text(
                "Today's rule breaks",
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              const Spacer(),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFF3EEFF),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Text(
                  'Modify guardrails',
                  style: TextStyle(
                    fontSize: 9,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              const Text('Trades:', style: TextStyle(fontSize: 10)),
              const SizedBox(width: 4),
              const Text(
                '5 / 5',
                style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700),
              ),
              const SizedBox(width: 8),
              ...List.generate(
                5,
                (i) => Container(
                  width: 6,
                  height: 6,
                  margin: EdgeInsets.only(right: i == 4 ? 0 : 4),
                  decoration: BoxDecoration(
                    color: AppColors.success,
                    borderRadius: BorderRadius.circular(999),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: const [
              Expanded(
                child: Text(
                  'Trading Window 14:00-18:00 (SGT)',
                  style: TextStyle(fontSize: 9, color: AppColors.textSecondary),
                ),
              ),
              Text(
                'Open',
                style: TextStyle(
                  fontSize: 9,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          const Text(
            "Today's Closed PnL",
            style: TextStyle(fontSize: 9, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 6),
          const Align(
            alignment: Alignment.centerRight,
            child: Text(
              r'-$3,285.40',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: AppColors.danger,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Container(
            height: 6,
            decoration: BoxDecoration(
              color: const Color(0xFFF3EEF8),
              borderRadius: BorderRadius.circular(999),
            ),
            child: Row(
              children: [
                Expanded(
                  flex: 7,
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFFFF8A8A),
                      borderRadius: BorderRadius.circular(999),
                    ),
                  ),
                ),
                const Expanded(flex: 3, child: SizedBox()),
              ],
            ),
          ),
          const SizedBox(height: 6),
          const Row(
            children: [
              Text('-3K', style: TextStyle(fontSize: 8, color: AppColors.textSecondary)),
              Spacer(),
              Text('+10K', style: TextStyle(fontSize: 8, color: AppColors.textSecondary)),
            ],
          ),
          const Spacer(),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFFFFF1F1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Text(
              'Max Loss is reached!',
              style: TextStyle(
                fontSize: 10,
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