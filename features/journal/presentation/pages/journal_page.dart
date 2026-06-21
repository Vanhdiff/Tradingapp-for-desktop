import 'package:fluent_ui/fluent_ui.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../shared/widgets/app_panel.dart';

class JournalPage extends StatefulWidget {
  const JournalPage({super.key});

  @override
  State<JournalPage> createState() => _JournalPageState();
}

class _JournalPageState extends State<JournalPage> {
  final TextEditingController _reflectionController = TextEditingController();
  String _entryConfluence = 'Trailing Stop Loss';
  bool _followedPlan = true;

  final List<String> _confluences = [
    'Trailing Stop Loss',
    'Breakout + Pullback',
    'Mean reversion',
  ];

  @override
  void dispose() {
    _reflectionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Journal',
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 20),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      flex: 2,
                      child: AppPanel(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: const [
                                      Text(
                                        'EURUSD · ↑ Buy · Mon, Dec 8, 2025',
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                      SizedBox(height: 12),
                                      Text(
                                        'Trades auto-import from your broker',
                                        style: TextStyle(
                                          fontSize: 13,
                                          color: AppColors.primary,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 8,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppColors.primarySoft,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: const Text(
                                    '+\$1,329.00\nNET PNL',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w700,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 18),
                            Wrap(
                              spacing: 12,
                              runSpacing: 12,
                              children: [
                                _metricBadge('INSTRUMENT', 'EURUSD'),
                                _metricBadge('DIRECTION', 'Buy'),
                                _metricBadge('LOT SIZE', '3.00'),
                              ],
                            ),
                            const SizedBox(height: 18),
                            Row(
                              children: [
                                Expanded(child: _infoColumn()),
                                const SizedBox(width: 16),
                                Expanded(child: _performanceColumn()),
                              ],
                            ),
                            const SizedBox(height: 18),
                            Row(
                              children: [
                                Expanded(child: _chartPlaceholder('MTF')),
                                const SizedBox(width: 16),
                                Expanded(child: _chartPlaceholder('HTF')),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: AppPanel(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: const [
                                Expanded(
                                  child: Text(
                                    'Closed PnL',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                Text(
                                  '+\$500.00',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.success,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            const Text(
                              'EURUSD trade closed. How do you feel right now?',
                              style: TextStyle(
                                color: AppColors.textSecondary,
                                fontSize: 12,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Wrap(
                              spacing: 10,
                              runSpacing: 10,
                              children: [
                                _emotionButton('😄'),
                                _emotionButton('🙂'),
                                _emotionButton('😐'),
                                _emotionButton('😟'),
                                _emotionButton('🏆'),
                              ],
                            ),
                            const SizedBox(height: 16),
                            Row(
                              children: [
                                Checkbox(
                                  checked: _followedPlan,
                                  onChanged: (value) {
                                    if (value != null) {
                                      setState(() => _followedPlan = value);
                                    }
                                  },
                                ),
                                const Expanded(
                                  child: Text('I followed my trade plan'),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            Container(
                              height: 120,
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: AppColors.shellBg,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: TextBox(
                                controller: _reflectionController,
                                placeholder: 'Add a note or voice reflection',
                                expands: true,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Row(
                              children: [
                                Expanded(
                                  child: FilledButton(
                                    onPressed: () {},
                                    child: const Text('Save'),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Button(
                                    onPressed: () {},
                                    child: const Text('Go to Journal'),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 2,
                    child: Column(
                      children: [
                        AppPanel(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Review & Reflection',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 16),
                              _sectionLabel('Plan'),
                              _checkItem(
                                'I followed my trade plan',
                                _followedPlan,
                              ),
                              const SizedBox(height: 14),
                              _sectionLabel('Entry Confluences'),
                              ComboBox<String>(
                                value: _entryConfluence,
                                items: _confluences
                                    .map(
                                      (value) => ComboBoxItem(
                                        value: value,
                                        child: Text(value),
                                      ),
                                    )
                                    .toList(),
                                onChanged: (value) {
                                  if (value != null) {
                                    setState(() => _entryConfluence = value);
                                  }
                                },
                              ),
                              const SizedBox(height: 14),
                              _sectionLabel('Mistakes'),
                              _tagItem('Added to Position'),
                              const SizedBox(height: 14),
                              _sectionLabel('Add a note or voice reflection'),
                              const SizedBox(height: 8),
                              TextBox(
                                controller: _reflectionController,
                                maxLines: 5,
                                placeholder: 'Write your reflection here...',
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                        AppPanel(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'AI Analysis',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 16),
                              _analysisRow(
                                title: 'What Worked',
                                description:
                                    'Sticking to EURUSD London session with full routine. Risk per trade stayed within limits.',
                                color: AppColors.success,
                              ),
                              const SizedBox(height: 14),
                              _analysisRow(
                                title: 'What Didn’t Work',
                                description:
                                    'Overtrading after missed moves (Thu). Trading while rushed led to forced entries (Tue).',
                                color: AppColors.danger,
                              ),
                              const SizedBox(height: 16),
                              _sectionLabel('Next week focus'),
                              const Text(
                                'No routine = no trade. If you skip the routine, you don’t earn the right to click buy/sell.',
                                style: TextStyle(
                                  color: AppColors.textSecondary,
                                  height: 1.4,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: AppPanel(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            'Summary',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(height: 12),
                          Text(
                            'Session: London\nDuration: 1 hr 55 min\nExecution: 1.0790 / 1.0840\nStop Loss: 1.0770\nTake Profit: 1.0840',
                            style: TextStyle(
                              color: AppColors.textSecondary,
                              height: 1.6,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _metricBadge(String title, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.shellBg,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }

  Widget _infoColumn() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _detailRow('Session', 'London'),
        const SizedBox(height: 10),
        _detailRow('Duration', '1 hr 55 min'),
        const SizedBox(height: 10),
        _detailRow('Execution', '1.0790 — 1.0840'),
        const SizedBox(height: 10),
        _detailRow('Stop Loss', '1.0770'),
      ],
    );
  }

  Widget _performanceColumn() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _detailRow('Take Profit', '1.0840'),
        const SizedBox(height: 10),
        _detailRow('Risk (R)', '1.00R'),
        const SizedBox(height: 10),
        _detailRow('Return (R)', '+1.33R'),
        const SizedBox(height: 10),
        _detailRow('Fees', '-\$21.00'),
      ],
    );
  }

  Widget _detailRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: AppColors.textSecondary,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
        Text(
          value,
          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
        ),
      ],
    );
  }

  Widget _chartPlaceholder(String label) {
    return Container(
      height: 120,
      decoration: BoxDecoration(
        color: AppColors.shellBg,
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
          const Spacer(),
          const Center(
            child: Icon(FluentIcons.chart, size: 28, color: AppColors.primary),
          ),
          const SizedBox(height: 8),
          const Text(
            'Chart preview',
            style: TextStyle(color: AppColors.textSecondary, fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _sectionLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: AppColors.textSecondary,
        ),
      ),
    );
  }

  Widget _checkItem(String label, bool checked) {
    return Row(
      children: [
        Icon(
          checked ? FluentIcons.check_mark : FluentIcons.cancel,
          size: 16,
          color: checked ? AppColors.primary : AppColors.textSecondary,
        ),
        const SizedBox(width: 10),
        Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
      ],
    );
  }

  Widget _tagItem(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.shellBg,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
    );
  }

  Widget _analysisRow({
    required String title,
    required String description,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(fontWeight: FontWeight.w700, color: color),
          ),
          const SizedBox(height: 8),
          Text(
            description,
            style: const TextStyle(color: AppColors.textSecondary, height: 1.4),
          ),
        ],
      ),
    );
  }

  Widget _emotionButton(String emoji) {
    return Container(
      width: 44,
      height: 44,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: AppColors.shellBg,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Text(emoji, style: const TextStyle(fontSize: 18)),
    );
  }
}
