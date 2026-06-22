import 'package:fluent_ui/fluent_ui.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../shared/widgets/app_panel.dart';
import 'journal_shared_widgets.dart';

class JournalReviewPanel extends StatelessWidget {
  final TextEditingController reflectionController;
  final bool followedPlan;
  final ValueChanged<bool> onFollowedPlanChanged;
  final String entryPlan;
  final List<String> plans;
  final ValueChanged<String> onEntryPlanChanged;
  final String entryConfluence;
  final List<String> confluences;
  final ValueChanged<String> onEntryConfluenceChanged;
  final String entryEmotion;
  final String exitEmotion;
  final List<String> emotions;
  final ValueChanged<String> onEntryEmotionChanged;
  final ValueChanged<String> onExitEmotionChanged;

  const JournalReviewPanel({
    super.key,
    required this.reflectionController,
    required this.followedPlan,
    required this.onFollowedPlanChanged,
    required this.entryPlan,
    required this.plans,
    required this.onEntryPlanChanged,
    required this.entryConfluence,
    required this.confluences,
    required this.onEntryConfluenceChanged,
    required this.entryEmotion,
    required this.exitEmotion,
    required this.emotions,
    required this.onEntryEmotionChanged,
    required this.onExitEmotionChanged,
  });

  @override
  Widget build(BuildContext context) {
    return AppPanel(
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Review & Reflection',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: _PlanCheckbox(this)),
              const SizedBox(width: 16),
              Expanded(
                child: JournalComboField(
                  label: 'Which plan did you intend to follow?',
                  value: entryPlan,
                  items: plans,
                  onChanged: onEntryPlanChanged,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: JournalComboField(
                  label: 'Entry Confluences',
                  value: entryConfluence,
                  items: confluences,
                  onChanged: onEntryConfluenceChanged,
                ),
              ),
              const SizedBox(width: 16),
              const Expanded(child: _TradeManagementField()),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Expanded(child: _MistakesField()),
              const SizedBox(width: 16),
              Expanded(
                child: Row(
                  children: [
                    Expanded(
                      child: JournalComboField(
                        label: 'Entry emotion',
                        value: entryEmotion,
                        items: emotions,
                        onChanged: onEntryEmotionChanged,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: JournalComboField(
                        label: 'Exit Emotion',
                        value: exitEmotion,
                        items: emotions,
                        onChanged: onExitEmotionChanged,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          const JournalSectionLabel('Add a note or voice reflection'),
          SizedBox(
            height: 170,
            child: TextBox(
              controller: reflectionController,
              maxLines: null,
              placeholder: 'Write your reflection here...',
            ),
          ),
        ],
      ),
    );
  }
}

class _PlanCheckbox extends StatelessWidget {
  final JournalReviewPanel panel;

  const _PlanCheckbox(this.panel);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const JournalSectionLabel('Plan'),
        Row(
          children: [
            Checkbox(
              checked: panel.followedPlan,
              onChanged: (value) {
                if (value != null) {
                  panel.onFollowedPlanChanged(value);
                }
              },
            ),
            const Expanded(child: Text('I followed my trade plan')),
          ],
        ),
      ],
    );
  }
}

class _TradeManagementField extends StatelessWidget {
  const _TradeManagementField();

  @override
  Widget build(BuildContext context) {
    return JournalFieldShell(
      label: 'Trade Management',
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: const [
          JournalMiniTag('Partials 1R/2R'),
          JournalMiniTag('SL to BE'),
        ],
      ),
    );
  }
}

class _MistakesField extends StatelessWidget {
  const _MistakesField();

  @override
  Widget build(BuildContext context) {
    return JournalFieldShell(
      label: 'Mistakes',
      child: Row(
        children: const [
          JournalMiniTag('Added to Position', removable: true),
          Spacer(),
          Icon(FluentIcons.cancel, size: 14, color: AppColors.textSecondary),
        ],
      ),
    );
  }
}
