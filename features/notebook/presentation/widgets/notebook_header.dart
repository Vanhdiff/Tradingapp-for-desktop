import 'package:fluent_ui/fluent_ui.dart';

import '../../../../app/theme/app_colors.dart';

class NotebookHeader extends StatelessWidget {
  const NotebookHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          'Notebook',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w800,
            color: AppColors.textPrimary,
          ),
        ),
        SizedBox(width: 14),
        Expanded(
          child: Text(
            'Think before you trade. Review before you repeat.',
            style: TextStyle(
              fontSize: 12,
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        DropDownButton(
          style: ButtonStyle(
            backgroundColor: WidgetStatePropertyAll(AppColors.primary),
            foregroundColor: WidgetStatePropertyAll(Colors.white),
            padding: WidgetStatePropertyAll(
              EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            ),
            shape: WidgetStatePropertyAll(
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
          ),
          title: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(FluentIcons.add, size: 14),
              SizedBox(width: 7),
              Text('New Note', style: TextStyle(fontWeight: FontWeight.w700)),
              SizedBox(width: 4),
              Icon(FluentIcons.chevron_down_small, size: 12),
            ],
          ),
          items: [
            MenuFlyoutItem(
              leading: Icon(FluentIcons.save_template, size: 14),
              text: Text('Create from Template'),
              onPressed: () {},
            ),
            MenuFlyoutItem(
              leading: Icon(FluentIcons.page_add, size: 14),
              text: Text('Create Blank Note'),
              onPressed: () {},
            ),
          ],
        ),
      ],
    );
  }
}
