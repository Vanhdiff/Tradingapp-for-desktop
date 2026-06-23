import 'package:fluent_ui/fluent_ui.dart';

import '../data/journal_sample_data.dart';
import '../widgets/journal_charts_panel.dart';
import '../widgets/journal_header.dart';
import '../widgets/journal_review_panel.dart';
import '../widgets/journal_trade_details_panel.dart';

class JournalPage extends StatefulWidget {
  const JournalPage({super.key});

  @override
  State<JournalPage> createState() => _JournalPageState();
}

class _JournalPageState extends State<JournalPage> {
  final TextEditingController _reflectionController = TextEditingController(
    text: JournalSampleData.initialReflection,
  );

  String _entryConfluence = JournalSampleData.confluences.first;
  String _entryPlan = JournalSampleData.plans.first;
  String _entryEmotion = JournalSampleData.emotions.first;
  String _exitEmotion = 'Disappointed';
  bool _followedPlan = true;

  @override
  void dispose() {
    _reflectionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        const horizontalPadding = 20.0;
        final contentWidth = constraints.maxWidth - horizontalPadding * 2;
        final targetWidth = contentWidth * 0.9;
        final pageWidth = targetWidth < 1120 ? 1120.0 : targetWidth;
        final scrollWidth = pageWidth > contentWidth ? pageWidth : contentWidth;

        return SingleChildScrollView(
          padding: const EdgeInsets.all(horizontalPadding),
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
                      JournalHeader(title: JournalSampleData.title),
                      const SizedBox(height: 18),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: 360,
                            child: JournalTradeDetailsPanel(
                              netPnl: JournalSampleData.netPnl,
                              instrument: JournalSampleData.instrument,
                              direction: JournalSampleData.direction,
                              lotSize: JournalSampleData.lotSize,
                            ),
                          ),
                          const SizedBox(width: 18),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                JournalChartsPanel(),
                                const SizedBox(height: 18),
                                JournalReviewPanel(
                                  reflectionController: _reflectionController,
                                  followedPlan: _followedPlan,
                                  onFollowedPlanChanged: _setFollowedPlan,
                                  entryPlan: _entryPlan,
                                  plans: JournalSampleData.plans,
                                  onEntryPlanChanged: (value) {
                                    setState(() => _entryPlan = value);
                                  },
                                  entryConfluence: _entryConfluence,
                                  confluences: JournalSampleData.confluences,
                                  onEntryConfluenceChanged: (value) {
                                    setState(() => _entryConfluence = value);
                                  },
                                  entryEmotion: _entryEmotion,
                                  exitEmotion: _exitEmotion,
                                  emotions: JournalSampleData.emotions,
                                  onEntryEmotionChanged: (value) {
                                    setState(() => _entryEmotion = value);
                                  },
                                  onExitEmotionChanged: (value) {
                                    setState(() => _exitEmotion = value);
                                  },
                                ),
                              ],
                            ),
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

  void _setFollowedPlan(bool value) {
    setState(() => _followedPlan = value);
  }
}
