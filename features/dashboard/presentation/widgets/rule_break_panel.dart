import 'package:fluent_ui/fluent_ui.dart';
import '../../../../app/theme/app_colors.dart';

class RuleBreakPanel extends StatelessWidget {
  const RuleBreakPanel({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 330,
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: const Color(0xFFEEE8F8)),
        boxShadow: [
          BoxShadow(
            color: const Color(0x12000000),
            blurRadius: 28,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
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
                      'Quick summary of today’s trading rules and loss status',
                      style: TextStyle(
                        fontSize: 11,
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFF3EEFF),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Text(
                  'Modify guardrails',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              const Text(
                'Trades:',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(width: 6),
              const Text(
                '5 / 5',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(width: 12),
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
          ),
          const SizedBox(height: 12),
          Row(
            children: const [
              Expanded(
                child: Text(
                  'Trading Window 14:00-18:00 (SGT)',
                  style: TextStyle(
                    fontSize: 10,
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
              Text(
                'Open',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Text(
            "Today's Closed PnL",
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: const [
              Text(
                r'-$3,285.40',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w800,
                  color: AppColors.danger,
                ),
              ),
              Spacer(),
              Icon(FluentIcons.info, size: 16, color: AppColors.textSecondary),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            height: 10,
            decoration: BoxDecoration(
              color: const Color(0xFFFFE9E9),
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
          const SizedBox(height: 10),
          const Row(
            children: [
              Text(
                '-3K',
                style: TextStyle(fontSize: 10, color: AppColors.textSecondary),
              ),
              Spacer(),
              Text(
                '+10K',
                style: TextStyle(fontSize: 10, color: AppColors.textSecondary),
              ),
            ],
          ),
          const Spacer(),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              color: const Color(0xFFFFF1F1),
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Text(
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
