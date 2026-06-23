import 'package:fluent_ui/fluent_ui.dart';

import '../../../../app/theme/app_colors.dart';
import 'journal_shared_widgets.dart';

class JournalHeader extends StatelessWidget {
  final String title;
  final VoidCallback? onBack;

  const JournalHeader({super.key, required this.title, this.onBack});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Button(
                onPressed: onBack ?? () {},
                style: ButtonStyle(
                  padding: WidgetStatePropertyAll(
                    EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(FluentIcons.chevron_left, size: 12),
                    SizedBox(width: 4),
                    Text('Journal', style: TextStyle(fontSize: 12)),
                  ],
                ),
              ),
              SizedBox(height: 8),
              Row(
                children: [
                  Text(
                    title,
                    style: TextStyle(fontSize: 26, fontWeight: FontWeight.w700),
                  ),
                  SizedBox(width: 12),
                  JournalPill(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          FluentIcons.lightning_bolt,
                          size: 12,
                          color: AppColors.warning,
                        ),
                        SizedBox(width: 4),
                        Text('Auto'),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(18),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.3),
                    blurRadius: 18,
                    offset: Offset(0, 8),
                  ),
                ],
              ),
              child: Text(
                'Log emotions + lessons instantly',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            SizedBox(height: 8),
            Row(
              children: [
                JournalOutlineAction(
                  icon: FluentIcons.share,
                  label: 'Share trade',
                ),
                SizedBox(width: 8),
                JournalOutlineAction(
                  icon: FluentIcons.previous,
                  label: 'Previous',
                ),
                SizedBox(width: 8),
                JournalOutlineAction(
                  icon: FluentIcons.next,
                  label: 'Next Trade',
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
