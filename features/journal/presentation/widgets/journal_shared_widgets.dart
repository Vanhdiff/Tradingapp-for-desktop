import 'package:fluent_ui/fluent_ui.dart';

import '../../../../app/theme/app_colors.dart';

class JournalSectionLabel extends StatelessWidget {
  final String text;

  const JournalSectionLabel(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 7),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: AppColors.textSecondary,
        ),
      ),
    );
  }
}

class JournalComboField extends StatelessWidget {
  final String label;
  final String value;
  final List<String> items;
  final ValueChanged<String> onChanged;

  const JournalComboField({
    super.key,
    required this.label,
    required this.value,
    required this.items,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return JournalFieldShell(
      label: label,
      child: ComboBox<String>(
        value: value,
        isExpanded: true,
        items: items
            .map((item) => ComboBoxItem(value: item, child: Text(item)))
            .toList(),
        onChanged: (nextValue) {
          if (nextValue != null) {
            onChanged(nextValue);
          }
        },
      ),
    );
  }
}

class JournalFieldShell extends StatelessWidget {
  final String label;
  final Widget child;

  const JournalFieldShell({
    super.key,
    required this.label,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [JournalSectionLabel(label), child],
    );
  }
}

class JournalMiniTag extends StatelessWidget {
  final String label;
  final bool removable;

  const JournalMiniTag(this.label, {super.key, this.removable = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.shellBg,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
          ),
          if (removable) ...[
            const SizedBox(width: 6),
            const Icon(
              FluentIcons.cancel,
              size: 10,
              color: AppColors.textSecondary,
            ),
          ],
        ],
      ),
    );
  }
}

class JournalOutlineAction extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback? onPressed;

  const JournalOutlineAction({
    super.key,
    required this.icon,
    required this.label,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Button(
      onPressed: onPressed ?? () {},
      style: ButtonStyle(
        padding: const WidgetStatePropertyAll(
          EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: AppColors.primary),
          const SizedBox(width: 6),
          Text(
            label,
            style: const TextStyle(color: AppColors.primary, fontSize: 12),
          ),
        ],
      ),
    );
  }
}

class JournalPill extends StatelessWidget {
  final Widget child;

  const JournalPill({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: AppColors.shellBg,
        borderRadius: BorderRadius.circular(12),
      ),
      child: DefaultTextStyle(
        style: const TextStyle(
          color: AppColors.textSecondary,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
        child: child,
      ),
    );
  }
}
